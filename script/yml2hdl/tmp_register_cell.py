import sys


class VerilogWriter:
    def __init__(self, file_path):
        self.file_path = file_path
        self.verilog_content = """
//---------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice
//---------------------------------------------------------------------
//  ROR           read            read          write         
// --------------------------------------------------------------------
module Cell_ROR
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    output  [DATA_WIDTH-1:0]    bus_rdata,

    input   [DATA_WIDTH-1:0]    dev_wdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;

    assign  bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else
            cell_data   <=  dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  ROD           read            read          write            True
// ---------------------------------------------------------------------
module Cell_ROD
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,
    input                       sw_rstn,

    output  [DATA_WIDTH-1:0]    bus_rdata,

    input   [DATA_WIDTH-1:0]    dev_wdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;

    assign  bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (~sw_rstn)
            cell_data   <=  INIT;
        else
            cell_data   <=  dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RODEV         read            read          write/we         False
// ---------------------------------------------------------------------
module Cell_RODEV
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    output  [DATA_WIDTH-1:0]    bus_rdata,

    input                       dev_we,
    input   [DATA_WIDTH-1:0]    dev_wdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;

    assign  bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (dev_we)
            cell_data   <=  dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWR           read/write      read/write    read             False
// ---------------------------------------------------------------------
module Cell_RWR
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata,

    output  [DATA_WIDTH-1:0]    dev_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;

    assign  bus_rdata = cell_data;
    assign  dev_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWD           read/write      read/write    read             True
// ---------------------------------------------------------------------
module Cell_RWD
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,
    input                       sw_rstn,

    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata,

    output  [DATA_WIDTH-1:0]    dev_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;

    assign  bus_rdata = cell_data;
    assign  dev_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (~sw_rstn)
            cell_data   <=  INIT;
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWDEV         read/write      read/write    write/we         False
// ---------------------------------------------------------------------
module Cell_RWDEV
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata,

    input                       dev_we,
    input   [DATA_WIDTH-1:0]    dev_wdata,
    output  [DATA_WIDTH-1:0]    dev_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;

    assign  bus_rdata = cell_data;
    assign  dev_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (bus_we)
            cell_data   <=  bus_wdata;
        else if (dev_we)
            cell_data   <=  dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RORSYNC       read            read          write            False
// ---------------------------------------------------------------------
module Cell_RORSYNC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    output  [DATA_WIDTH-1:0]    bus_rdata,

    input   [DATA_WIDTH-1:0]    dev_wdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    reg     [DATA_WIDTH-1:0]    sync_cell_0;
    reg     [DATA_WIDTH-1:0]    sync_cell_1;
    
    assign bus_rdata = cell_data;
    
    always @(posedge clk or negedge rstn) begin
      if (~rstn)
        cell_data <= INIT;
      else
        cell_data <= sync_cell_1;
    end

    always @(posedge clk or negedge rstn) begin
      if (~rstn)
        sync_cell_1 <= INIT;
      else
        sync_cell_1 <= sync_cell_0;
    end


    always @(posedge clk or negedge rstn) begin
      if (~rstn)
        sync_cell_0 <= INIT;
      else
        sync_cell_0 <= dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RODSYNC       read            read          write            True
// ---------------------------------------------------------------------
module Cell_RODSYNC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,
    input                       sw_rstn,

    output  [DATA_WIDTH-1:0]    bus_rdata,

    input   [DATA_WIDTH-1:0]    dev_wdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    reg     [DATA_WIDTH-1:0]    sync_cell_0;
    reg     [DATA_WIDTH-1:0]    sync_cell_1;
    
    assign bus_rdata = cell_data;
    
    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data <= INIT;
        else if (~sw_rstn)
            cell_data <= INIT;
        else
            cell_data <= sync_cell_1;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_cell_1 <= INIT;
        else
            sync_cell_1 <= sync_cell_0;
    end


    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            sync_cell_0 <= INIT;
        else
            sync_cell_0 <= dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  SC            write clear     write clear   read             False
// ---------------------------------------------------------------------
module Cell_SC
(
    input   wire    clk,
    input   wire    rstn,

    input   wire    bus_we,
    input   wire    bus_wdata,

    output  reg     dev_rdata
);

    reg                         cell_data;

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

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RC            read clear      read clear    write/we         False
// ---------------------------------------------------------------------
module Cell_RC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       bus_re,
    output  [DATA_WIDTH-1:0]    bus_rdata,

    input                       dev_we,
    input   [DATA_WIDTH-1:0]    dev_wdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    
    assign bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (bus_re)
            cell_data   <=  INIT;
        else if (dev_we)
            cell_data   <=  dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RCSYNC        read clear      read clear    write/we         False
// ---------------------------------------------------------------------
module Cell_RCSYNC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       bus_re,
    output  [DATA_WIDTH-1:0]    bus_rdata,

    input                       dev_we,
    input   [DATA_WIDTH-1:0]    dev_wdata
);

    reg     [1:0]               dev_we_dly;
    reg     [DATA_WIDTH-1:0]    cell_data;
    reg     [DATA_WIDTH-1:0]    cell_data_sync0;
    reg     [DATA_WIDTH-1:0]    cell_data_sync1;
    
    assign bus_rdata = cell_data_sync1;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            dev_we_dly   <=  2'b00;
        else
            dev_we_dly   <=  {dev_we_dly[0], dev_we,};
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (bus_re & (dev_we_dly == 2'b00))
            cell_data   <=  INIT;
        else if (dev_we)
            cell_data   <=  dev_wdata;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data_sync0   <=  INIT;
        else
            cell_data_sync0   <=  cell_data;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data_sync1   <=  INIT;
        else
            cell_data_sync1   <=  cell_data_sync0;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  ROLH          Latch high      Latch high    write            False
// ---------------------------------------------------------------------
module Cell_ROLH
(
    input                       clk,
    input                       rstn,

    input                       bus_re,
    output                      bus_rdata,

    input                       dev_wdata
);

    reg                         cell_data;
    reg                         cell_lock;

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

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  CPUROLH       Latch high      Latch high    write            False
// ---------------------------------------------------------------------
module Cell_CPUROLH
(
    input                       clk,
    input                       rstn,
    input                       sw_rstn,

    input                       bus_re,
    output                      bus_rdata,
    input                       bus_we,
    input                       bus_wdata
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
        else if (bus_rd)
            cell_data   <=  1'h0;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            lock_state   <=  1'b0;
        else if (_T_3)
            lock_state   <=  _GEN_1;
        else if (lock_state) begin
            if (bus_rd)
                lock_state   <=  1'b0;
        end
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  ROLL          Latch low       Latch low     write            False
// ---------------------------------------------------------------------
module Cell_ROLL
(
    input                       clk,
    input                       rstn,

    input                       bus_re,
    output                      bus_rdata,

    input                       dev_wdata
);

    reg                         cell_data;
    reg                         cell_lock;
    wire                        cell_unlock;

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

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  CPUROLL       Latch low       Latch low     write            False
// ---------------------------------------------------------------------
module Cell_CPUROLL
(
    input                       clk,
    input                       rstn,
    input                       sw_rstn,

    input                       bus_re,
    output                      bus_rdata,
    input                       bus_we,
    input                       bus_wdata
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
        else if (bus_rd)
            cell_data   <=  1'h0;
    end

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            lock_state   <=  1'b0;
        else if (_T_3)
            lock_state   <=  _GEN_1;
        else if (lock_state) begin
            if (bus_rd)
                lock_state   <=  1'b0;
        end
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  CMRW          read/write      read/write    ------           False
// ---------------------------------------------------------------------
module Cell_CMRW
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       bus_we,
    output  [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;

    assign  bus_rdata   =   cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  CMRO          read            read/write    ------           False
// ---------------------------------------------------------------------
module Cell_CMRO
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       is_mdio,
    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    wire                        cell_wen;

    assign  bus_rdata   =   cell_data;
    assign  cell_wen    =   bus_we & ~is_mdio;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (cell_wen)
            cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  CMRC          read clear      read/write    ------           False
// ---------------------------------------------------------------------
module Cell_CMRC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       is_mdio,
    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    input                       bus_re,
    output  [DATA_WIDTH-1:0]    bus_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    wire                        cell_wen;
    wire                        mdio_rc;

    assign  bus_rdata   =   cell_data;
    assign  cell_wen    =   bus_we & ~is_mdio;
    assign  mdio_rc     =   bus_re & is_mdio;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (mdio_rc)
            cell_data   <=  INIT;
        else if (cell_wen)
            cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  LHRC          Latch high      read/write    ------           False
// ---------------------------------------------------------------------
module Cell_LHRC
(
    input                       clk,
    input                       rstn,

    input                       is_mdio,
    input                       bus_we,
    input                       bus_wdata,
    input                       bus_re,
    output                      bus_rdata
);

    reg                         cell_data;
    reg                         cell_lock;
    wire                        cpu_wen;
    wire                        mdio_ren;

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

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWRSYNC       read/write      read/write    read             False
// ---------------------------------------------------------------------
module Cell_RWRSYNC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata,
    
    input                       dev_clk,
    input                       dev_rstn,
    output  [DATA_WIDTH-1:0]    dev_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    reg     [DATA_WIDTH-1:0]    sync_cell_data_0;
    reg     [DATA_WIDTH-1:0]    sync_cell_data_1;
    
    assign dev_rdata = sync_cell_data_1;
    assign bus_rdata = cell_data;

    always @(posedge clk or negedge dev_rstn) begin
        if (~dev_rstn)
            cell_data   <=  INIT;
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_cell_data_0    <=  INIT;
        else
            sync_cell_data_0    <=  cell_data;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_cell_data_1    <=  INIT;
        else
            sync_cell_data_1    <=  sync_cell_data_0;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWDSYNC       read/write      read/write    read             True
// ---------------------------------------------------------------------
module Cell_RWDSYNC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,
    input                       sw_rstn,

    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata,
    
    input                       dev_clk,
    input                       dev_rstn,
    output  [DATA_WIDTH-1:0]    dev_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    reg     [DATA_WIDTH-1:0]    sync_cell_data_0;
    reg     [DATA_WIDTH-1:0]    sync_cell_data_1;
    
    assign dev_rdata = sync_cell_data_1;
    assign bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (~sw_rstn)
            cell_data   <=  INIT;
        else if (bus_we)
            cell_data   <=  bus_wdata;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_cell_data_0    <=  INIT;
        else
            sync_cell_data_0    <=  cell_data;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_cell_data_1    <=  INIT;
        else
            sync_cell_data_1    <=  sync_cell_data_0;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RODEVSYNC     read            read          write/we         False
// ---------------------------------------------------------------------
module Cell_RODEVSYNC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    output  [DATA_WIDTH-1:0]    bus_rdata,

    input                       dev_clk,
    input                       dev_rstn,
    input                       dev_we,
    input   [DATA_WIDTH-1:0]    dev_wdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    reg     [DATA_WIDTH-1:0]    sync_dev_wdata;
    reg                         sync_dev_we;
    reg                         sync_dev_we_0;
    reg                         sync_dev_we_1;

    assign bus_rdata = cell_data;

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_dev_wdata <= INIT;
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
            cell_data <= INIT;
        else if (sync_dev_we_1)
            cell_data <= sync_dev_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RWDEVSYNC     read/write      read/write    write/we         False
// ---------------------------------------------------------------------
module Cell_RWDEVSYNC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata,
    
    input                       dev_clk,
    input                       dev_rstn,
    input                       dev_we,
    input   [DATA_WIDTH-1:0]    dev_wdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    reg     [DATA_WIDTH-1:0]    sync_dev_wdata;
    reg                         sync_dev_we;
    reg                         sync_dev_we_0;
    reg                         sync_dev_we_1;

    assign bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (bus_we)
            cell_data   <=  bus_wdata;
        else if (sync_dev_we_1)
            cell_data   <=  sync_dev_wdata;
    end

    always @(posedge dev_clk or negedge dev_rstn) begin
        if (~dev_rstn)
            sync_dev_wdata <= INIT;
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

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  MCRO          read/write      read          ------           False
// ---------------------------------------------------------------------
module Cell_MCRO
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       is_mdio,
    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    wire                        cell_wen;

    assign  bus_rdata   =   cell_data;
    assign  cell_wen    =   bus_we & is_mdio;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (cell_wen)
            cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  MCRC          read/write      read clear    ------           False
// ---------------------------------------------------------------------
module Cell_MCRC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       clk,
    input                       rstn,

    input                       is_mdio,
    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    input                       bus_re,
    output  [DATA_WIDTH-1:0]    bus_rdata
);

    reg     [DATA_WIDTH-1:0]    cell_data;
    wire                        cell_wen;
    wire                        cell_ren;

    assign  bus_rdata   =   cell_data;
    assign  cell_wen    =   bus_we & is_mdio;
    assign  cell_ren    =   bus_re & ~is_mdio;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  INIT;
        else if (cell_ren)
            cell_data   <=  INIT;
        else if (cell_wen)
            cell_data   <=  bus_wdata;
    end

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  RAW           read/write      read clear    ------           False
// ---------------------------------------------------------------------
module Cell_MCRC
#(
    parameter   DATA_WIDTH = 16,
    parameter   INIT = 16'h0
)
(
    input                       bus_we,
    input   [DATA_WIDTH-1:0]    bus_wdata,
    output  [DATA_WIDTH-1:0]    bus_rdata,

    output                       raw_dev_we,
    output   [DATA_WIDTH-1:0]    raw_dev_wdata,
    input    [DATA_WIDTH-1:0]    raw_dev_rdata
);

    assign  raw_dev_we     =   bus_we;
    assign  raw_dev_wdata  =   bus_wdata;
    assign  bus_rdata      =   raw_dev_rdata;

endmodule

//----------------------------------------------------------------------
//  Type          MDIO            CPU           DEVice           sw_rstn
//----------------------------------------------------------------------
//  INC_CNT       read/write      read clear    ------           False
// ---------------------------------------------------------------------
module Cell_INC_CNT
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

    assign _GEN_0 = bus_rd ? 6'h0 : cell_data;
    assign IncResult = cell_data + bus_wdata;
    assign _T_1 = IncResult > 7'h3f;
    assign _T_2 = _T_1 ? 7'h3f; : IncResult;
    assign _GEN_1 = bus_we ? _T_2 : {{1'd0}, _GEN_0};
    assign _GEN_2 = bus_clr ? 7'h0 : _GEN_1;
    assign bus_rdata = cell_data;

    always @(posedge clk or negedge rstn) begin
        if (~rstn)
            cell_data   <=  6'h0;
        else
            cell_data   <=  _GEN_2[5:0];
    end

endmodule
"""

    def write_to_file(self):
        try:
            with open(self.file_path, 'w') as file:
                file.write(self.verilog_content)
            print(f"Temp register cells to 'your-project-main-dir'/builds/verilog/register_cells.v")
        except IOError as e:
            print(f"Temp register cells failed: {e}")


def main():
    if len(sys.argv) != 2:
        print("Error!!! The command should be: python3 tmp_register_cell.py <file_path>")
        sys.exit(-1)

    file_path = sys.argv[1]

    writer = VerilogWriter(file_path)
    writer.write_to_file()


if __name__ == "__main__":
    main()
    print("Conversion register cells successfully!")
