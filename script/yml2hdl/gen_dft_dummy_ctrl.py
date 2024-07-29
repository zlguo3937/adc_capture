import sys
import re
import yaml


class RegfileParser:
    def read_yaml(self, yml_path):
        with open(yml_path, 'r') as yaml_file:
            return yaml.safe_load(yaml_file)

    def get_dft_self_define_ports(self, yaml_data):
        dft_self_define_ports = set()
        dft_self_define_ports.add(
            f"    output  wire             cpu_testmode,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             scan_enable,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             scan_mode,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_rtl_icg_en,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_icg_scan_rstn,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_icg_rstn_ctrl,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_icg_scan_rstn_ctrl,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_test_clk_en,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_stuck_at_mode,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_tpi_clk,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_clkdiv_rstn_ctrl,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_clkdiv_scan_rstn,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_rstnsync_scan_rstn,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_rstnsync_scan_rstn_ctrl,\n"
            )
        dft_self_define_ports.add(
            f"    output  wire             dft_scan_en,\n"
            )
        
        return dft_self_define_ports

    def get_self_define_logic(self, yaml_data):
        self_define_instance = set()
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_cpu_testmode\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (cpu_testmode)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_scan_enable\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (scan_enable)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_scan_mode\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (scan_mode)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_rtl_icg_en\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_rtl_icg_en)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_icg_scan_rstn\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_icg_scan_rstn)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_icg_rstn_ctrl\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_icg_rstn_ctrl)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_icg_scan_rstn_ctrl\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_icg_scan_rstn_ctrl)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_test_clk_en\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_test_clk_en)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_stuck_at_mode\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_stuck_at_mode)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_tpi_clk\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_tpi_clk)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_clkdiv_rstn_ctrl\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_clkdiv_rstn_ctrl)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_clkdiv_scan_rstn\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_clkdiv_scan_rstn)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_rstnsync_scan_rstn\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_rstnsync_scan_rstn)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_rstnsync_scan_rstn_ctrl\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_rstnsync_scan_rstn_ctrl)\n    );\n"
            )
        self_define_instance.add(
            f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_dft_scan_en\n"
            f"    .clk_in     (1'b0),\n"
            f"    .clk_out    (dft_scan_en)\n    );\n"
            )
        
        return self_define_instance

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
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_BWPHYID_name[0]}")
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_BWPHYID_name[1]}")
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_BWPHYID_name[2]}")
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_BWPHYID_name[3]}")
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_SDSPHYID_name[0]}")
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_SDSPHYID_name[1]}")
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_SDSPLLID_name[0]}")
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{new_SDSPLLID_name[1]}")
                    else:
                        dft_ana_ports.add(f"    output  wire    {width_str:8} DFT_{reg['name']}")
            for port in group['ana_io']:
                field_name = port['name']
                width_str = int(port['width'])
                width = f"[{width_str - 1}:0]" if width_str > 1 else ""
                if port['type'] == "output" and port['special_dft_control'] == "Configurable":
                    if field_name.startswith("BWPHYID"):
                        base_BWPHYID = field_name[:7]
                        new_BWPHYID_name = [f"{base_BWPHYID[:5]}{i}{field_name[7:]}" for i in range(5)]
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_BWPHYID_name[0]}")
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_BWPHYID_name[1]}")
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_BWPHYID_name[2]}")
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_BWPHYID_name[3]}")
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_BWPHYID_name[4]}")
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_BWPLLID_name[0]}")
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_SDSPHYID_name[0]}")
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_SDSPHYID_name[1]}")
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_SDSPHYID_name[2]}")
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_SDSPLLID_name[0]}")
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{new_SDSPLLID_name[1]}")
                    else:
                        dft_ana_ports.add(f"    output  wire    {width:8} DFT_{port['name']}")
        return dft_ana_ports

    def get_dft_dummy_ctrl_ana_buf_logic(self, yaml_data):
        dft_dummy_ctrl_ana_buf_instance = set()
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
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_BWPHYID_name[i]}\n"
                                    f"    .clk_in    (1'b0),\n"
                                    f"    .clk_out    (DFT_{new_BWPHYID_name[i]})\n    );\n"
                                    )
                            else:
                                for j in range(width):
                                    dft_dummy_ctrl_ana_buf_instance.add(
                                        f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_BWPHYID_name[i]}_{j}\n"
                                        f"    .clk_in     (1'b0),\n"
                                        f"    .clk_out    (DFT_{new_BWPHYID_name[i]}[{j}])\n    );\n"
                                        )
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        if width == 1:
                            dft_dummy_ctrl_ana_buf_instance.add(
                                f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_BWPLLID_name[0]}\n"
                                f"    .clk_in     (1'b0),\n"
                                f"    .clk_out    (DFT_{new_BWPLLID_name[0]})\n    );\n"
                            )
                        else:
                            for j in range(width):
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_BWPLLID_name[0]}_{j}\n"
                                    f"    .clk_in     (1'b0),\n"
                                    f"    .clk_out    (DFT_{new_BWPLLID_name[0]}[{j}])\n    );\n"
                                )
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        for i in range(3):
                            if width == 1:
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_SDSPHYID_name[i]}\n"
                                    f"    .clk_in     (1'b0),\n"
                                    f"    .clk_out    (DFT_{new_SDSPHYID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_dummy_ctrl_ana_buf_instance.add(
                                        f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_SDSPHYID_name[i]}_{j}\n"
                                        f"    .clk_in     (1'b0),\n"
                                        f"    .clk_out    (DFT_{new_SDSPHYID_name[i]}[{j}])\n    );\n"
                                    )
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        for i in range(2):
                            if width == 1:
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_SDSPLLID_name[i]}\n"
                                    f"    .clk_in     (1'b0),\n"
                                    f"    .clk_out    (DFT_{new_SDSPLLID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_dummy_ctrl_ana_buf_instance.add(
                                        f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_SDSPLLID_name[i]}_{j}\n"
                                        f"    .clk_in     (1'b0),\n"
                                        f"    .clk_out    (DFT_{new_SDSPLLID_name[i]}[{j}])\n    );\n"
                                    )
                    else:
                        if width == 1:
                            dft_dummy_ctrl_ana_buf_instance.add(
                                f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{field_name}\n"
                                f"    .clk_in     (1'b0),\n"
                                f"    .clk_out    (DFT_{field_name})\n    );\n"
                            )
                        else:
                            for j in range(width):
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{field_name}_{j}\n"
                                    f"    .clk_in     (1'b0),\n"
                                    f"    .clk_out    (DFT_{field_name}[{j}])\n    );\n"
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
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_BWPHYID_name[i]}\n"
                                    f"    .clk_in     (1'b0),\n"
                                    f"    .clk_out    (DFT_{new_BWPHYID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_dummy_ctrl_ana_buf_instance.add(
                                        f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_BWPHYID_name[i]}_{j}\n"
                                        f"    .clk_in     (1'b0),\n"
                                        f"    .clk_out    (DFT_{new_BWPHYID_name[i]}[{j}])\n    );\n"
                                    )
                    elif field_name.startswith("BWPLLID"):
                        base_BWPLLID = field_name[:7]
                        new_BWPLLID_name = [f"{base_BWPLLID[:5]}0{field_name[7:]}"]
                        if width == 1:
                            dft_dummy_ctrl_ana_buf_instance.add(
                                f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_BWPLLID_name[0]}\n"
                                f"    .clk_in     (1'b0),\n"
                                f"    .clk_out    (DFT_{new_BWPLLID_name[0]})\n    );\n"
                            )
                        else:
                            for j in range(width):
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_BWPLLID_name[0]}_{j}\n"
                                    f"    .clk_in     (1'b0),\n"
                                    f"    .clk_out    (DFT_{new_BWPLLID_name[0]}[{j}])\n    );\n"
                                )
                    elif field_name.startswith("SDSPHYID"):
                        base_SDSPHYID = field_name[:8]
                        new_SDSPHYID_name = [f"{base_SDSPHYID[:6]}{i}{field_name[8:]}" for i in range(3)]
                        for i in range(3):
                            if width == 1:
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_SDSPHYID_name[i]}\n"
                                    f"    .clk_in     (1'b0),\n"
                                    f"    .clk_out    (DFT_{new_SDSPHYID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_dummy_ctrl_ana_buf_instance.add(
                                        f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_SDSPHYID_name[i]}_{j}\n"
                                        f"    .clk_in     (1'b0),\n"
                                        f"    .clk_out    (DFT_{new_SDSPHYID_name[i]}[{j}])\n    );\n"
                                    )
                    elif field_name.startswith("SDSPLLID"):
                        base_SDSPLLID = field_name[:8]
                        new_SDSPLLID_name = [f"{base_SDSPLLID[:6]}{i}{field_name[8:]}" for i in range(2)]
                        for i in range(2):
                            if width == 1:
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_SDSPLLID_name[i]}\n"
                                    f"    .clk_in     (1'b0),\n"
                                    f"    .clk_out    (DFT_{new_SDSPLLID_name[i]})\n    );\n"
                                )
                            else:
                                for j in range(width):
                                    dft_dummy_ctrl_ana_buf_instance.add(
                                        f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{new_SDSPLLID_name[i]}_{j}\n"
                                        f"    .clk_in     (1'b0),\n"
                                        f"    .clk_out    (DFT_{new_SDSPLLID_name[i]}[{j}])\n    );\n"
                                    )
                    else:
                        if width == 1:
                            dft_dummy_ctrl_ana_buf_instance.add(
                                f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{field_name}\n"
                                f"    .clk_in     (1'b0),\n"
                                f"    .clk_out    (DFT_{field_name})\n    );\n"
                            )
                        else:
                            for j in range(width):
                                dft_dummy_ctrl_ana_buf_instance.add(
                                    f"    jlsemi_util_dft_buf_wrap\n    u_dft_dont_touch_buf_{field_name}_{j}\n"
                                    f"    .clk_in     (1'b0),\n"
                                    f"    .clk_out    (DFT_{field_name}[{j}])\n    );\n"
                                )

        return dft_dummy_ctrl_ana_buf_instance

    def generate_verilog_code(self, yaml_data, module_name):
        yaml_data = self.read_yaml(yaml_data)
        # Initial module definition with fixed inputs and outputs
        verilog_content = (f'''\
module {module_name}
(
''').format(module_name=module_name)

        dft_ana_ports = self.get_dft_ana_ports_declarations(yaml_data)
        dft_self_define_ports = self.get_dft_self_define_ports(yaml_data)
        self_define_logic = self.get_self_define_logic(yaml_data)
        dft_dummy_ctrl_ana_buf_logic = self.get_dft_dummy_ctrl_ana_buf_logic(yaml_data)

        verilog_content += "    // ana_dft_ctrl"
        verilog_content += "\n    output  wire             ana_dft_ctrl," + "\n\n"

        # user self_define_logic
        verilog_content += "    // dft crg signal\n"
        verilog_content += "".join(sorted(dft_self_define_ports)) + "\n\n"

        verilog_content += "    // dft ana signal\n"
        verilog_content += ",\n".join(sorted(dft_ana_ports)) + "\n);\n\n"

        # user self_define_logic
        verilog_content += "\n".join(sorted(self_define_logic)) + "\n\n"

        verilog_content += "    // dft_ctrl_mux_logic\n"
        verilog_content += "\n".join(sorted(dft_dummy_ctrl_ana_buf_logic)) + "\n"

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
