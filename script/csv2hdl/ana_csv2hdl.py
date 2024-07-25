import sys
import re
import yaml


class RegfileParser:
    def read_yaml(self, yml_path):
        with open(yml_path, 'r') as yaml_file:
            return yaml.safe_load(yaml_file)

    def get_dft_ana_ports_declarations(self, yaml_data):
        dft_ana_ports = set()
        for group in yaml_data:
            for reg in group['fields']:
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                field_name = reg['name']
                if reg['type'] == "RWR" and reg['special_dft_control'] == "Configurable":
                    dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{reg['name']}")
            for port in group['ana_io']:
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                if port['type'] == "output" and port['special_dft_control'] == "Configurable":
                    dft_ana_ports.add(f"    input   wire    {width:8} DFT_{port['name']}")
        return dft_ana_ports

    def get_ana_input_ports_declarations(self, yaml_data):
        ana_input_ports = set()
        for group in yaml_data:
            for reg in group['fields']:
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                if reg['type'] == "RWR":
                    ana_input_ports.add(f"    input   wire    {width_str:8} {reg['name']}")
            for port in group['ana_io']:
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                if port['type'] == "output":
                    ana_input_ports.add(f"    input   wire    {width:8} {port['name']}")
        return ana_input_ports

    def get_ana_output_ports_declarations(self, yaml_data):
        ana_output_ports = set()
        for group in yaml_data:
            for reg in group['fields']:
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                if reg['type'] == "RORSYNC":
                    ana_output_ports.add(f"    output  wire    {width_str:8} {reg['name']}")
            for port in group['ana_io']:
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                if port['type'] == "input":
                    ana_output_ports.add(f"    output  wire    {width:8} {port['name']}")
        return ana_output_ports

    def get_ANA_output_ports_declarations(self, yaml_data):
        ana_output_ports = set()
        for group in yaml_data:
            for reg in group['fields']:
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                if reg['type'] == "RWR":
                    ana_output_ports.add(f"    output  wire    {width_str:8} ANA_{reg['name']}")
            for port in group['ana_io']:
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                if port['type'] == "output":
                    ana_output_ports.add(f"    output  wire    {width:8} ANA_{port['name']}")
        return ana_output_ports

    def get_ANA_input_ports_declarations(self, yaml_data):
        ana_input_ports = set()
        for group in yaml_data:
            for reg in group['fields']:
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                if reg['type'] == "RORSYNC":
                    ana_input_ports.add(f"    input   wire    {width_str:8} ANA_{reg['name']}")
            for port in group['ana_io']:
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                if port['type'] == "input":
                    ana_input_ports.add(f"    input   wire    {width:8} ANA_{port['name']}")
        return ana_input_ports

    def get_dig_to_ana_logic_without_dft(self, yaml_data):
        dig_to_ana_assign = set()
        for group in yaml_data:
            for reg in group['fields']:
                if reg['type'] == "RWR" and reg['special_dft_control'] != "Configurable":
                    dig_to_ana_assign.add(f"    assign ANA_{reg['name']} = {reg['name']};")
            for port in group['ana_io']:
                if port['type'] == "output" and port['special_dft_control'] != "Configurable":
                    dig_to_ana_assign.add(f"    assign ANA_{port['name']} = {port['name']};")
        return dig_to_ana_assign

    def get_ana_to_dig_logic_without_dft(self, yaml_data):
        ana_to_dig_assign = set()
        for group in yaml_data:
            for reg in group['fields']:
                if reg['type'] == "RORSYNC" and reg['special_dft_control'] != "Configurable":
                    ana_to_dig_assign.add(f"    assign {reg['name']} = ANA_{reg['name']};")
            for port in group['ana_io']:
                if port['type'] == "input" and port['special_dft_control'] != "Configurable":
                    ana_to_dig_assign.add(f"    assign {port['name']} = ANA_{port['name']};")
        return ana_to_dig_assign

    def generate_verilog_code(self, yaml_data, module_name):
        yaml_data = self.read_yaml(yaml_data)
        # Initial module definition with fixed inputs and outputs
        verilog_content = (f'''\
module {module_name}
(
''').format(module_name=module_name)

        dft_ana_ports = self.get_dft_ana_ports_declarations(yaml_data)
        ana_input_ports = self.get_ana_input_ports_declarations(yaml_data)
        ana_output_ports = self.get_ana_output_ports_declarations(yaml_data)
        ANA_input_ports = self.get_ANA_input_ports_declarations(yaml_data)
        ANA_output_ports = self.get_ANA_output_ports_declarations(yaml_data)
        dig_to_ana_logic_without_dft = self.get_dig_to_ana_logic_without_dft(yaml_data)
        ana_to_dig_logic_without_dft = self.get_ana_to_dig_logic_without_dft(yaml_data)

        verilog_content += "    // ana_dft_ctrl"
        verilog_content += "\n    input                    ana_dft_ctrl," + "\n\n"

        verilog_content += "    // dft ana signal\n"
        verilog_content += ",\n".join(sorted(dft_ana_ports)) + "\n\n"

        verilog_content += "    // input_ports_from_dig\n"
        verilog_content += ",\n".join(sorted(ana_input_ports)) + "\n\n"

        verilog_content += "    // output_ports_to_dig\n"
        verilog_content += ",\n".join(sorted(ana_output_ports)) + "\n\n"

        verilog_content += "    // input_ports_from_ana\n"
        verilog_content += ",\n".join(sorted(ANA_input_ports)) + "\n\n"

        verilog_content += "    // output_ports_to_ana\n"
        verilog_content += ",\n".join(sorted(ANA_output_ports)) + "\n);\n"

        # assigns
        verilog_content += "    // dig_to_ana_logic_without_dft\n"
        verilog_content += "\n".join(sorted(dig_to_ana_logic_without_dft)) + "\n\n"

        verilog_content += "    // ana_to_dig_logic_without_dft\n"
        verilog_content += "\n".join(sorted(ana_to_dig_logic_without_dft)) + "\n\n"

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
        print("Error!!! The commond should be: python3 ana_csv2yaml.py <csv_path> <hdl_path> <module_name>")
        sys.exit(-1)

    yml_path = sys.argv[1]
    hdl_path = sys.argv[2]
    module_name = sys.argv[3]

    converter = YMLToHDLConverter(yml_path, hdl_path, module_name)
    converter.convert()
    print(f"Conversion {hdl_path} successfully!")


if __name__ == "__main__":
    main()
