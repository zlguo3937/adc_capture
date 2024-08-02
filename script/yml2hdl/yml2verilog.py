import sys

import yaml


class RegfileParser:
    def read_yaml(self, yml_path):
        with open(yml_path, 'r') as yaml_file:
            return yaml.safe_load(yaml_file)

    def get_port_declarations(self, yaml_data):
        port_declarations = set()
        for group in yaml_data:
            for reg in group['fields']:
                reg_type = reg['type']
                width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""

                if reg_type in ["ROD", "RWD", "RODSYNC", "RWDSYNC", "CPUROLH", "CPUROLL"]:
                    port_declarations.add(f"    input   wire             {reg['name']}_sw_rstn")

                if reg_type in ["CMRO", "CMRC", "LHRC", "MCRO", "MCRC"]:
                    port_declarations.add(f"    input   wire             is_mdio")

                if reg_type in ["RWRSYNC", "RWDSYNC", "RODEVSYNC", "RWDEVSYNC"]:
                    port_declarations.add(f"    input   wire             {reg['name']}_dev_clk")
                    port_declarations.add(f"    input   wire             {reg['name']}_dev_rstn")

                if reg_type in ["INC_CNT"]:
                    port_declarations.add(f"    input   wire             {reg['name']}_bus_clr")

                if reg_type in ["RWR", "RWD", "RWDEV", "SC", "RWRSYNC", "RWDSYNC"]:
                    port_declarations.add(f"    output  wire    {width_str:8} {reg['name']}_rdata")

                if reg_type in ["ROR", "ROD", "RODEV", "RWDEV", "RORSYNC", "RODSYNC", "RODEVSYNC", "RWDEVSYNC", "RC",
                                "RCSYNC", "ROLH", "ROLL"]:
                    port_declarations.add(f"    input   wire    {width_str:8} {reg['name']}_wdata")

                if reg_type in ["RODEV", "RWDEV", "RC", "RCSYNC", "RODEVSYNC", "RWDEVSYNC"]:
                    port_declarations.add(f"    input   wire             {reg['name']}_we")

                if reg_type in ["RAW"]:
                    port_declarations.add(f"    output  wire             {reg['name']}_raw_we")
                    port_declarations.add(f"    output  wire    {width_str:8} {reg['name']}_raw_wdata")
                    port_declarations.add(f"    input   wire    {width_str:8} {reg['name']}_raw_rdata")

        return port_declarations

    def get_bus_we_wires(self, yaml_data):
        bus_we_wires = []
        for group in yaml_data:
            for reg in group['fields']:
                if reg['type'] in ["RWR", "RWD", "RWDEV", "SC", "CPUROLH", "CPUROLL", "CMRW", "CMRO", "CMRC", "LHRC",
                                   "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "MCRO", "MCRC", "RAW", "INC_CNT"]:
                    bus_we_wires.append(f"    {'wire' :<16}{reg['name']}_bus_we;")
        return bus_we_wires

    def get_bus_wdata_wires(self, yaml_data):
        bus_wdata_wires = []
        for group in yaml_data:
            for reg in group['fields']:
                if reg['type'] in ["RWR", "RWD", "RWDEV", "SC", "CPUROLH", "CPUROLL", "CMRW", "CMRO", "CMRC", "LHRC",
                                   "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "MCRO", "MCRC", "RAW", "INC_CNT"]:
                    width_str = f"[{reg['width'] - 1}:0]" if reg['width'] > 1 else ""
                    bus_wdata_wires.append(f"    {'wire' :<8}{width_str:8}{reg['name']}_bus_wdata;")
        return bus_wdata_wires

    def get_bus_re_wires(self, yaml_data):
        bus_re_wires = []
        for group in yaml_data:
            for reg in group['fields']:
                if reg['type'] in ["RC", "RCSYNC", "ROLH", "ROLL", "CPUROLH", "CPUROLL", "CMRC", "MCRC", "LHRC",
                                   "INC_CNT"]:
                    bus_re_wires.append(f"    {'wire' :<16}{reg['name']}_bus_re;")
        return bus_re_wires

    def get_bus_rdata_wires(self, yaml_data):
        bus_rdata_wires = []
        for group in yaml_data:
            for reg in group['fields']:
                if reg['type'] in ["ROR", "ROD", "RODEV", "RWR", "RWD", "RWDEV", "RORSYNC", "RODSYNC", "RC", "RCSYNC",
                                   "ROLH", "ROLL", "CPUROLH", "CPUROLL", "CMRW", "CMRO", "CMRC", "LHRC", "RWRSYNC",
                                   "RWDSYNC", "RWDEVSYNC", "RODEVSYNC", "MCRO", "MCRC", "RAW", "INC_CNT"]:
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

    def get_addr_selects_assigns(self, yaml_data):
        addr_selects_assigns = []
        for group in yaml_data:
            address = group['address'][2:]
            addr_address_sel = "addr_" + group['address'] + "_sel"
            addr_selects_assigns.append(
                f"    assign  {addr_address_sel:15} = (req_addr == 21'h{address}) & req_sel;")
        return addr_selects_assigns

    def get_bus_we_assigns(self, yaml_data):
        bus_we_assigns = []
        for group in yaml_data:
            address = group['address']
            for reg in group['fields']:
                if reg['type'] in ["RWR", "RWD", "RWDEV", "SC", "CPUROLH", "CPUROLL", "CMRW", "CMRO", "CMRC", "LHRC",
                                   "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "MCRO", "MCRC", "RAW", "INC_CNT"]:
                    reg_name_bus_we = reg['name'] + "_bus_we"
                    bus_we_assigns.append(f"    assign  {reg_name_bus_we:30} = addr_{address}_sel & req_write;")
        return bus_we_assigns

    def get_bus_wdata_assigns(self, yaml_data):
        bus_wdata_assigns = []
        for group in yaml_data:
            for reg in group['fields']:
                if reg['type'] in ["RWR", "RWD", "RWDEV", "SC", "CPUROLH", "CPUROLL", "CMRW", "CMRO", "CMRC", "LHRC",
                                   "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "MCRO", "MCRC", "RAW", "INC_CNT"]:
                    reg_name_bus_wdata = reg['name'] + "_bus_wdata"
                    if reg['msb'] == reg['lsb']:
                        bus_wdata_assigns.append(
                            f"    assign  {reg_name_bus_wdata:30} = req_wdata[{reg['msb']}];")
                    else:
                        bus_wdata_assigns.append(
                            f"    assign  {reg_name_bus_wdata:30} = req_wdata[{reg['msb']}:{reg['lsb']}];")
        return bus_wdata_assigns

    def get_bus_re_assigns(self, yaml_data):
        bus_re_assigns = []
        for group in yaml_data:
            address = group['address']
            for reg in group['fields']:
                if reg['type'] in ["RC", "RCSYNC", "ROLH", "ROLL", "CPUROLH", "CPUROLL", "CMRC", "MCRC", "LHRC",
                                   "INC_CNT"]:
                    reg_name_bus_re = reg['name'] + "_bus_re"
                    bus_re_assigns.append(f"    assign  {reg_name_bus_re:30} = addr_{address}_sel & ~req_write;")
        return bus_re_assigns

    def get_min_address(self, yaml_data):
        min_address = None
        for group in yaml_data:
            address = hex(int(group['address'], 16))
            if min_address is None or address < min_address:
                min_address = address
        return min_address
    def get_bus_rdata_logic(self, yaml_data):
        # bus_rdata_assigns = [f"    assign  {'req_rdata':20} = sel_0x0_bus_rdata;"]
        min_address = self.get_min_address(yaml_data)
        # bus_rdata_assigns = [f"    always @(posedge clk or negedge rstn) begin\n        if (!rstn)\n            "
        #                      f"req_rdata <= 16'h0;\n        else\n            req_rdata <= sel_{min_address}_bus_rdata;\n    end"]
        bus_rdata_assigns = [f"    assign  req_rdata = sel_{min_address}_bus_rdata;"]
        return bus_rdata_assigns

    def get_bus_ready_logic(self):
        # bus_ready_assigns = [f"    assign  {'req_ready':20} = req_psel;"]
        # bus_ready_logic = [f"    always @(posedge clk or negedge rstn) begin\n        if (!rstn)\n"
        #                    f"            req_ready <= 1'b0;\n        else\n            req_ready <= req_sel;\n    end\n"]
        bus_ready_logic = [f"    assign  req_ready = req_sel;\n"]
        return bus_ready_logic

    def get_addr_selects_bus_rdata_assigns(self, yaml_data):
        addr_selects_bus_rdata_assigns = []
        for group in yaml_data:
            bit_2_field = {}
            for reg in group['fields']:
                if reg['type'] in ["ROR", "ROD", "RODEV", "RWR", "RWD", "RWDEV", "RORSYNC", "RODSYNC", "RC", "RCSYNC",
                                   "ROLH", "ROLL", "CPUROLH", "CPUROLL", "CMRW", "CMRO", "CMRC", "LHRC", "RWRSYNC",
                                   "RWDSYNC", "RWDEVSYNC", "RODEVSYNC", "MCRO", "MCRC", "RAW", "INC_CNT"]:
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
                    f"    assign  {sel_address_bus_rdata:20} = (addr_{address}_sel & ~req_write) ? addr_{address}_sel_bus_rdata : sel_{next_address}_bus_rdata;\n")
            else:
                sel_addr_bus_rdata_assigns.append(
                    f"    assign  {sel_address_bus_rdata:20} = (addr_{address}_sel & ~req_write) ? addr_{address}_sel_bus_rdata : 16'h0;\n")
        return sel_addr_bus_rdata_assigns

    def create_register_block(self, reg, regfile_name):
        reg_name = reg['name']
        reg_type = reg['type']
        width = reg['width']
        init = reg['init']
        width_str = f"[{width - 1}:0]" if width > 1 else ""

        if width == 1:
            block = f"    {regfile_name}_{reg_name}_{reg_type}\n"
            block += f"    u_{reg_name}\n    (\n"
        else:
            block = f"    {regfile_name}_{reg_name}_{reg_type}_{width}\n"
            block += f"    u_{reg_name}\n    (\n"

        if reg_type == "RAW":
            pass
        else:
            block += f"    .clk            (clk),\n"
            block += f"    .rstn           (rstn),\n"

        if reg_type in ["ROD", "RWD", "RODSYNC", "RWDSYNC", "CPUROLH", "CPUROLL"]:
            block += f"    .sw_rstn        ({reg['name']}_sw_rstn),\n"

        if reg_type in ["CMRO", "CMRC", "MCRO", "MCRC", "LHRC"]:
            block += f"    .is_mdio        (is_mdio),\n"

        if reg_type in ["RWR", "RWD", "RWDEV", "SC", "CPUROLH", "CPUROLL", "CMRW", "CMRO", "CMRC", "LHRC",
                        "RWRSYNC", "RWDSYNC", "RWDEVSYNC", "MCRO", "MCRC", "RAW", "INC_CNT"]:
            block += f"    .bus_we         ({reg_name}_bus_we),\n"
            block += f"    .bus_wdata      ({reg_name}_bus_wdata),\n"

        if reg_type in ["RC", "RCSYNC", "ROLH", "ROLL", "CPUROLH", "CPUROLL", "CMRC", "MCRC", "LHRC", "INC_CNT"]:
            block += f"    .bus_re         ({reg_name}_bus_re),\n"

        if reg_type == "INC_CNT":
            block += f"    .bus_clr        ({reg_name}_bus_clr),\n"

        if reg_type == "RAW":
            block += f"    .raw_dev_we     ({reg_name}_raw_we),\n"
            block += f"    .raw_dev_wdata  ({reg_name}_raw_wdata),\n"
            block += f"    .raw_dev_rdata  ({reg_name}_raw_rdata),\n"

        if reg_type in ["ROR", "ROD", "RODEV", "RWR", "RWD", "RWDEV", "RORSYNC", "RODSYNC", "RC", "RCSYNC",
                        "ROLH", "ROLL", "CPUROLH", "CPUROLL", "CMRW", "CMRO", "CMRC", "LHRC", "RWRSYNC",
                        "RWDSYNC", "RWDEVSYNC", "RODEVSYNC", "MCRO", "MCRC", "RAW", "INC_CNT"]:
            block += f"    .bus_rdata      ({reg_name}_bus_rdata),\n"

        if reg_type in ["RWRSYNC", "RWDSYNC", "RODEVSYNC", "RWDEVSYNC"]:
            block += f"    .dev_clk        ({reg_name}_clk),\n"
            block += f"    .dev_rstn       ({reg_name}_rstn),\n"

        if reg_type in ["RODEV", "RWDEV", "RC", "RCSYNC", "RODEVSYNC", "RWDEVSYNC"]:
            block += f"    .dev_we         ({reg_name}_we),\n"

        if reg_type in ["ROR", "ROD", "RODEV", "RWDEV", "RORSYNC", "RODSYNC", "RODEVSYNC", "RWDEVSYNC", "RC",
                        "RCSYNC", "ROLH", "ROLL"]:
            block += f"    .dev_wdata      ({reg_name}_wdata),\n"

        if reg_type in ["RWR", "RWD", "RWDEV", "SC", "RWRSYNC", "RWDSYNC"]:
            block += f"    .dev_rdata      ({reg_name}_rdata),\n"

        block = block.rstrip(",\n") + "\n"
        block += f"    );\n"
        return block

    def get_register_instance(self, yaml_data, regfile_name):
        register_instance = []
        for group in yaml_data:
            reg_name = group['reg_name']
            desc = group['desc']
            address = group['address']
            register_instance.append(f"    // ********************************************************************")
            register_instance.append(f"    // desc:{desc} reg_name:{reg_name} address:{address}")
            register_instance.append(f"    // ********************************************************************")
            for reg in group['fields']:
                register_instance.append(self.create_register_block(reg, regfile_name))
        return register_instance

    def get_register_module(self, reg, regfile_name):
        reg_name = reg['name']
        reg_type = reg['type']
        WIDTH = reg['width']
        INIT = hex(int(reg['init'], 16))[2:]
        if WIDTH == 1:
            module_name = f"{regfile_name}_{reg_name}_{reg_type}"
        else:
            module_name = f"{regfile_name}_{reg_name}_{reg_type}_{WIDTH}"

        aaa = f"[{WIDTH - 1}:0]"
        if WIDTH == 1:
            DATA_WIDTH = f"{'':6}"
        else:
            DATA_WIDTH = f"{aaa:6}"

        if reg_type in ["ROR"]:
            register_module = (f'''\
//---------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice
//---------------------------------------------------------------------
//  ROR           read            read          write         
// --------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    output  {DATA_WIDTH}   bus_rdata,

    input   {DATA_WIDTH}   dev_wdata
);

    reg     {DATA_WIDTH}    cell_data;

    assign  bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else
            cell_data   <=  dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["ROD"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  ROD           read            read          write            True
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,
    input            sw_rstn,

    output  {DATA_WIDTH}   bus_rdata,

    input   {DATA_WIDTH}   dev_wdata
);

    reg     {DATA_WIDTH}    cell_data;

    assign  bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (~sw_rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else
            cell_data   <=  dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["RODEV"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RODEV         read            read          write/we         False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    output  {DATA_WIDTH}   bus_rdata,

    input            dev_we,
    input   {DATA_WIDTH}   dev_wdata
);

    reg     {DATA_WIDTH}    cell_data;

    assign  bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (dev_we)
            cell_data   <=  dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["RWR"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata,

    output  {DATA_WIDTH}   dev_rdata
);

    reg     {DATA_WIDTH}    cell_data;

    assign  bus_rdata = cell_data;
    assign  dev_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

endmodule\n''')
        elif reg_type in ["RWD"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWD           read/write      read/write    read             True
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,
    input            sw_rstn,

    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata,

    output  {DATA_WIDTH}   dev_rdata
);

    reg     {DATA_WIDTH}    cell_data;

    assign  bus_rdata = cell_data;
    assign  dev_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (~sw_rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

endmodule\n''')
        elif reg_type in ["RWDEV"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWDEV         read/write      read/write    write/we         False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata,

    input            dev_we,
    input   {DATA_WIDTH}   dev_wdata,
    output  {DATA_WIDTH}   dev_rdata
);

    reg     {DATA_WIDTH}    cell_data;

    assign  bus_rdata = cell_data;
    assign  dev_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (bus_we)
            cell_data   <=  bus_wdata;
        else if (dev_we)
            cell_data   <=  dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["RORSYNC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RORSYNC       read            read          write            False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    output  {DATA_WIDTH}   bus_rdata,

    input   {DATA_WIDTH}   dev_wdata
);

    reg     {DATA_WIDTH}    cell_data;
    reg     {DATA_WIDTH}    sync_cell_0;
    reg     {DATA_WIDTH}    sync_cell_1;
    
    assign bus_rdata = cell_data;
    
    always @(posedge clk or negedge rstn) begin
      if (~rstn)
        cell_data <= {WIDTH}'h{INIT};
      else
        cell_data <= sync_cell_1;
    end

    always @(posedge clk or negedge rstn) begin
      if (~rstn)
        sync_cell_1 <= {WIDTH}'h{INIT};
      else
        sync_cell_1 <= sync_cell_0;
    end


    always @(posedge clk or negedge rstn) begin
      if (~rstn)
        sync_cell_0 <= {WIDTH}'h{INIT};
      else
        sync_cell_0 <= dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["RODSYNC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RODSYNC       read            read          write            True
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,
    input            sw_rstn,

    output  {DATA_WIDTH}   bus_rdata,

    input   {DATA_WIDTH}   dev_wdata
);

    reg     {DATA_WIDTH}    cell_data;
    reg     {DATA_WIDTH}    sync_cell_0;
    reg     {DATA_WIDTH}    sync_cell_1;
    
    assign bus_rdata = cell_data;
    
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data <= {WIDTH}'h{INIT};
        else if (~sw_rstn)
            cell_data <= {WIDTH}'h{INIT};
        else
            cell_data <= sync_cell_1;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_cell_1 <= {WIDTH}'h{INIT};
        else
            sync_cell_1 <= sync_cell_0;
    end


    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_cell_0 <= {WIDTH}'h{INIT};
        else
            sync_cell_0 <= dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["SC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  SC            write clear     write clear   read             False
// ---------------------------------------------------------------------
module {module_name}
(
    input   wire    clk,
    input   wire    rstn,

    input   wire    bus_we,
    input   wire    bus_wdata,

    output  reg     dev_rdata
);

    reg cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data <= 1'b0;
        else
            cell_data <= bus_we & bus_wdata;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            dev_rdata <= 1'b0;
        else
            dev_rdata <= ~cell_data & bus_we & bus_wdata;
    end

endmodule\n''')
        elif reg_type in ["RC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RC            read clear      read clear    write/we         False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_re,
    output  {DATA_WIDTH}   bus_rdata,

    input            dev_we,
    input   {DATA_WIDTH}   dev_wdata
);

    reg     {DATA_WIDTH}    cell_data;
    
    assign bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (bus_re)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (dev_we)
            cell_data   <=  dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["RCSYNC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RCSYNC        read clear      read clear    write/we         False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_re,
    output  {DATA_WIDTH}   bus_rdata,

    input            dev_we,
    input   {DATA_WIDTH}   dev_wdata
);

    reg     [1:0]               dev_we_dly;
    reg     {DATA_WIDTH}    cell_data;
    reg     {DATA_WIDTH}    cell_data_sync0;
    reg     {DATA_WIDTH}    cell_data_sync1;
    
    assign bus_rdata = cell_data_sync1;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            dev_we_dly   <=  2'b00;
        else
            dev_we_dly   <=  {{dev_we_dly[0], dev_we}};
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (bus_re & (dev_we_dly == 2'b00))
            cell_data   <=  {WIDTH}'h{INIT};
        else if (dev_we)
            cell_data   <=  dev_wdata;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data_sync0   <=  {WIDTH}'h{INIT};
        else
            cell_data_sync0   <=  cell_data;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data_sync1   <=  {WIDTH}'h{INIT};
        else
            cell_data_sync1   <=  cell_data_sync0;
    end

endmodule\n''')
        elif reg_type in ["ROLH"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  ROLH          Latch high      Latch high    write            False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_re,
    output           bus_rdata,

    input            dev_wdata
);

    reg   cell_data;
    reg   cell_lock;

    assign  bus_rdata   =   cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_lock   <=  1'b0;
        else if (~cell_lock)
            cell_lock   <=  dev_wdata;
        else if (cell_lock)
            if(bus_re)
                cell_lock   <=  1'b0;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  1'b0;
        else if (bus_re)
            cell_data   <=  1'b0;
        else if (~cell_lock)
            cell_data   <=  dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["CPUROLH"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  CPUROLH       Latch high      Latch high    write            False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,
    input            sw_rstn,

    input            bus_re,
    output           bus_rdata,
    input            bus_we,
    input            bus_wdata
);

    reg     cell_data;
    wire    _T_1;
    wire    _T_2;
    reg     lock_state;
    wire    _T_3;
    wire    _GEN_1;
    wire    _T_5;
    wire    _T_6;
    wire    _T_7;
    assign  _T_1 = bus_wdata & bus_we;
    assign  _T_2 = bus_we & _T_1;
    assign  _T_3 = 1'h0 == lock_state;
    assign  _GEN_1 = _T_2 | lock_state;
    assign  _T_5 = 1'h0 == lock_state;
    assign  _T_6 = bus_we & _T_5;
    assign  _T_7 = ~sw_rstn;
    assign  bus_rdata   =   cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  1'b0;
        else if (_T_7)
            cell_data   <=  1'b0;
        else if (_T_6)
            cell_data   <=  bus_wdata;
        else if (bus_re)
            cell_data   <=  1'h0;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            lock_state   <=  1'b0;
        else if (_T_3)
            lock_state   <=  _GEN_1;
        else if (lock_state) begin
            if (bus_re)
                lock_state   <=  1'b0;
        end
    end

endmodule\n''')
        elif reg_type in ["ROLL"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  ROLL          Latch low       Latch low     write            False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_re,
    output           bus_rdata,

    input            dev_wdata
);

    reg   cell_data;
    reg   cell_lock;
    wire  cell_unlock;

    assign  bus_rdata   =   cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_lock   <=  1'b0;
        else if (~cell_lock)
            cell_lock   <=  ~dev_wdata;
        else if (cell_lock)
            if(bus_re)
                cell_lock   <=  1'b0;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  1'b0;
        else if (bus_re)
            cell_data   <=  1'b0;
        else if (~cell_lock)
            cell_data   <=  dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["CPUROLL"]:
            register_module = (f'''\
module {module_name}
(
    input            clk,
    input            rstn,
    input            sw_rstn,

    input            bus_re,
    output           bus_rdata,
    input            bus_we,
    input            bus_wdata
);

    reg     cell_data;
    wire    _T;
    wire    _T_1;
    wire    _T_2;
    reg     lock_state;
    wire    _T_3;
    wire    _GEN_1;
    wire    _T_5;
    wire    _T_6;
    wire    _T_7;
    assign  _T = bus_wdata == 1'b0;
    assign  _T_1 = _T & bus_we;
    assign  _T_2 = bus_we & _T_1;
    assign  _T_3 = 1'h0 == lock_state;
    assign  _GEN_1 = _T_2 | lock_state;
    assign  _T_5 = 1'h0 == lock_state;
    assign  _T_6 = bus_we & _T_5;
    assign  _T_7 = ~sw_rstn;
    assign  bus_rdata   =   cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  1'b0;
        else if (_T_7)
            cell_data   <=  1'b0;
        else if (_T_6)
            cell_data   <=  bus_wdata;
        else if (bus_re)
            cell_data   <=  1'h0;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            lock_state   <=  1'b0;
        else if (_T_3)
            lock_state   <=  _GEN_1;
        else if (lock_state) begin
            if (bus_re)
                lock_state   <=  1'b0;
        end
    end

endmodule\n''')
        elif reg_type in ["CMRW"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  CMRW          read/write      read/write    ------           False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_we,
    output  {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata
);

    reg     {DATA_WIDTH}    cell_data;

    assign  bus_rdata   =   cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

endmodule\n''')
        elif reg_type in ["CMRO"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  CMRO          read            read/write    ------           False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            is_mdio,
    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata
);

    reg     {DATA_WIDTH}    cell_data;
    wire  cell_wen;

    assign  bus_rdata   =   cell_data;
    assign  cell_wen    =   bus_we & ~is_mdio;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (cell_wen)
            cell_data   <=  bus_wdata;
    end

endmodule\n''')
        elif reg_type in ["CMRC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  CMRC          read clear      read/write    ------           False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            is_mdio,
    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    input            bus_re,
    output  {DATA_WIDTH}   bus_rdata
);

    reg     {DATA_WIDTH}    cell_data;
    wire  cell_wen;
    wire  mdio_rc;

    assign  bus_rdata   =   cell_data;
    assign  cell_wen    =   bus_we & ~is_mdio;
    assign  mdio_rc     =   bus_re & is_mdio;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (mdio_rc)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (cell_wen)
            cell_data   <=  bus_wdata;
    end

endmodule\n''')
        elif reg_type in ["LHRC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  LHRC          Latch high      read/write    ------           False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            is_mdio,
    input            bus_we,
    input            bus_wdata,
    input            bus_re,
    output           bus_rdata
);

    reg   cell_data;
    reg   cell_lock;
    wire  cpu_wen;
    wire  mdio_ren;

    assign  cpu_wen     =   bus_we & ~is_mdio;
    assign  mdio_ren    =   bus_re & is_mdio;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  1'b0;
        else if (mdio_ren)
            cell_data   <=  1'b0;
        else if (~cell_lock & cpu_wen)
            cell_data   <=  bus_wdata;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_lock   <=  1'b0;
        else if (~cell_lock)
            cell_lock   <=  bus_wdata & cpu_wen;
        else if (cell_lock)
            if(mdio_ren)
                cell_lock   <=  1'b0;
    end

    assign  bus_rdata   =   cell_data;

endmodule\n''')
        elif reg_type in ["RWRSYNC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWRSYNC       read/write      read/write    read             False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata,
    
    input            dev_clk,
    input            dev_rstn,
    output  {DATA_WIDTH}   dev_rdata
);

    reg     {DATA_WIDTH}    cell_data;
    reg     {DATA_WIDTH}    sync_cell_data_0;
    reg     {DATA_WIDTH}    sync_cell_data_1;
    
    assign dev_rdata = sync_cell_data_1;
    assign bus_rdata = cell_data;

    always @(posedge clk or negedge dev_rstn) begin
        if (~dev_rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_cell_data_0    <=  {WIDTH}'h{INIT};
        else
            sync_cell_data_0    <=  cell_data;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_cell_data_1    <=  {WIDTH}'h{INIT};
        else
            sync_cell_data_1    <=  sync_cell_data_0;
    end

endmodule\n''')
        elif reg_type in ["RWDSYNC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWDSYNC       read/write      read/write    read             True
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,
    input            sw_rstn,

    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata,
    
    input            dev_clk,
    input            dev_rstn,
    output  {DATA_WIDTH}   dev_rdata
);

    reg     {DATA_WIDTH}    cell_data;
    reg     {DATA_WIDTH}    sync_cell_data_0;
    reg     {DATA_WIDTH}    sync_cell_data_1;
    
    assign dev_rdata = sync_cell_data_1;
    assign bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (~sw_rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_cell_data_0    <=  {WIDTH}'h{INIT};
        else
            sync_cell_data_0    <=  cell_data;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_cell_data_1    <=  {WIDTH}'h{INIT};
        else
            sync_cell_data_1    <=  sync_cell_data_0;
    end

endmodule\n''')
        elif reg_type in ["RODEVSYNC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RODEVSYNC     read            read          write/we         False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    output  {DATA_WIDTH}   bus_rdata,

    input            dev_clk,
    input            dev_rstn,
    input            dev_we,
    input   {DATA_WIDTH}   dev_wdata
);

    reg     {DATA_WIDTH}    cell_data;
    reg     {DATA_WIDTH}    sync_dev_wdata;
    reg                         sync_dev_we;
    reg                         sync_dev_we_0;
    reg                         sync_dev_we_1;

    assign bus_rdata = cell_data;

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_dev_wdata <= {WIDTH}'h{INIT};
        else if (dev_we)
            sync_dev_wdata <= dev_wdata;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_dev_we <= 1'b0;
        else
            sync_dev_we <= dev_we;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_dev_we_0 <= 1'b0;
        else
            sync_dev_we_0 <= sync_dev_we;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_dev_we_1 <= 1'b0;
        else
            sync_dev_we_1 <= sync_dev_we_0;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data <= {WIDTH}'h{INIT};
        else if (sync_dev_we_1)
            cell_data <= sync_dev_wdata;
    end

endmodule\n''')
        elif reg_type in ["RWDEVSYNC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWDEVSYNC     read/write      read/write    write/we         False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata,
    
    input            dev_clk,
    input            dev_rstn,
    input            dev_we,
    input   {DATA_WIDTH}   dev_wdata
);

    reg     {DATA_WIDTH}    cell_data;
    reg     {DATA_WIDTH}    sync_dev_wdata;
    reg                         sync_dev_we;
    reg                         sync_dev_we_0;
    reg                         sync_dev_we_1;

    assign bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (bus_we)
            cell_data   <=  bus_wdata;
        else if (sync_dev_we_1)
            cell_data   <=  sync_dev_wdata;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_dev_wdata <= {WIDTH}'h{INIT};
        else if (dev_we)
            sync_dev_wdata <= dev_wdata;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_dev_we <= 1'b0;
        else
            sync_dev_we <= dev_we;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_dev_we_0 <= 1'b0;
        else
            sync_dev_we_0 <= sync_dev_we;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_dev_we_1 <= 1'b0;
        else
            sync_dev_we_1 <= sync_dev_we_0;
    end

endmodule\n''')
        elif reg_type in ["MCRO"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  MCRO          read/write      read          ------           False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            is_mdio,
    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata
);

    reg     {DATA_WIDTH}    cell_data;
    wire cell_wen;

    assign  bus_rdata   =   cell_data;
    assign  cell_wen    =   bus_we & is_mdio;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (cell_wen)
            cell_data   <=  bus_wdata;
    end

endmodule\n''')
        elif reg_type in ["MCRC"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  MCRC          read/write      read clear    ------           False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            is_mdio,
    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    input            bus_re,
    output  {DATA_WIDTH}   bus_rdata
);

    reg     {DATA_WIDTH}    cell_data;
    wire  cell_wen;
    wire  cell_ren;

    assign  bus_rdata   =   cell_data;
    assign  cell_wen    =   bus_we & is_mdio;
    assign  cell_ren    =   bus_re & ~is_mdio;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (cell_ren)
            cell_data   <=  {WIDTH}'h{INIT};
        else if (cell_wen)
            cell_data   <=  bus_wdata;
    end

endmodule\n''')
        elif reg_type in ["RAW"]:
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RAW           read/write      read clear    ------           False
// ---------------------------------------------------------------------
module {module_name}
(
    input            bus_we,
    input   {DATA_WIDTH}   bus_wdata,
    output  {DATA_WIDTH}   bus_rdata,

    output           raw_dev_we,
    output  {DATA_WIDTH}   raw_dev_wdata,
    input   {DATA_WIDTH}   raw_dev_rdata
);

    assign  raw_dev_we     =   bus_we;
    assign  raw_dev_wdata  =   bus_wdata;
    assign  bus_rdata      =   raw_dev_rdata;

endmodule\n''')
        elif reg_type in ["INC_CNT"]:
            a = "{{1'd0}, _GEN_0}"
            register_module = (f'''\
//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  INC_CNT       read/write      read clear    ------           False
// ---------------------------------------------------------------------
module {module_name}
(
    input            clk,
    input            rstn,

    input            bus_we,
    input   [5:0]    bus_wdata,
    input            bus_re,
    input            bus_clr,
    output  [5:0]    bus_rdata

);

    reg     [5:0]   cell_data;
    wire    [5:0]   _GEN_0;
    wire    [6:0]   IncResult;
    wire            _T_1;
    wire    [6:0]   _T_2;
    wire    [6:0]   _GEN_1;
    wire    [6:0]   _GEN_2;

    assign _GEN_0 = bus_re ? 6'h0 : cell_data;
    assign IncResult = cell_data + bus_wdata;
    assign _T_1 = IncResult > 7'h3f;
    assign _T_2 = _T_1 ? 7'h3f : IncResult;
    assign _GEN_1 = bus_we ? _T_2 : {a};
    assign _GEN_2 = bus_clr ? 7'h0 : _GEN_1;
    assign bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  6'h0;
        else
            cell_data   <=  _GEN_2[5:0];
    end

endmodule\n''')
        else:
            raise Exception(reg_type)

        return register_module

    def get_module_instance(self, yaml_data, regfile_name):
        module_instance = []
        for group in yaml_data:
            for reg in group['fields']:
                module_instance.append(self.get_register_module(reg, regfile_name))
        return module_instance

    def generate_verilog_code(self, yaml_data, module_name):
        yaml_data = self.read_yaml(yaml_data)
        # Initial module definition with fixed inputs and outputs
        verilog_content = (f'''\
module {module_name}
(
    input   wire             clk,
    input   wire             rstn,
 
    input   wire    [20:0]   req_addr,
    input   wire             req_write,
    input   wire             req_sel,
    input   wire    [15:0]   req_wdata,
 
    output  wire             req_ready,
    output  wire    [15:0]   req_rdata,

''').format(module_name=module_name)

        # Generate port declarations based on the register types in YAML
        ports = self.get_port_declarations(yaml_data)
        verilog_content += ",\n".join(sorted(ports)) + "\n);\n\n"

        bus_we_wires = self.get_bus_we_wires(yaml_data)
        bus_wdata_wires = self.get_bus_wdata_wires(yaml_data)
        bus_re_wires = self.get_bus_re_wires(yaml_data)
        bus_rdata_wires = self.get_bus_rdata_wires(yaml_data)

        addr_selects_wires = self.get_addr_selects_wires(yaml_data)
        addr_selects_bus_rdata_wires = self.get_addr_selects_bus_rdata_wires(yaml_data)
        sel_addr_bus_rdata_wires = self.get_sel_addr_bus_rdata_wires(yaml_data)

        # clk_assigns = self.get_clk_assigns(yaml_data)
        # rstn_assigns = self.get_rstn_assigns(yaml_data)

        bus_we_assigns = self.get_bus_we_assigns(yaml_data)
        bus_wdata_assigns = self.get_bus_wdata_assigns(yaml_data)
        bus_re_assigns = self.get_bus_re_assigns(yaml_data)
        bus_rdata_logic = self.get_bus_rdata_logic(yaml_data)
        bus_ready_logic = self.get_bus_ready_logic()

        addr_selects_assigns = self.get_addr_selects_assigns(yaml_data)
        addr_selects_bus_rdata_assigns = self.get_addr_selects_bus_rdata_assigns(yaml_data)
        sel_addr_bus_rdata_assigns = self.get_sel_addr_bus_rdata_assigns(yaml_data)

        register_inst = self.get_register_instance(yaml_data, module_name)
        module_inst = self.get_module_instance(yaml_data, module_name)

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

        verilog_content += "    // whitch address be selected: req_sel + req_addr\n"
        verilog_content += "\n".join(addr_selects_assigns) + "\n\n"

        verilog_content += "    // bus_re: addr_{address}_sel & ~req_write\n"
        verilog_content += "\n".join(bus_re_assigns) + "\n\n"

        verilog_content += "    // bus_we: addr_{address}_sel & req_write\n"
        verilog_content += "\n".join(bus_we_assigns) + "\n\n"

        verilog_content += "    // req_wdata: bus_wdata\n"
        verilog_content += "\n".join(bus_wdata_assigns) + "\n\n"

        verilog_content += "    // addr_{address}_sel_bus_rdata = {registers bus_rdata}\n"
        verilog_content += "\n".join(addr_selects_bus_rdata_assigns) + "\n\n"

        verilog_content += "    // req_rdata: bus_rdata\n"
        verilog_content += "\n".join(bus_rdata_logic) + "\n"
        verilog_content += "\n    // req_ready: bus_ready\n"
        verilog_content += "\n".join(bus_ready_logic) + "\n"
        verilog_content += "".join(sel_addr_bus_rdata_assigns) + "\n"

        verilog_content += "\n".join(register_inst) + "\n"

        verilog_content += "endmodule\n\n"

        verilog_content += "\n".join(module_inst) + "\n"

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
    print(f"Conversion {hdl_path} successfully!")


if __name__ == "__main__":
    main()
