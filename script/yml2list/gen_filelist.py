import os
import sys
import yaml


class FileListGenerator:
    def __init__(self, yml_path, output_dir):
        self.yml_path = yml_path
        self.output_dir = output_dir

    def generate_filelist(self):
        # 读取YAML文件
        with open(self.yml_path, 'r') as file:
            data = yaml.safe_load(file)

        # 获取YAML文件的目录
        yml_dir = os.path.dirname(os.path.abspath(self.yml_path))

        # 生成绝对路径列表并写入对应的文件
        for section in data:
            for key, items in section.items():
                define_list = []
                incdir_list = []
                filelist = []
                for item in items:
                    if 'define' in item:
                        define_list.extend(item['define'])
                    elif 'incdir' in item:
                        for path in item['incdir']:
                            absolute_path = os.path.abspath(os.path.join(yml_dir, path))
                            incdir_list.append(f"+incdir+{absolute_path}")
                    elif 'filelist' in item:
                        for path in item['filelist']:
                            absolute_path = os.path.abspath(os.path.join(yml_dir, path))
                            filelist.append(absolute_path)

                output_file_path = os.path.join(self.output_dir, f"{key}.f")
                with open(output_file_path, 'w') as output_file:
                    for define in define_list:
                        output_file.write(define + '\n')
                    for incdir in incdir_list:
                        output_file.write(incdir + '\n')
                    for filepath in filelist:
                        output_file.write(filepath + '\n')


def main():
    if len(sys.argv) != 3:
        print("Usage: python3 generate_filelist.py <yml_path> <output_directory>")
        sys.exit(1)

    yml_path = sys.argv[1]
    output_dir = sys.argv[2]

    generator = FileListGenerator(yml_path, output_dir)
    generator.generate_filelist()


if __name__ == "__main__":
    main()
    print("Conversion completed successfully!")