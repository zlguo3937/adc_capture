import sys
import os
import re
import csv
import yaml


def read_yaml(path):
    with open(path, 'r') as f:
        result = yaml.load(f, Loader=yaml.FullLoader)
    return result


class MyDumper(yaml.Dumper):
    def increase_indent(self, flow=False, indentless=False):
        return super(MyDumper, self).increase_indent(flow, False)


class Parser:

    def __init__(self, data_width):
        self.regs_type_list = ['ROR', 'ROD', 'RODEV', 'RWR', 'RWD', 'RWDEV',
                               'RORSYNC', 'RODSYNC', 'RODEVSYNC', 'RWRSYNC',
                               'RWDSYNC', 'RWDEVSYNC', 'CONST', 'SC', 'RC',
                               'ROLH', 'ROLL', 'CMRW', 'CMRO', 'CMRC', 'MCRO',
                               'MCRC', 'LHRC', 'CPUROLH', 'CPUROLL', 'INC_CNT',
                               'RCSYNC'
                               ]
        self.data_width = data_width
        self.addr_width = 10

    def is_not_empty_line(self, line):
        return any(item.strip() != '' for item in line)

    def read_csv(self, doc_file):
        reg_file_blocks = []
        block = []
        event = {}
        maybe_block = False
        block_begin = False
        with open(doc_file, 'r') as csv_file:
            doc_reader = csv.reader(csv_file)
            for row in doc_reader:
                if self.is_not_empty_line(row):
                    if block_begin:
                        block.append(row)
                    elif "#" in row[0] and not maybe_block:
                        maybe_block = True
                        block.append(row)
                    elif "#" not in row[0] and maybe_block and "addr=" in row[1]:
                        block_begin = True
                        maybe_block = False
                        block.append(row)
                    elif "#" in row[0] and maybe_block:
                        maybe_block = False
                        block = []

                    if '$' == row[0]:
                        event[row[1]] = row[2]
                else:
                    if block and block_begin:
                        block_begin = False
                        reg_file_blocks.append(block)
                        block = []
                    else:
                        block = []
                        maybe_block = []
                        block_begin = []
        if block:
            reg_file_blocks.append(block)

        return reg_file_blocks, event

    def parse_regs_line(self, name, addr, line, has_existed_lsb):
        regs_type_list = self.regs_type_list

        init = line[2]
        regs_type = line[3]
        dev_port = line[5]
        event = line[6]
        group = line[7]
        clk_domain = line[8]

        if ":hard" in line[9]:
            sw_rstn = ""
            hw_rstn = line[9].split(":")[0]
        else:
            sw_rstn = line[9]
            hw_rstn = ""

        desc = line[10].replace("\n", " ")
        # inst_prefix = line[11]
        scan = "N"

        msb_lsb = list(map(int, line[1][1:-1].split(":")))
        if len(msb_lsb) == 1:
            msb = msb_lsb[0]
            lsb = msb_lsb[0]
        else:
            msb, lsb = msb_lsb

        regs_type = regs_type.upper() if regs_type.upper() in regs_type_list else "ERROR %s" % regs_type
        if "ERROR" in regs_type:
            print("ERROR: R/W Property must be in 'regs_type'!")
            print(line)
            print(regs_type)
            sys.exit(-1)

        if msb >= has_existed_lsb:
            print(msb)
            print(has_existed_lsb)
            print("ERROR: 0x%x has overlapped!" % addr)
            print(line)
            print(msb, has_existed_lsb)
            sys.exit(-1)
        elif msb < lsb:
            print("ERROR: Width_Type should be [msb:lsb]")
            print(line)
            print("msb %d, lsb %d" % (msb, lsb))
            sys.exit(-1)

        if init == '':
            print("WARNNING: Empty Default Value!")
            print(line)
            sys.exit(-1)
        else:
            init = int(init, 16)
            if init >= (2 ** (msb - lsb + 1)):
                print("ERROR: %d bits Width: %d too small can't contain: %d" % (
                    msb - lsb + 1, (2 ** (msb - lsb + 1)), init))
                print(line)
                sys.exit(-1)

        special_chars = ['?', '/', '[', ']']
        regs_info = dict(
            name=name,
            init=init,
            regs_type=regs_type,
            dev_port=dev_port,
            event=event,
            group=group,
            clk_domain=clk_domain,
            sw_rstn=sw_rstn,
            hw_rstn=hw_rstn,
            desc="\"%s\"" % desc if any(x in desc for x in special_chars) else desc,
            # inst_prefix=inst_prefix,
            scan=scan
        )

        if msb == lsb:
            regs_info["range"] = "[%d]" % msb
        else:
            regs_info["range"] = "[%d:%d]" % (msb, lsb)

        return regs_info, lsb

    def genConfig(self, doc_file):
        rfconfig = dict()
        regs_dict = dict()
        addrs_dict = dict()

        all_regs_list = []

        blocks, event = self.read_csv(doc_file)

        for idx, block in enumerate(blocks):
            block_name = ""
            block_desc = ""
            block_addr = -1
            block_regs = []
            parsed_lsb = self.data_width

            for field in block:
                # 0. Tag info
                if '$' == field[0]:
                    event[field[1]] = field[2].strip()
                    continue
                elif '$' in field[0]:
                    continue

                # 1. Register File Entry Description
                if '#' in field[0]:
                    if "[" in field[1]:
                        continue
                    elif block_name == "":
                        block_name = field[2]
                        block_desc = ",".join(field)
                    else:
                        print("ERROR: Block Name %s ALREADY EXIST!" % block_name)
                        sys.exit(-1)
                # 2. Register File Address (if specify)
                elif "# addr=" in field[1]:
                    raw_addr = field[1].split("=")[1]
                    block_addr = int(raw_addr, 16)
                # 3. Parse Field Line
                elif field[3].upper() != "RSVD":
                    field_name = field[4].strip()
                    if field_name in all_regs_list:
                        print("ERROR: %s ALREADY EXIST!" % field_name)
                        sys.exit(-1)
                    block_regs.append(field_name)
                    all_regs_list.append(field_name)
                    regs_dict[field_name], parsed_lsb = self.parse_regs_line(field_name, block_addr, field, parsed_lsb)
                elif field[4].upper() == "RSVD":
                    print("WARNNING: Ingore RSVD Field!")
                    print(field)
                    continue
                else:
                    print("ERROR: Line Invalid!")
                    print(field)

            if block_addr in addrs_dict:
                print("ERROR: Addr already exist!")
                print(block)
                print(addrs_dict[block_addr])
                sys.exit(-1)

            if block_regs:
                addrs_dict[block_addr] = dict()
                addrs_dict[block_addr]["name"] = block_name
                addrs_dict[block_addr]["desc"] = block_desc
                addrs_dict[block_addr]["regs"] = block_regs

        for name, info in regs_dict.items():
            if event:
                event_name = info["event"].strip()
                if event_name != "":
                    info["event"] = {event_name: event[event_name]}

        rfconfig["all_regs_list"] = all_regs_list
        rfconfig["regs"] = regs_dict
        rfconfig["addrs"] = addrs_dict
        rfconfig["addr_width"] = self.addr_width
        rfconfig["event"] = event

        return rfconfig

    def write_event(self, writer, name, tpe):
        header = dict(
            block="$",
            fields=name,
            reset=tpe,
            field_type="",
            name="",
            dev_port_name="",
            event="",
            group="",
            clk_domain="",
            soft_rstn="",
            description=""
            # inst_prefix=""
        )
        writer.writerow(header)

    def writer_comment(self, writer, comment):
        header = dict(
            block=comment[0],
            fields=comment[1],
            reset=comment[2],
            field_type="",
            name="",
            dev_port_name="",
            event="",
            group="",
            clk_domain="",
            soft_rstn="",
            description=""
            # inst_prefix=""
        )
        writer.writerow(header)

    def writer_addr(self, writer, addr):
        def to_mdio_addr(addr):
            page = addr >> 5
            adr = addr & 0b11111
            return page, adr

        header = dict(
            block="",
            fields="# addr=(%d %d)" % to_mdio_addr(addr),
            reset="reset",
            field_type="field_type",
            name="name",
            dev_port_name="dev_port_name",
            event="event",
            group="group",
            clk_domain="clk_domain",
            soft_rstn="soft_rstn",
            description="description"
            # inst_prefix="inst_prefix"
        )
        writer.writerow(header)

    def dump_csv(self, file_path, contents):
        fieldnames = ["block", "fields", "reset", "field_type", "name", "dev_port_name", "event", "group",
                      "clk_domain", "soft_rstn", "description"  # "inst_prefix"
                      ]

        event_dict = {}
        for block in contents:
            for info in block["fields"]:
                event = info["event"]
                if event == "":
                    continue
                elif event.keys()[0] not in event_dict:
                    event_dict.update(event)
                else:
                    continue

        with open(file_path, mode='wb') as csv_file:
            writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
            for name, tpe in event_dict.items():
                self.write_event(writer, name, tpe)
            for block in contents:
                addr = int(block["addresss"], 16)
                self.writer_comment(writer, block["comment"].split(","))
                self.writer_addr(writer, addr)
                for info in block["fields"]:
                    name = info["name"]
                    if info["event"] == "":
                        event = ""
                    else:
                        event = info["event"].keys()[0]
                    row = dict(
                        block="",
                        fields=info["range"],
                        reset=hex(info["init"]),
                        field_type=info["field_type"],
                        name=name,
                        dev_port_name=info["dev_port"],
                        event=event,
                        group=info["group"],
                        clk_domain=info["clk_domain"],
                        soft_rstn=info["sw_rstn"],
                        description=info["desc"],
                        # inst_prefix=info["inst_prefix"]
                    )
                    writer.writerow(row)


if __name__ == "__main__":
    dir_base = sys.argv[1]
    cfg_path = sys.argv[2]
    cfg = read_yaml(cfg_path)

    for name, info in cfg.items():
        csv_path = os.path.join(dir_base, info["csv"])
        yaml_path = os.path.join(dir_base, info["yml"])

        if "width" in info:
            data_width = int(info["width"])
        else:
            data_width = 16
        csv_parser = Parser(data_width)

        yaml_file = open(yaml_path, 'w')

        res = csv_parser.genConfig(csv_path)

        dump_list = []
        addr_regs = res["addrs"]
        reg_fields = res["regs"]

        block_dict = {"bus_type": "", "width_address": "", "width_data": "", "description": "", "blocks": []}

        for addr in sorted(addr_regs):
            reg_dict = {"desc": addr_regs[addr]["desc"], "reg_name": addr_regs[addr]["name"], "address": hex(addr),
                        "fields": []
                        }
            for n in addr_regs[addr]["regs"]:
                reg_dict["fields"].append(reg_fields[n])

            block_dict["blocks"].append(reg_dict)
        yaml.dump(block_dict, yaml_file, Dumper=MyDumper, default_flow_style=False, allow_unicode=True, sort_keys=False)
