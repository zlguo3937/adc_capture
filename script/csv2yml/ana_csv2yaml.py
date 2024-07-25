import csv
import sys
import yaml


class RegisterParser:
    def __init__(self):
        self.regs_type_list = ['ID', 'OD', 'IDH', 'ODH', 'OCK', 'PIOA', 'PIA', 'POA', 'IA', 'OA']
        self.apb_type_list = ['ro', 'rw', 'raw', 'wo', 'rc', 'sc', 'rwc', 'lh', 'll']
        self.cpu_type_list = ['ro', 'rw', 'raw', 'wo', 'rc', 'sc', 'rwc', 'lh', 'll']
        self.mdio_type_list = ['ro', 'rw', 'raw', 'wo', 'rc', 'sc', 'rwc', 'lh', 'll']
        self.dev_type_list = ['ro', 'rw', 'raw', 'wo', 'we', 'none']

    def parse_bit_range(self, bit_range):
        reg_range = bit_range.strip()
        int_range = reg_range.strip("[]")
        if ':' in reg_range:
            msb, lsb = map(int, int_range.split(":"))
        else:
            msb = lsb = int(int_range)
        return msb, lsb

    def parse_reg_init(self, init, msb, lsb):
        init = int(init.strip(), 16)
        if init == '':
            print("WARNING: Empty Default Value!")
            sys.exit(-1)
        elif init >= (2 ** (msb - lsb + 1)):
            print("ERROR: %d bits Width: %d too small can't contain: %d" % (
                msb - lsb + 1, (2 ** (msb - lsb + 1)), init))
            sys.exit(-1)
        return init

    def parse_apb_tpe(self, regs_type):
        apb_type = self.parse_reg_type(regs_type)
        if apb_type == 'RWR':
            apb_type = 'rw'
        elif apb_type == 'RORSYNC':
            apb_type = 'ro'
        if apb_type not in self.apb_type_list:
            print("ERROR: Your Register type must be in apb_type_list!")
            print(apb_type)
            sys.exit(-1)
        return apb_type

    def parse_cpu_tpe(self, regs_type):
        cpu_type = self.parse_reg_type(regs_type)
        if cpu_type == 'RWR':
            cpu_type = 'rw'
        elif cpu_type == 'RORSYNC':
            cpu_type = 'ro'
        if cpu_type not in self.cpu_type_list:
            print("ERROR: Your Register type must be in cpu_type_list!")
            print(cpu_type)
            sys.exit(-1)
        return cpu_type

    def parse_mdio_tpe(self, regs_type):
        mdio_type = self.parse_reg_type(regs_type)
        if mdio_type == 'RWR':
            mdio_type = 'rw'
        elif mdio_type == 'RORSYNC':
            mdio_type = 'ro'
        if mdio_type not in self.mdio_type_list:
            print("ERROR: Your Register type must be in mdio_type_list!")
            print(mdio_type)
            sys.exit(-1)
        return mdio_type

    def parse_dev_tpe(self, regs_type):
        dev_type = self.parse_reg_type(regs_type)
        if dev_type == 'RORSYNC':
            dev_type = 'wo'
        elif dev_type == 'RWR':
            dev_type = 'ro'
        else:
            dev_type = 'none'
        if dev_type not in self.dev_type_list:
            print("ERROR: Your Register type must be in dev_type_list!")
            print(dev_type)
            sys.exit(-1)
        return dev_type

    def parse_reg_type(self, regs_type):
        if regs_type != '' and regs_type not in self.regs_type_list:
            print("ERROR: Your Register type must be in regs_type_list!")
            print(regs_type)
            sys.exit(-1)

        if regs_type == 'ID':
            return 'RWR'
        elif regs_type == 'OD':
            return 'RORSYNC'
        elif regs_type in ['IDH', 'IA']:
            return 'output'
        elif regs_type in ['ODH', 'OCK', 'OA']:
            return 'input'
        elif regs_type in ['PIOA', 'PIA', 'POA']:
            return 'PIN'

    def parse_reg_name(self, reg_name, all_regs):
        if reg_name in all_regs:
            print("ERROR: Your Register name must be exclusive in all regs!")
            print(reg_name)
            sys.exit(-1)
        return reg_name

    def read_csv_to_yaml(self, csv_file):
        address = 0
        reg_name: str = ""
        desc: str = ""

        addresses = set()
        reg_group_names = set()

        regs_info = []

        with open(csv_file, 'r') as file:
            reader = csv.reader(file)
            all_regs = []
            for row in reader:
                if not any(row):  # Skip empty lines
                    continue

                if row[0].startswith("##"):
                    reg_name = row[0][2:]
                    if reg_name != '' and reg_name in reg_group_names:
                        print("ERROR: Your Register reg_name must be exclusive in all regs!")
                        print(reg_name)
                        sys.exit(-1)
                    else:
                        reg_group_names.add(reg_name)
                    desc = row[0][2:]

                    if address in addresses:
                        print("ERROR: Your Register address must be exclusive in all regs!")
                        print(address)
                        sys.exit(-1)
                    else:
                        addresses.add(address)
                    reg_info = {
                        'address': hex(address),
                        'reg_name': reg_name,
                        'desc': desc,
                        'fields': [],
                        'ana_io': []
                    }
                    address = address + 1
                    regs_info.append(reg_info)
                elif row[0].startswith("["):
                    msb, lsb = self.parse_bit_range(row[0])
                    width = msb - lsb + 1
                    type_reg = {}
                    type_reg['apb'] = self.parse_apb_tpe(row[3].strip())
                    type_reg['cpu'] = self.parse_cpu_tpe(row[3].strip())
                    type_reg['mdio'] = self.parse_mdio_tpe(row[3].strip())
                    type_reg['dev'] = self.parse_dev_tpe(row[3].strip())
                    field_info = {
                        'name': self.parse_reg_name(row[1].strip(), all_regs),
                        'type': self.parse_reg_type(row[3].strip()),
                        'range': row[0],
                        'msb': msb,
                        'lsb': lsb,
                        'width': width,
                        'init': hex(self.parse_reg_init(row[5], msb, lsb)),
                        'field_type': type_reg,
                        'dc_scan_mode': row[6],
                        'disable_scan': row[7],
                        'occ_scan_mode': row[8],
                        'special_dft_control': row[9],
                    }
                    reg_info['fields'].append(field_info)
                    all_regs.append(row[1].strip())
                elif row[0].strip() == '':
                    ana_io_info = {
                        'name': self.parse_reg_name(row[1].strip(), all_regs),
                        'type': self.parse_reg_type(row[3].strip()),
                        'width': row[2],
                        'dc_scan_mode': row[6],
                        'disable_scan': row[7],
                        'occ_scan_mode': row[8],
                        'special_dft_control': row[9],
                    }
                    reg_info['ana_io'].append(ana_io_info)
        return regs_info


class CSVToYAMLConverter:
    def __init__(self, csv_path, yaml_path):
        self.csv_path = csv_path
        self.yaml_path = yaml_path
        self.parser = RegisterParser()

    def convert(self):
        blocks = self.parser.read_csv_to_yaml(self.csv_path)
        with open(self.yaml_path, 'w') as yaml_file:
            yaml.dump(blocks, yaml_file, default_flow_style=False, sort_keys=False)


def main():
    if len(sys.argv) != 3:
        print("Error: python3 csv_to_yaml.py <csv_path> <yml_path>")
        sys.exit(-1)

    csv_path = sys.argv[1]
    yml_path = sys.argv[2]

    converter = CSVToYAMLConverter(csv_path, yml_path)
    converter.convert()
    print(f"Conversion {yml_path} successfully!")


if __name__ == "__main__":
    main()
