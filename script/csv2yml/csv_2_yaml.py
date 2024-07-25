import csv
import sys
import yaml


class RegisterParser:
    def __init__(self):
        self.regs_type_list = ['ROR', 'ROD', 'RODEV', 'RWR', 'RWD',
                               'RWDEV', 'RORSYNC', 'RODSYNC', 'RODEVSYNC', 'RWRSYNC',
                               'RWDSYNC', 'RWDEVSYNC', 'CONST', 'SC', 'RC',
                               'ROLH', 'ROLL', 'CMRW', 'CMRO', 'CMRC',
                               'MCRO', 'MCRC', 'LHRC', 'CPUROLH', 'CPUROLL',
                               'INC_CNT', 'RCSYNC', 'RAW']
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
        if regs_type not in self.regs_type_list:
            print("ERROR: Your Register type must be in regs_type_list!")
            print(regs_type)
            sys.exit(-1)
        return regs_type

    def parse_apb_tpe(self, regs_type):
        apb_type = self.parse_reg_type(regs_type)
        if apb_type in ['ROR', 'ROD', 'RODEV', 'RORSYNC', 'RODSYNC', 'RODEVSYNC', 'CMRO']:
            apb_type = 'ro'
        elif apb_type in ['RWR', 'RWD', 'RWDEV', 'RWRSYNC', 'RWDSYNC', 'RWDEVSYNC', 'CMRW', 'MCRO', 'MCRC', 'INC_CNT', 'RAW']:
            apb_type = 'rw'
        elif apb_type in ['CMRC']:
            apb_type = 'rc'
        elif apb_type in ['SC', 'CMRC']:
            apb_type = 'sc'
        elif apb_type in ['RC', 'RCSYNC']:
            apb_type = 'rc'
        elif apb_type in ['ROLH', 'CPUROLH']:
            apb_type = 'lh'
        elif apb_type in ['ROLL', 'CPUROLL']:
            apb_type = 'll'
        if apb_type not in self.apb_type_list:
            print("ERROR: Your Register type must be in apb_type_list!")
            print(apb_type)
            sys.exit(-1)
        return apb_type

    def parse_cpu_tpe(self, regs_type):
        cpu_type = self.parse_reg_type(regs_type)
        if cpu_type in ['ROR', 'ROD', 'RODEV', 'RORSYNC', 'RODSYNC', 'RODEVSYNC', 'MCRO']:
            cpu_type = 'ro'
        elif cpu_type in ['RWR', 'RWD', 'RWDEV', 'RWRSYNC', 'RWDSYNC', 'RWDEVSYNC', 'CMRW', 'CMRO', 'LHRC', 'INC_CNT', 'RAW']:
            cpu_type = 'rw'
        elif cpu_type in ['MCRC']:
            cpu_type = 'rc'
        elif cpu_type in ['SC', 'CMRC']:
            cpu_type = 'sc'
        elif cpu_type in ['RC', 'RCSYNC']:
            cpu_type = 'rc'
        elif cpu_type in ['ROLH', 'CPUROLH']:
            cpu_type = 'lh'
        elif cpu_type in ['ROLL', 'CPUROLL']:
            cpu_type = 'll'
        if cpu_type not in self.cpu_type_list:
            print("ERROR: Your Register type must be in cpu_type_list!")
            print(cpu_type)
            sys.exit(-1)
        return cpu_type

    def parse_mdio_tpe(self, regs_type):
        mdio_type = self.parse_reg_type(regs_type)
        if mdio_type in ['ROR', 'ROD', 'RODEV', 'RORSYNC', 'RODSYNC', 'RODEVSYNC', 'MCRO']:
            mdio_type = 'ro'
        elif mdio_type in ['RWR', 'RWD', 'RWDEV', 'RWRSYNC', 'RWDSYNC', 'RWDEVSYNC', 'CMRW', 'CMRO', 'LHRC', 'INC_CNT', 'RAW']:
            mdio_type = 'rw'
        elif mdio_type in ['MCRC']:
            mdio_type = 'rc'
        elif mdio_type in ['SC', 'CMRC']:
            mdio_type = 'sc'
        elif mdio_type in ['RC', 'RCSYNC']:
            mdio_type = 'rc'
        elif mdio_type in ['ROLH', 'CPUROLH']:
            mdio_type = 'lh'
        elif mdio_type in ['ROLL', 'CPUROLL']:
            mdio_type = 'll'
        if mdio_type not in self.mdio_type_list:
            print("ERROR: Your Register type must be in mdio_type_list!")
            print(mdio_type)
            sys.exit(-1)
        return mdio_type

    def parse_dev_tpe(self, regs_type):
        dev_type = self.parse_reg_type(regs_type)
        if dev_type in ['ROR', 'ROD', 'RORSYNC', 'RODSYNC', 'ROLH', 'ROLL']:
            dev_type = 'wo'
        elif dev_type in ['RODEV', 'RWDEV', 'RODEVSYNC', 'RWDEVSYNC', 'RC', 'RCSYNC']:
            dev_type = 'we'
        elif dev_type in ['RWR', 'RWD', 'RWRSYNC', 'RWDSYNC', 'SC']:
            dev_type = 'ro'
        else:
            dev_type = 'none'
        if dev_type not in self.dev_type_list:
            print("ERROR: Your Register type must be in dev_type_list!")
            print(dev_type)
            sys.exit(-1)
        return dev_type

    def parse_reg_name(self, reg_name, all_regs):
        if reg_name in all_regs:
            print("ERROR: Your Register name must be exclusive in all regs!")
            print(reg_name)
            sys.exit(-1)
        return reg_name

    def read_csv_to_yaml(self, csv_file):
        address: str = ""
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

                if row[0].startswith("#"):
                    reg_name = row[1]
                    if reg_name in reg_group_names:
                        print("ERROR: Your Register reg_name must be exclusive in all regs!")
                        print(reg_name)
                        sys.exit(-1)
                    else:
                        reg_group_names.add(reg_name)
                    desc = row[2]
                elif row[0].startswith("") and "addr=" in row[1]:
                    address = hex(int(row[1].strip()[7:], 16))
                    if address in addresses:
                        print("ERROR: Your Register address must be exclusive in all regs!")
                        print(address)
                        sys.exit(-1)
                    else:
                        addresses.add(address)
                    reg_info = {
                        'address': address,
                        'reg_name': reg_name,
                        'desc': desc,
                        'fields': []
                    }
                    regs_info.append(reg_info)
                elif row[1].startswith("["):
                    msb, lsb = self.parse_bit_range(row[1])
                    width = msb - lsb + 1
                    type_reg = {}
                    type_reg['apb'] = self.parse_apb_tpe(row[3].strip())
                    type_reg['cpu'] = self.parse_cpu_tpe(row[3].strip())
                    type_reg['mdio'] = self.parse_mdio_tpe(row[3].strip())
                    type_reg['dev'] = self.parse_dev_tpe(row[3].strip())
                    field_info = {
                        'range': row[1],
                        'type': self.parse_reg_type(row[3].strip()),
                        'msb': msb,
                        'lsb': lsb,
                        'width': width,
                        'init': hex(self.parse_reg_init(row[2], msb, lsb)),
                        'field_type': type_reg,
                        'name': self.parse_reg_name(row[4].strip(), all_regs),
                    }
                    reg_info['fields'].append(field_info)
                    all_regs.append(row[4].strip())

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
