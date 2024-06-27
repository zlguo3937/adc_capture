import csv
import sys
import yaml


class RegisterParser:
    def __init__(self):
        self.regs_type_list = ['ID', 'OD', 'IDH', 'ODH', 'OCK', 'PIOA', 'PIA', 'POA', 'IA', 'OA']

    def parse_bit_range(self, bit_range):
        reg_range = bit_range.strip()
        int_range = reg_range.strip("[]")
        if ':' in reg_range:
            msb, lsb = map(int, int_range.split(":"))
        else:
            msb = lsb = int(int_range)
        return msb, lsb

    def parse_reg_init(self, reset, msb, lsb):
        init = int(reset.strip(), 16)
        if init == '':
            print("WARNING: Empty Default Value!")
            sys.exit(-1)
        elif init >= (2 ** (msb - lsb + 1)):
            print("ERROR: %d bits Width: %d too small can't contain: %d" % (
                msb - lsb + 1, (2 ** (msb - lsb + 1)), init))
            sys.exit(-1)
        return init

    def parse_reg_type(self, regs_type):
        if regs_type != '' and regs_type not in self.regs_type_list:
            print("ERROR: Your Register type must be in regs_type_list!")
            print(regs_type)
            sys.exit(-1)

        if regs_type == 'ID':
            return 'RWR'
        elif regs_type == 'OD':
            return 'RORSYNC'
        elif regs_type == 'IDH' or 'IA':
            return 'output'
        elif regs_type == 'ODH' or 'OCK' or 'OA':
            return 'input'
        elif regs_type == 'PIOA' or 'PIA' or 'POA':
            return 'PIN'

    def parse_reg_name(self, reg_name, all_regs):
        if reg_name in all_regs:
            print("ERROR: Your Register name must be exclusive in all regs!")
            print(reg_name)
            sys.exit(-1)
        return reg_name

    def read_csv_to_yaml(self, csv_file):
        address = 0
        reg_group_name: str = ""
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
                    reg_group_name = row[0][2:]
                    if reg_group_name != '' and reg_group_name in reg_group_names:
                        print("ERROR: Your Register reg_group_name must be exclusive in all regs!")
                        print(reg_group_name)
                        sys.exit(-1)
                    else:
                        reg_group_names.add(reg_group_name)
                    desc = row[0][2:]
                    address = address + 1
                    if address in addresses:
                        print("ERROR: Your Register address must be exclusive in all regs!")
                        print(address)
                        sys.exit(-1)
                    else:
                        addresses.add(address)
                    reg_info = {
                        'address': hex(address),
                        'reg_group_name': reg_group_name,
                        'desc': desc,
                        'register': [],
                        'ana_io': []
                    }
                    regs_info.append(reg_info)
                elif row[0].startswith("["):
                    msb, lsb = self.parse_bit_range(row[0])
                    width = msb - lsb + 1
                    field_info = {
                        'name': self.parse_reg_name(row[1].strip(), all_regs),
                        'type': self.parse_reg_type(row[3].strip()),
                        'range': width,
                        'msb': msb,
                        'lsb': lsb,
                        'width': width,
                        'reset': hex(self.parse_reg_init(row[5], msb, lsb)),
                        'dc_scan_mode': row[6],
                        'disable_scan': row[7],
                        'occ_scan_mode': row[8],
                        'special_dft_control': row[9],
                    }
                    reg_info['register'].append(field_info)
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


if __name__ == "__main__":
    main()
