import sys

import yaml


class RegfileParser:
    def read_yaml(self, yml_path):
        with open(yml_path, 'r') as yaml_file:
            return yaml.safe_load(yaml_file)

    def get_port_declarations(self, yaml_data):
        port_declarations = set()
        for group in yaml_data:
            for reg in group['register']:
                reg_type = reg['type']
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""

                if reg_type in ["RC", "ROLH", "ROLL", "CMRO", "CMRC", "MCRO", "MCRC", "LHRC"]:
                    port_declarations.add(f"    input   wire            is_mdio)\n")

                if reg_type in ["RODEVSYNC", "RWRSYNC", "RWDSYNC", "RWDEVSYNC"]:
                    port_declarations.add(f"    input   wire            {reg['name']}_dev_clk")
                    port_declarations.add(f"    input   wire            {reg['name']}_dev_rstn")

                if reg_type in ["RWR", "RWD", "RWDEV", "RWRSYNC", "RWDSYNC", "SC"]:
                    port_declarations.add(f"    output  wire    {width_str:8} {reg['name']}_rdata")

                if reg_type in ["ROR", "ROD", "RODEV", "RWDEV", "RORSYNC", "RODSYNC", "RODEVSYNC", "RWDEVSYNC", "RC",
                                "ROLH", "ROLL"]:
                    port_declarations.add(f"    input   wire    {width_str:8} {reg['name']}_wdata")

                if reg_type in ["RODEV", "RWDEV", "RODEVSYNC", "RWDEVSYNC", "RC"]:
                    port_declarations.add(f"    input   wire             {reg['name']}_we")

        return port_declarations

    def get_clk_wires(self, yaml_data):
        clk_wires = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] not in ["CONST"]:
                    clk_wires.append(f"    {'wire' :<16}{reg['name']}_clk;")
        return clk_wires

    def get_rstn_wires(self, yaml_data):
        rstn_wires = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] not in ["CONST"]:
                    rstn_wires.append(f"    {'wire' :<16}{reg['name']}_rstn;")
        return rstn_wires

    def get_is_mdio_wires(self, yaml_data):
        is_mdio_wires = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] in ["RC", "ROLH", "ROLL", "CMRO", "CMRC", "MCRO", "MCRC", "LHRC"]:
                    is_mdio_wires.append(f"    {'wire' :<16}{reg['name']}_is_mdio;")
        return is_mdio_wires

    def get_bus_we_wires(self, yaml_data):
        bus_we_wires = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] in ["RWR", "RWD", "RWDEV", "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "SC", "CMRW", "CMRO",
                                   "CMRC", "MCRO", "MCRC", "LHRC"]:
                    bus_we_wires.append(f"    {'wire' :<16}{reg['name']}_bus_we;")
        return bus_we_wires

    def get_bus_wdata_wires(self, yaml_data):
        bus_wdata_wires = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] in ["RWR", "RWD", "RWDEV", "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "SC", "CMRW", "CMRO",
                                   "CMRC", "MCRO", "MCRC", "LHRC"]:
                    width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                    bus_wdata_wires.append(f"    {'wire' :<8}{width_str:8}{reg['name']}_bus_wdata;")
        return bus_wdata_wires

    def get_bus_re_wires(self, yaml_data):
        bus_re_wires = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] in ["RC", "ROLH", "ROLL", "CMRC", "MCRC", "LHRC"]:
                    bus_re_wires.append(f"    {'wire' :<16}{reg['name']}_bus_re;")
        return bus_re_wires

    def get_bus_rdata_wires(self, yaml_data):
        bus_rdata_wires = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] in ["ROR", "ROD", "RODEV", "RWR", "RWD", "RWDEV", "RORSYNC", "RODSYNC", "RODEVSYNC",
                                   "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "RC", "ROLH", "ROLL", "CMRW", "CMRO", "CMRC",
                                   "MCRO",
                                   "MCRC", "LHRC"]:
                    width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                    bus_rdata_wires.append(f"    {'wire' :<8}{width_str:8}{reg['name']}_bus_rdata;")
        return bus_rdata_wires

    def get_addr_selects_wires(self, yaml_data):
        addr_selects_wires = []
        for group in yaml_data:
            address = group['address']
            addr_selects_wires.append(f"    {'wire' :<16}addr_{address}_sel;")
        return addr_selects_wires

    def get_addr_selects_bus_rdata_wires(self, yaml_data):
        addr_selects_bus_rdata_wires = []
        for group in yaml_data:
            address = group['address']
            addr_selects_bus_rdata_wires.append(f"    {'wire' :<8}{'[15:0]':8}addr_{address}_sel_bus_rdata;")
        return addr_selects_bus_rdata_wires

    def get_sel_addr_bus_rdata_wires(self, yaml_data):
        sel_addr_bus_rdata_wires = []
        for group in yaml_data:
            address = group['address']
            sel_addr_bus_rdata_wires.append(f"    {'wire' :<8}{'[15:0]':8}sel_{address}_bus_rdata;")
        return sel_addr_bus_rdata_wires

    def get_clk_assigns(self, yaml_data):
        clk_assigns = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] not in ["CONST"]:
                    reg_name_clk = reg['name'] + "_clk"
                    clk_assigns.append(f"    assign  {reg_name_clk:30} = clk;")
        return clk_assigns

    def get_rstn_assigns(self, yaml_data):
        rstn_assigns = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] not in ["CONST"]:
                    reg_name_rstn = reg['name'] + "_rstn"
                    rstn_assigns.append(f"    assign  {reg_name_rstn:30} = rstn;")
        return rstn_assigns

    def get_addr_selects_assigns(self, yaml_data):
        addr_selects_assigns = []
        for group in yaml_data:
            address = group['address']
            addr_address_sel = "addr_" + group['address'] + "_sel"
            addr_selects_assigns.append(
                f"    assign  {addr_address_sel:15} = (req_paddr == 21'h{address}) & req_psel & req_penable;")
        return addr_selects_assigns

    def get_bus_is_mdio_assigns(self, yaml_data):
        bus_is_mdio_assigns = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] in ["RC", "ROLH", "ROLL", "CMRO", "CMRC", "MCRO", "MCRC", "LHRC"]:
                    reg_name_is_mdio = reg['name'] + "_is_mdio"
                    bus_is_mdio_assigns.append(f"    assign  {reg_name_is_mdio:30} = rstn;")
        return bus_is_mdio_assigns

    def get_bus_we_assigns(self, yaml_data):
        bus_we_assigns = []
        for group in yaml_data:
            address = group['address']
            for reg in group['register']:
                if reg['type'] in ["RWR", "RWD", "RWDEV", "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "SC", "CMRW", "CMRO",
                                   "CMRC", "MCRO", "MCRC", "LHRC"]:
                    reg_name_bus_we = reg['name'] + "_bus_we"
                    bus_we_assigns.append(f"    assign  {reg_name_bus_we:30} = addr_{address}_sel & req_pwrite;")
        return bus_we_assigns

    def get_bus_wdata_assigns(self, yaml_data):
        bus_wdata_assigns = []
        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] in ["RWR", "RWD", "RWDEV", "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "SC", "CMRW", "CMRO",
                                   "CMRC", "MCRO", "MCRC", "LHRC"]:
                    reg_name_bus_wdata = reg['name'] + "_bus_wdata"
                    if reg['msb'] == reg['lsb']:
                        bus_wdata_assigns.append(
                            f"    assign  {reg_name_bus_wdata:30} = req_pwdata[{reg['msb']}];")
                    else:
                        bus_wdata_assigns.append(
                            f"    assign  {reg_name_bus_wdata:30} = req_pwdata[{reg['msb']}:{reg['lsb']}];")
        return bus_wdata_assigns

    def get_bus_re_assigns(self, yaml_data):
        bus_re_assigns = []
        for group in yaml_data:
            address = group['address']
            for reg in group['register']:
                if reg['type'] in ["RC", "ROLH", "ROLL", "CMRC", "MCRC", "LHRC"]:
                    reg_name_bus_re = reg['name'] + "_bus_re"
                    bus_re_assigns.append(f"    assign  {reg_name_bus_re:30} = addr_{address}_sel & ~pwrite;")
        return bus_re_assigns

    def get_bus_rdata_assigns(self):
        bus_rdata_assigns = [f"    assign  {'req_prdata':20} = sel_0x0_bus_rdata;"]
        return bus_rdata_assigns

    def get_addr_selects_bus_rdata_assigns(self, yaml_data):
        addr_selects_bus_rdata_assigns = []
        for group in yaml_data:
            bit_2_field = {}
            for reg in group['register']:
                if reg['type'] in [
                    "ROR", "ROD", "RODEV", "RWR", "RWD", "RWDEV", "RORSYNC", "RODSYNC", "RODEVSYNC",
                    "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "RC", "ROLH", "ROLL", "CMRW", "CMRO", "CMRC",
                    "MCRO", "MCRC", "LHRC"
                ]:
                    for bit in range(reg['lsb'], reg['msb'] + 1):
                        bit_2_field[bit] = reg['name']

            last_name = ''
            continuous_empty_count = 0
            addr_sel_bus_rdata = []
            for i in reversed(range(16)):
                curr_name = bit_2_field.get(i, '')
                if last_name == curr_name:
                    if curr_name == '':
                        continuous_empty_count += 1
                    else:
                        pass
                else:
                    if last_name == '':
                        if continuous_empty_count == 0:
                            pass
                        else:
                            addr_sel_bus_rdata.append("{}'h0".format(continuous_empty_count))
                        continuous_empty_count = 1
                    else:
                        addr_sel_bus_rdata.append(f"{last_name}_bus_rdata")
                last_name = curr_name
            if last_name == '':
                assert continuous_empty_count
                addr_sel_bus_rdata.append("{}'h0".format(continuous_empty_count))
            else:
                addr_sel_bus_rdata.append(f"{last_name}_bus_rdata")

            addr_selects_bus_rdata = "addr_" + group['address'] + "_sel_bus_rdata"
            addr_selects_bus_rdata_assigns.append(
                "    assign  {} = {{{}}};".format(
                    addr_selects_bus_rdata,
                    ', '.join(addr_sel_bus_rdata)
                )
                # f"    assign {addr_selects_bus_rdata:25} = {{{', '.join(addr_sel_bus_rdata)}}};"
            )

        return addr_selects_bus_rdata_assigns

    def get_sel_addr_bus_rdata_assigns(self, yaml_data):
        sel_addr_bus_rdata_assigns = []
        for i, group in enumerate(yaml_data):
            address = group['address']
            sel_address_bus_rdata = "sel_" + group['address'] + "_bus_rdata"
            if i < len(yaml_data) - 1:
                next_address = yaml_data[i + 1]['address']
                sel_addr_bus_rdata_assigns.append(
                    f"    assign  {sel_address_bus_rdata:20} = (addr_{address}_sel & ~req_pwrite) ? addr_{address}_sel_bus_rdata : sel_{next_address}_bus_rdata;\n")
            else:
                sel_addr_bus_rdata_assigns.append(
                    f"    assign  {sel_address_bus_rdata:20} = (addr_{address}_sel & ~req_pwrite) ? addr_{address}_sel_bus_rdata : 16'h0;\n")
        return sel_addr_bus_rdata_assigns

    def create_register_block(self, reg):
        reg_name = reg['name']
        reg_type = reg['type']
        width = reg['width']
        reset = reg['reset']
        width_str = f"[{width - 1}:0]" if width > 1 else ""

        if reg_type in ["SC", "ROLH", "ROLL", "LHRC"]:
            block = f"    Cell_{reg_type}\n"
            block += f"    u_{reg_name}\n    (\n"
        else:
            block = f"    Cell_{reg_type}#(\n"
            block += f"        .DATA_WIDTH ({width}),\n"
            block += f"        .INIT       ({int(reset, 16)})\n"
            block += f"    ) u_{reg_name}\n    (\n"

        block += f"    .clk            ({reg_name}_clk),\n"
        block += f"    .rstn           ({reg_name}_rstn),\n"

        if reg_type in ["RC", "ROLH", "ROLL", "CMRO", "CMRC", "MCRO", "MCRC", "LHRC"]:
            block += f"    .is_mdio        ({reg_name}_is_mdio),\n"

        if reg_type in ["RWR", "RWD", "RWDEV", "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "SC", "CMRW", "CMRO", "CMRC", "MCRO",
                        "MCRC", "LHRC"]:
            block += f"    .bus_we         ({reg_name}_bus_we),\n"
            block += f"    .bus_wdata      ({reg_name}_bus_wdata),\n"

        if reg_type in ["RC", "ROLH", "ROLL", "CMRC", "MCRC", "LHRC"]:
            block += f"    .bus_re         ({reg_name}_bus_re),\n"

        if reg_type in ["ROR", "ROD", "RODEV", "RWR", "RWD", "RWDEV", "RORSYNC", "RODSYNC", "RODEVSYNC", "RWRSYNC",
                        "RWDSYNC", "RWDEVSYNC", "RC", "ROLH", "ROLL", "CMRW", "CMRO", "CMRC", "MCRO", "MCRC", "LHRC"]:
            block += f"    .bus_rdata      ({reg_name}_bus_rdata),\n"

        if reg_type in ["RODEVSYNC", "RWRSYNC", "RWDSYNC", "RWDEVSYNC"]:
            block += f"    .dev_clk      ({reg_name}_clk),\n"
            block += f"    .dev_rstn     ({reg_name}_rstn),\n"

        if reg_type in ["RODEV", "RWDEV", "RODEVSYNC", "RWDEVSYNC", "RC"]:
            block += f"    .dev_we         ({reg_name}_we),\n"

        if reg_type in ["ROR", "ROD", "RODEV", "RWDEV", "RORSYNC", "RODSYNC", "RODEVSYNC", "RWDEVSYNC", "RC", "ROLH",
                        "ROLL"]:
            block += f"    .dev_wdata      ({reg_name}_wdata),\n"

        if reg_type in ["RWR", "RWD", "RWRSYNC", "RWDSYNC", "SC"]:
            block += f"    .dev_rdata      ({reg_name}_rdata),\n"

        block = block.rstrip(",\n") + "\n"
        block += f"    );\n"
        return block

    def get_register_instance(self, yaml_data):
        register_instance = []
        for group in yaml_data:
            reg_group_name = group['reg_group_name']
            desc = group['desc']
            address = group['address']
            register_instance.append(f"    // ********************************************************************")
            register_instance.append(f"    // desc:{desc} reg_group_name:{reg_group_name} address:{address}")
            register_instance.append(f"    // ********************************************************************")
            for reg in group['register']:
                register_instance.append(self.create_register_block(reg))
        return register_instance

    def generate_verilog_code(self, yaml_data, module_name):
        yaml_data = self.read_yaml(yaml_data)
        # Initial module definition with fixed inputs and outputs
        verilog_content = (f'''\
module {module_name}
(
    input   wire             clk,
    input   wire             rstn,
 
    input   wire    [20:0]   req_paddr,
    input   wire             req_pwrite,
    input   wire             req_psel,
    input   wire             req_penable,
    input   wire    [15:0]   req_pwdata,
 
    output  wire             req_pready,
    output  wire    [15:0]   req_prdata,

''').format(module_name=module_name)

        # Generate port declarations based on the register types in YAML
        ports = self.get_port_declarations(yaml_data)
        verilog_content += ",\n".join(sorted(ports)) + "\n);\n\n"

        # Generate internal wires
        clk_wires = self.get_clk_wires(yaml_data)
        rstn_wires = self.get_rstn_wires(yaml_data)

        is_mdio_wires = self.get_is_mdio_wires(yaml_data)
        bus_we_wires = self.get_bus_we_wires(yaml_data)
        bus_wdata_wires = self.get_bus_wdata_wires(yaml_data)
        bus_re_wires = self.get_bus_re_wires(yaml_data)
        bus_rdata_wires = self.get_bus_rdata_wires(yaml_data)

        addr_selects_wires = self.get_addr_selects_wires(yaml_data)
        addr_selects_bus_rdata_wires = self.get_addr_selects_bus_rdata_wires(yaml_data)
        sel_addr_bus_rdata_wires = self.get_sel_addr_bus_rdata_wires(yaml_data)

        clk_assigns = self.get_clk_assigns(yaml_data)
        rstn_assigns = self.get_rstn_assigns(yaml_data)

        bus_is_mdio_assigns = self.get_bus_is_mdio_assigns(yaml_data)
        bus_we_assigns = self.get_bus_we_assigns(yaml_data)
        bus_wdata_assigns = self.get_bus_wdata_assigns(yaml_data)
        bus_re_assigns = self.get_bus_re_assigns(yaml_data)
        bus_rdata_assigns = self.get_bus_rdata_assigns()

        addr_selects_assigns = self.get_addr_selects_assigns(yaml_data)
        addr_selects_bus_rdata_assigns = self.get_addr_selects_bus_rdata_assigns(yaml_data)
        sel_addr_bus_rdata_assigns = self.get_sel_addr_bus_rdata_assigns(yaml_data)

        register_inst = self.get_register_instance(yaml_data)

        verilog_content += "    // Clock Wires\n"
        verilog_content += "\n".join(clk_wires) + "\n\n"

        verilog_content += "    // Reset Wires\n"
        verilog_content += "\n".join(rstn_wires) + "\n\n"

        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] in ["RC", "ROLH", "ROLL", "CMRO", "CMRC", "MCRO", "MCRC", "LHRC"]:
                    verilog_content += "    // Bus is_mdio Wires\n"
                    verilog_content += "\n".join(is_mdio_wires) + "\n\n"
                elif reg['type'] in ["RC", "ROLH", "ROLL", "CMRC", "MCRC", "LHRC"]:
                    verilog_content += "    // Bus re Wires\n"
                    verilog_content += "\n".join(bus_re_wires) + "\n\n"

        verilog_content += "    // Bus we Wires\n"
        verilog_content += "\n".join(bus_we_wires) + "\n\n"

        verilog_content += "    // Bus wdata Wires\n"
        verilog_content += "\n".join(bus_wdata_wires) + "\n\n"

        verilog_content += "    // Bus rdata Wires\n"
        verilog_content += "\n".join(bus_rdata_wires) + "\n\n"

        verilog_content += "    // Address Select Wires\n"
        verilog_content += "\n".join(addr_selects_wires) + "\n\n"

        verilog_content += "    // Bus rdata whitch Address Selected Wires\n"
        verilog_content += "\n".join(addr_selects_bus_rdata_wires) + "\n\n"

        verilog_content += "    // Select Bus rdata whitch Address Selected Wires\n"
        verilog_content += "\n".join(sel_addr_bus_rdata_wires) + "\n\n"

        verilog_content += "    // register clock and rstn\n"
        verilog_content += "\n".join(clk_assigns) + "\n\n"

        verilog_content += "\n".join(rstn_assigns) + "\n\n"

        verilog_content += "    // whitch address be selected: req_psel & req_penable + req_paddr\n"
        verilog_content += "\n".join(addr_selects_assigns) + "\n\n"

        for group in yaml_data:
            for reg in group['register']:
                if reg['type'] in ["RC", "ROLH", "ROLL", "CMRO", "CMRC", "MCRO", "MCRC", "LHRC"]:
                    verilog_content += "    // bus_we: addr_{address}_sel & req_pwrite\n"
                    verilog_content += "\n".join(bus_is_mdio_assigns) + "\n\n"
                elif reg['type'] in ["RC", "ROLH", "ROLL", "CMRC", "MCRC", "LHRC"]:
                    verilog_content += "    // bus_re: addr_{address}_sel & ~req_pwrite\n"
                    verilog_content += "\n".join(bus_re_assigns) + "\n\n"

        verilog_content += "    // bus_we: addr_{address}_sel & req_pwrite\n"
        verilog_content += "\n".join(bus_we_assigns) + "\n\n"

        verilog_content += "    // req_pwdata: bus_wdata\n"
        verilog_content += "\n".join(bus_wdata_assigns) + "\n\n"

        verilog_content += "    // addr_{address}_sel_bus_rdata = {registers bus_rdata}\n"
        verilog_content += "\n".join(addr_selects_bus_rdata_assigns) + "\n\n"

        verilog_content += "    // req_prdata: bus_rdata\n"
        verilog_content += "\n".join(bus_rdata_assigns) + "\n"
        verilog_content += "".join(sel_addr_bus_rdata_assigns) + "\n"

        verilog_content += "\n".join(register_inst) + "\n"

        verilog_content += "endmodule"

        return verilog_content


class YMLToHDLConverter:
    def __init__(self, yml_path, hdl_path, module_name):
        self.yml_path = yml_path
        self.hdl_path = hdl_path
        self.module_name = module_name
        self.parser = RegfileParser()

    def convert(self):
        blocks = self.parser.generate_verilog_code(self.yml_path, self.module_name)
        with open(self.hdl_path, 'w') as verilog_file:
            # yaml.dump(blocks, verilog_file, default_flow_style=False, sort_keys=False)
            verilog_file.write(blocks)


def main():
    if len(sys.argv) != 4:
        print("Error!!! The commond should be: python3 csv_to_yaml.py <yml_path> <hdl_path> <module_name>")
        sys.exit(-1)

    yml_path = sys.argv[1]
    hdl_path = sys.argv[2]
    module_name = sys.argv[3]

    converter = YMLToHDLConverter(yml_path, hdl_path, module_name)
    converter.convert()


if __name__ == "__main__":
    main()
    print("Conversion completed successfully!")
