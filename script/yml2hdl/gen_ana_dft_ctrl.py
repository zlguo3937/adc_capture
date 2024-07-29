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
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_BWPHYID_name[0]}")
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_BWPHYID_name[1]}")
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_BWPHYID_name[2]}")
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_BWPHYID_name[3]}")
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_SDSPHYID_name[0]}")
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_SDSPHYID_name[1]}")
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_SDSPLLID_name[0]}")
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{new_SDSPLLID_name[1]}")
                    else:
                        dft_ana_ports.add(f"    input   wire    {width_str:8} DFT_{reg['name']}")
            for port in group['ana_io']:
                field_name = port['name']
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                if port['type'] == "output" and port['special_dft_control'] == "Configurable":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_BWPHYID_name[0]}")
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_BWPHYID_name[1]}")
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_BWPHYID_name[2]}")
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_BWPHYID_name[3]}")
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_SDSPHYID_name[0]}")
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_SDSPHYID_name[1]}")
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_SDSPLLID_name[0]}")
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{new_SDSPLLID_name[1]}")
                    else:
                        dft_ana_ports.add(f"    input   wire    {width:8} DFT_{port['name']}")
        return dft_ana_ports

    def get_ana_input_ports_declarations(self, yaml_data):
        ana_input_ports = set()
        for group in yaml_data:
            for reg in group['fields']:
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                field_name = reg['name']
                if reg['type'] == "RWR":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_BWPHYID_name[0]}")
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_BWPHYID_name[1]}")
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_BWPHYID_name[2]}")
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_BWPHYID_name[3]}")
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_SDSPHYID_name[0]}")
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_SDSPHYID_name[1]}")
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_SDSPLLID_name[0]}")
                        ana_input_ports.add(f"    input   wire    {width_str:8} {new_SDSPLLID_name[1]}")
                    else:
                        ana_input_ports.add(f"    input   wire    {width_str:8} {reg['name']}")

            for port in group['ana_io']:
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                field_name = port['name']
                if port['type'] == "output":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ana_input_ports.add(f"    input   wire    {width:8} {new_BWPHYID_name[0]}")
                        ana_input_ports.add(f"    input   wire    {width:8} {new_BWPHYID_name[1]}")
                        ana_input_ports.add(f"    input   wire    {width:8} {new_BWPHYID_name[2]}")
                        ana_input_ports.add(f"    input   wire    {width:8} {new_BWPHYID_name[3]}")
                        ana_input_ports.add(f"    input   wire    {width:8} {new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ana_input_ports.add(f"    input   wire    {width:8} {new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ana_input_ports.add(f"    input   wire    {width:8} {new_SDSPHYID_name[0]}")
                        ana_input_ports.add(f"    input   wire    {width:8} {new_SDSPHYID_name[1]}")
                        ana_input_ports.add(f"    input   wire    {width:8} {new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ana_input_ports.add(f"    input   wire    {width:8} {new_SDSPLLID_name[0]}")
                        ana_input_ports.add(f"    input   wire    {width:8} {new_SDSPLLID_name[1]}")
                    else:
                        ana_input_ports.add(f"    input   wire    {width:8} {port['name']}")

        return ana_input_ports

    def get_ana_output_ports_declarations(self, yaml_data):
        ana_output_ports = set()
        for group in yaml_data:
            for reg in group['fields']:
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                field_name = reg['name']
                if reg['type'] == "RORSYNC":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_BWPHYID_name[0]}")
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_BWPHYID_name[1]}")
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_BWPHYID_name[2]}")
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_BWPHYID_name[3]}")
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_SDSPHYID_name[0]}")
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_SDSPHYID_name[1]}")
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_SDSPLLID_name[0]}")
                        ana_output_ports.add(f"    output  wire    {width_str:8} {new_SDSPLLID_name[1]}")
                    else:
                        ana_output_ports.add(f"    output  wire    {width_str:8} {reg['name']}")

            for port in group['ana_io']:
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                field_name = port['name']
                if port['type'] == "input":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ana_output_ports.add(f"    output  wire    {width:8} {new_BWPHYID_name[0]}")
                        ana_output_ports.add(f"    output  wire    {width:8} {new_BWPHYID_name[1]}")
                        ana_output_ports.add(f"    output  wire    {width:8} {new_BWPHYID_name[2]}")
                        ana_output_ports.add(f"    output  wire    {width:8} {new_BWPHYID_name[3]}")
                        ana_output_ports.add(f"    output  wire    {width:8} {new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ana_output_ports.add(f"    output  wire    {width:8} {new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ana_output_ports.add(f"    output  wire    {width:8} {new_SDSPHYID_name[0]}")
                        ana_output_ports.add(f"    output  wire    {width:8} {new_SDSPHYID_name[1]}")
                        ana_output_ports.add(f"    output  wire    {width:8} {new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ana_output_ports.add(f"    output  wire    {width:8} {new_SDSPLLID_name[0]}")
                        ana_output_ports.add(f"    output  wire    {width:8} {new_SDSPLLID_name[1]}")
                    else:
                        ana_output_ports.add(f"    output  wire    {width:8} {port['name']}")

        return ana_output_ports

    def get_ANA_output_ports_declarations(self, yaml_data):
        ANA_output_ports = set()
        for group in yaml_data:
            for reg in group['fields']:
                field_name = reg['name']
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                if reg['type'] == "RWR":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_BWPHYID_name[0]}")
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_BWPHYID_name[1]}")
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_BWPHYID_name[2]}")
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_BWPHYID_name[3]}")
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_SDSPHYID_name[0]}")
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_SDSPHYID_name[1]}")
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_SDSPLLID_name[0]}")
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{new_SDSPLLID_name[1]}")
                    else:
                        ANA_output_ports.add(f"    output  wire    {width_str:8} ANA_{reg['name']}")

            for port in group['ana_io']:
                field_name = port['name']
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                if port['type'] == "output":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_BWPHYID_name[0]}")
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_BWPHYID_name[1]}")
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_BWPHYID_name[2]}")
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_BWPHYID_name[3]}")
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_SDSPHYID_name[0]}")
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_SDSPHYID_name[1]}")
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_SDSPLLID_name[0]}")
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{new_SDSPLLID_name[1]}")
                    else:
                        ANA_output_ports.add(f"    output  wire    {width:8} ANA_{port['name']}")

        return ANA_output_ports

    def get_ANA_input_ports_declarations(self, yaml_data):
        ANA_input_ports = set()
        for group in yaml_data:
            for reg in group['fields']:
                field_name = reg['name']
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                if reg['type'] == "RORSYNC":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_BWPHYID_name[0]}")
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_BWPHYID_name[1]}")
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_BWPHYID_name[2]}")
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_BWPHYID_name[3]}")
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_SDSPHYID_name[0]}")
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_SDSPHYID_name[1]}")
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_SDSPLLID_name[0]}")
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{new_SDSPLLID_name[1]}")
                    else:
                        ANA_input_ports.add(f"    input   wire    {width_str:8} ANA_{reg['name']}")

            for port in group['ana_io']:
                field_name = port['name']
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                if port['type'] == "input":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_BWPHYID_name[0]}")
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_BWPHYID_name[1]}")
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_BWPHYID_name[2]}")
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_BWPHYID_name[3]}")
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_SDSPHYID_name[0]}")
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_SDSPHYID_name[1]}")
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_SDSPLLID_name[0]}")
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{new_SDSPLLID_name[1]}")
                    else:
                        ANA_input_ports.add(f"    input   wire    {width:8} ANA_{port['name']}")

        return ANA_input_ports

    def get_dig_to_ana_logic_without_dft(self, yaml_data):
        dig_to_ana_assign = set()
        for group in yaml_data:
            for reg in group['fields']:
                field_name = reg['name']
                if reg['type'] == "RWR" and reg['special_dft_control'] != "Configurable":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[0]} = {new_BWPHYID_name[0]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[1]} = {new_BWPHYID_name[1]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[2]} = {new_BWPHYID_name[2]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[3]} = {new_BWPHYID_name[3]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[4]} = {new_BWPHYID_name[4]};")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPLLID_name[0]} = {new_BWPLLID_name[0]};")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPHYID_name[0]} = {new_SDSPHYID_name[0]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPHYID_name[1]} = {new_SDSPHYID_name[1]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPHYID_name[2]} = {new_SDSPHYID_name[2]};")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPLLID_name[0]} = {new_SDSPLLID_name[0]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPLLID_name[1]} = {new_SDSPLLID_name[1]};")
                    else:
                        dig_to_ana_assign.add(f"    assign ANA_{reg['name']} = {reg['name']};")

            for port in group['ana_io']:
                field_name = port['name']
                if port['type'] == "output" and port['special_dft_control'] != "Configurable":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[0]} = {new_BWPHYID_name[0]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[1]} = {new_BWPHYID_name[1]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[2]} = {new_BWPHYID_name[2]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[3]} = {new_BWPHYID_name[3]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPHYID_name[4]} = {new_BWPHYID_name[4]};")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        dig_to_ana_assign.add(f"    assign ANA_{new_BWPLLID_name[0]} = {new_BWPLLID_name[0]};")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPHYID_name[0]} = {new_SDSPHYID_name[0]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPHYID_name[1]} = {new_SDSPHYID_name[1]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPHYID_name[2]} = {new_SDSPHYID_name[2]};")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPLLID_name[0]} = {new_SDSPLLID_name[0]};")
                        dig_to_ana_assign.add(f"    assign ANA_{new_SDSPLLID_name[1]} = {new_SDSPLLID_name[1]};")
                    else:
                        dig_to_ana_assign.add(f"    assign ANA_{port['name']} = {port['name']};")

        return dig_to_ana_assign

    def get_ana_to_dig_logic_without_dft(self, yaml_data):
        ana_to_dig_assign = set()
        for group in yaml_data:
            for reg in group['fields']:
                field_name = reg['name']
                if reg['type'] == "RORSYNC" and reg['special_dft_control'] != "Configurable":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[0]} = ANA_{new_BWPHYID_name[0]};")
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[1]} = ANA_{new_BWPHYID_name[1]};")
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[2]} = ANA_{new_BWPHYID_name[2]};")
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[3]} = ANA_{new_BWPHYID_name[3]};")
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[4]} = ANA_{new_BWPHYID_name[4]};")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ana_to_dig_assign.add(f"    assign {new_BWPLLID_name[0]} = ANA_{new_BWPLLID_name[0]};")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ana_to_dig_assign.add(f"    assign {new_SDSPHYID_name[0]} = ANA_{new_SDSPHYID_name[0]};")
                        ana_to_dig_assign.add(f"    assign {new_SDSPHYID_name[1]} = ANA_{new_SDSPHYID_name[1]};")
                        ana_to_dig_assign.add(f"    assign {new_SDSPHYID_name[2]} = ANA_{new_SDSPHYID_name[2]};")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ana_to_dig_assign.add(f"    assign {new_SDSPLLID_name[0]} = ANA_{new_SDSPLLID_name[0]};")
                        ana_to_dig_assign.add(f"    assign {new_SDSPLLID_name[1]} = ANA_{new_SDSPLLID_name[1]};")
                    else:
                        ana_to_dig_assign.add(f"    assign {reg['name']} = ANA_{reg['name']};")

            for port in group['ana_io']:
                field_name = port['name']
                if port['type'] == "input" and port['special_dft_control'] != "Configurable":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[0]} = ANA_{new_BWPHYID_name[0]};")
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[1]} = ANA_{new_BWPHYID_name[1]};")
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[2]} = ANA_{new_BWPHYID_name[2]};")
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[3]} = ANA_{new_BWPHYID_name[3]};")
                        ana_to_dig_assign.add(f"    assign {new_BWPHYID_name[4]} = ANA_{new_BWPHYID_name[4]};")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        ana_to_dig_assign.add(f"    assign {new_BWPLLID_name[0]} = ANA_{new_BWPLLID_name[0]};")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        ana_to_dig_assign.add(f"    assign {new_SDSPHYID_name[0]} = ANA_{new_SDSPHYID_name[0]};")
                        ana_to_dig_assign.add(f"    assign {new_SDSPHYID_name[1]} = ANA_{new_SDSPHYID_name[1]};")
                        ana_to_dig_assign.add(f"    assign {new_SDSPHYID_name[2]} = ANA_{new_SDSPHYID_name[2]};")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        ana_to_dig_assign.add(f"    assign {new_SDSPLLID_name[0]} = ANA_{new_SDSPLLID_name[0]};")
                        ana_to_dig_assign.add(f"    assign {new_SDSPLLID_name[1]} = ANA_{new_SDSPLLID_name[1]};")
                    else:
                        ana_to_dig_assign.add(f"    assign {port['name']} = ANA_{port['name']};")

        return ana_to_dig_assign

    def get_dft_ctrl_mux_logic(self, yaml_data):
        dft_ctrl_mux_instance = set()
        for group in yaml_data:
            for reg in group['fields']:
                field_name = reg['name']
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                width = reg['width']
                if reg['type'] == "RWR" and reg['special_dft_control'] == "Configurable":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        for i in range(5):
                            if width == 1:
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_BWPHYID_name[i]}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({new_BWPHYID_name[i]}),\n"
                                    f"    .a1_i       (DFT_{new_BWPHYID_name[i]}),\n"
                                    f"    .z_o        (ANA_{new_BWPHYID_name[i]})\n    );\n"
                                    )
                            else:
                                for j in range(width):
                                    dft_ctrl_mux_instance.add(
                                        f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_BWPHYID_name[i]}_{j}\n"
                                        f"    .sel_i      (ana_dft_ctrl),\n"
                                        f"    .a0_i       ({new_BWPHYID_name[i]}[{j}]),\n"
                                        f"    .a1_i       (DFT_{new_BWPHYID_name[i]}[{j}]),\n"
                                        f"    .z_o        (ANA_{new_BWPHYID_name[i]}[{j}])\n    );\n"
                                        )
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        if width == 1:
                            dft_ctrl_mux_instance.add(
                                f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_BWPLLID_name[0]}\n"
                                f"    .sel_i      (ana_dft_ctrl),\n"
                                f"    .a0_i       ({new_BWPLLID_name[0]}),\n"
                                f"    .a1_i       (DFT_{new_BWPLLID_name[0]}),\n"
                                f"    .z_o        (ANA_{new_BWPLLID_name[0]})\n    );\n"
                            )
                        else:
                            for j in range(width):
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_BWPLLID_name[0]}_{j}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({new_BWPLLID_name[0]}[{j}]),\n"
                                    f"    .a1_i       (DFT_{new_BWPLLID_name[0]}[{j}]),\n"
                                    f"    .z_o        (ANA_{new_BWPLLID_name[0]}[{j}])\n    );\n"
                                )
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        for i in range(3):
                            if width == 1:
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_SDSPHYID_name[i]}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({new_SDSPHYID_name[i]}),\n"
                                    f"    .a1_i       (DFT_{new_SDSPHYID_name[i]}),\n"
                                    f"    .z_o        (ANA_{new_SDSPHYID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_ctrl_mux_instance.add(
                                        f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_SDSPHYID_name[i]}_{j}\n"
                                        f"    .sel_i      (ana_dft_ctrl),\n"
                                        f"    .a0_i       ({new_SDSPHYID_name[i]}[{j}]),\n"
                                        f"    .a1_i       (DFT_{new_SDSPHYID_name[i]}[{j}]),\n"
                                        f"    .z_o        (ANA_{new_SDSPHYID_name[i]}[{j}])\n    );\n"
                                    )
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        for i in range(2):
                            if width == 1:
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_SDSPLLID_name[i]}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({new_SDSPLLID_name[i]}),\n"
                                    f"    .a1_i       (DFT_{new_SDSPLLID_name[i]}),\n"
                                    f"    .z_o        (ANA_{new_SDSPLLID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_ctrl_mux_instance.add(
                                        f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_SDSPLLID_name[i]}_{j}\n"
                                        f"    .sel_i      (ana_dft_ctrl),\n"
                                        f"    .a0_i       ({new_SDSPLLID_name[i]}[{j}]),\n"
                                        f"    .a1_i       (DFT_{new_SDSPLLID_name[i]}[{j}]),\n"
                                        f"    .z_o        (ANA_{new_SDSPLLID_name[i]}[{j}])\n    );\n"
                                    )
                    else:
                        if width == 1:
                            dft_ctrl_mux_instance.add(
                                f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{field_name}\n"
                                f"    .sel_i      (ana_dft_ctrl),\n"
                                f"    .a0_i       ({field_name}),\n"
                                f"    .a1_i       (DFT_{field_name}),\n"
                                f"    .z_o        (ANA_{field_name})\n    );\n"
                            )
                        else:
                            for j in range(width):
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{field_name}_{j}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({field_name}[{j}]),\n"
                                    f"    .a1_i       (DFT_{field_name}[{j}]),\n"
                                    f"    .z_o        (ANA_{field_name}[{j}])\n    );\n"
                                )

            for port in group['ana_io']:
                field_name = port['name']
                width = int(port['width'])
                width_str = f"[{width - 1}:0]" if width > 1 else ""
                if port['type'] == "output" and port['special_dft_control'] == "Configurable":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        for i in range(5):
                            if width == 1:
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_BWPHYID_name[i]}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({new_BWPHYID_name[i]}),\n"
                                    f"    .a1_i       (DFT_{new_BWPHYID_name[i]}),\n"
                                    f"    .z_o        (ANA_{new_BWPHYID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_ctrl_mux_instance.add(
                                        f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_BWPHYID_name[i]}_{j}\n"
                                        f"    .sel_i      (ana_dft_ctrl),\n"
                                        f"    .a0_i       ({new_BWPHYID_name[i]}[{j}]),\n"
                                        f"    .a1_i       (DFT_{new_BWPHYID_name[i]}[{j}]),\n"
                                        f"    .z_o        (ANA_{new_BWPHYID_name[i]}[{j}])\n    );\n"
                                    )
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        if width == 1:
                            dft_ctrl_mux_instance.add(
                                f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_BWPLLID_name[0]}\n"
                                f"    .sel_i      (ana_dft_ctrl),\n"
                                f"    .a0_i       ({new_BWPLLID_name[0]}),\n"
                                f"    .a1_i       (DFT_{new_BWPLLID_name[0]}),\n"
                                f"    .z_o        (ANA_{new_BWPLLID_name[0]})\n    );\n"
                            )
                        else:
                            for j in range(width):
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_BWPLLID_name[0]}_{j}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({new_BWPLLID_name[0]}[{j}]),\n"
                                    f"    .a1_i       (DFT_{new_BWPLLID_name[0]}[{j}]),\n"
                                    f"    .z_o        (ANA_{new_BWPLLID_name[0]}[{j}])\n    );\n"
                                )
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        for i in range(3):
                            if width == 1:
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_SDSPHYID_name[i]}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({new_SDSPHYID_name[i]}),\n"
                                    f"    .a1_i       (DFT_{new_SDSPHYID_name[i]}),\n"
                                    f"    .z_o        (ANA_{new_SDSPHYID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_ctrl_mux_instance.add(
                                        f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_SDSPHYID_name[i]}_{j}\n"
                                        f"    .sel_i      (ana_dft_ctrl),\n"
                                        f"    .a0_i       ({new_SDSPHYID_name[i]}[{j}]),\n"
                                        f"    .a1_i       (DFT_{new_SDSPHYID_name[i]}[{j}]),\n"
                                        f"    .z_o        (ANA_{new_SDSPHYID_name[i]}[{j}])\n    );\n"
                                    )
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        for i in range(2):
                            if width == 1:
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_SDSPLLID_name[i]}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({new_SDSPLLID_name[i]}),\n"
                                    f"    .a1_i       (DFT_{new_SDSPLLID_name[i]}),\n"
                                    f"    .z_o        (ANA_{new_SDSPLLID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_ctrl_mux_instance.add(
                                        f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{new_SDSPLLID_name[i]}_{j}\n"
                                        f"    .sel_i      (ana_dft_ctrl),\n"
                                        f"    .a0_i       ({new_SDSPLLID_name[i]}[{j}]),\n"
                                        f"    .a1_i       (DFT_{new_SDSPLLID_name[i]}[{j}]),\n"
                                        f"    .z_o        (ANA_{new_SDSPLLID_name[i]}[{j}])\n    );\n"
                                    )
                    else:
                        if width == 1:
                            dft_ctrl_mux_instance.add(
                                f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{field_name}\n"
                                f"    .sel_i      (ana_dft_ctrl),\n"
                                f"    .a0_i       ({field_name}),\n"
                                f"    .a1_i       (DFT_{field_name}),\n"
                                f"    .z_o        (ANA_{field_name})\n    );\n"
                            )
                        else:
                            for j in range(width):
                                dft_ctrl_mux_instance.add(
                                    f"    jlsemi_util_mux_cell\n    u_dft_dont_touch_ana_mux_{field_name}_{j}\n"
                                    f"    .sel_i      (ana_dft_ctrl),\n"
                                    f"    .a0_i       ({field_name}[{j}]),\n"
                                    f"    .a1_i       (DFT_{field_name}[{j}]),\n"
                                    f"    .z_o        (ANA_{field_name}[{j}])\n    );\n"
                                )

        return dft_ctrl_mux_instance

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
        dft_ctrl_mux_logic = self.get_dft_ctrl_mux_logic(yaml_data)

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

        verilog_content += "    // dft_ctrl_mux_logic\n"
        verilog_content += "\n".join(sorted(dft_ctrl_mux_logic)) + "\n"

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
