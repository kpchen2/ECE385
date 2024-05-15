//------------------------------------------------------------------------------
// Company: 		 UIUC ECE Dept.
// Engineer:		 Stephen Kempf
//
// Create Date:    
// Design Name:    ECE 385 Given Code - SLC-3 core
// Module Name:    SLC3
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 09-22-2015 
//    Revised 06-09-2020
//	  Revised 03-02-2021
//    Xilinx vivado
//    Revised 07-25-2023 
//    Revised 12-29-2023
//------------------------------------------------------------------------------

module cpu (
    input   logic        clk,
    input   logic        reset,

    input   logic        run_i,
    input   logic        continue_i,
    output  logic [15:0] hex_display_debug,
    output  logic [15:0] led_o,
   
    input   logic [15:0] mem_rdata,
    output  logic [15:0] mem_wdata,
    output  logic [15:0] mem_addr,
    output  logic        mem_mem_ena,
    output  logic        mem_wr_ena
);


// ----- Internal connections -----

// outputs
logic ld_mar; 
logic ld_mdr; 
logic ld_ir; 
logic ld_ben; 
logic ld_cc; 
logic ld_reg; 
logic ld_pc; 
logic ld_led;

logic gate_pc;
logic gate_mdr;
logic gate_alu; 
logic gate_marmux;

logic [1:0] pcmux;
logic       drmux;
logic       sr1mux;
logic       sr2mux;
logic       addr1mux;
logic [1:0] addr2mux;
logic [1:0] aluk;
logic       mio_en;

// local variables ???
logic [15:0] mdr_in;
logic [15:0] mar; 
logic [15:0] mdr;
logic [15:0] ir;
logic [15:0] pc;
logic ben;
logic [2:0] nzp;

assign mem_addr = mar;
assign mem_wdata = mdr;

// State machine, you need to fill in the code here as well
// .* auto-infers module input/output connections which have the same name
// This can help visually condense modules with large instantiations, 
// but can also lead to confusing code if used too commonly
control cpu_control (
    .*
);

assign led_o = ir;
assign hex_display_debug = ir;

logic [10:0] addr2_c0;
logic [8:0] addr2_c1;
logic [5:0] addr2_c2;

logic [15:0] addr1_out, addr2_out;
logic [15:0] addrmux;
logic [15:0] alu;
logic [15:0] bus_output;
logic [15:0] pc_out;
logic [2:0] drmux_out;
logic [2:0] sr1mux_out;
logic [15:0] sr1_out;
logic [15:0] sr2_out;
logic [15:0] sr2mux_out;
logic [15:0] mdr_next_out;
logic [2:0] next_nzp;
logic [15:0] R0, R1, R2, R3, R4, R5, R6, R7;

// idk if these should be here or in always_comb
addr1_mux addr1_choice (
    .s(addr1mux),
    .c0(pc),
    .c1(sr1_out),
    
    .out(addr1_out)
);

addr2_mux addr2_choice (
    .s(addr2mux),
    .c0(0),
    .c1({ir[5],ir[5],ir[5],ir[5],ir[5],ir[5],ir[5],ir[5],ir[5],ir[5],ir[5:0]}),
    .c2({ir[8],ir[8],ir[8],ir[8],ir[8],ir[8],ir[8],ir[8:0]}),
    .c3({ir[10],ir[10],ir[10],ir[10], ir[10], ir[10:0]}),
    
    .out(addr2_out)
);

sr1_mux sr1_choice (
    .sr1(sr1mux),
    .ir1(ir[11:9]),
    .ir2(ir[8:6]),
    
    .sr1mux_out(sr1mux_out)
);

sr2_mux sr2_choice (
    .sr2(sr2mux),
    .sext_ir({ir[4],ir[4],ir[4],ir[4],ir[4],ir[4],ir[4],ir[4],ir[4],ir[4],ir[4],ir[4:0]}),
    .sr2_out(sr2_out),
    
    .sr2mux_out(sr2mux_out)
);

alu_mux alu_choice (
    .aluk(aluk),
    .A(sr1_out),
    .B(sr2mux_out),
    
    .out(alu)
);

bus_mux bus_choice (
    .gate_marmux(gate_marmux),
    .gate_pc(gate_pc),
    .gate_mdr(gate_mdr),
    .gate_alu(gate_alu),
    .addrmux(addr1_out+addr2_out),
    .pc(pc),
    .mdr(mdr),
    .alu(alu),
        
    .bus(bus_output)
);

pc_mux pc_choice (
    .pc_in(pcmux),
    .bus(bus_output),
    .addr_out(addr1_out+addr2_out),
    .pc_increment(pc+1),
    
    .pcmux_out(pc_out)
);

dr_mux dr_choice (
    .dr(drmux),
    .ir(ir[11:9]),
    
    .drmux_out(drmux_out)
);

mdr_next into_mdr (
    .mio_en(mio_en),
    .mem_rdata(mem_rdata),
    .bus(bus_output),
    
    .mdr_next_out(mdr_next_out)
);

regfile register_file (
    .clk(clk),
    .reset(reset),
    .ld_reg(ld_reg),
    .sr1mux_out(sr1mux_out),
    .sr2(ir[2:0]),
    .drmux_out(drmux_out),
    .bus_output(bus_output),
    .sr2_out(sr2_out),
    .sr1_out(sr1_out),
    .R0(R0),
    .R1(R1),
    .R2(R2),
    .R3(R3),
    .R4(R4),
    .R5(R5),
    .R6(R6),
    .R7(R7)
);

always_comb
begin
    if (bus_output == 0) begin
        next_nzp = 3'b010;
    end else if (bus_output[15] == 1) begin
        next_nzp = 3'b100;
    end else if (bus_output[15] == 0) begin
        next_nzp = 3'b001;
    end else begin
        next_nzp = 3'b000;
    end
end



load_reg #(.DATA_WIDTH(16)) ir_reg (
    .clk    (clk),
    .reset  (reset),

    .load   (ld_ir),
    .data_i (bus_output),

    .data_q (ir)
);

load_reg #(.DATA_WIDTH(16)) pc_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_pc),
    .data_i(pc_out),

    .data_q(pc)
);

load_reg #(.DATA_WIDTH(16)) mdr_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_mdr),
    .data_i(mdr_next_out),

    .data_q(mdr)
);

load_reg #(.DATA_WIDTH(16)) mar_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_mar),
    .data_i(bus_output),

    .data_q(mar)
);

// new registers for part 2
load_reg #(.DATA_WIDTH(1)) ben_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_ben),
    .data_i(ir[11]&nzp[2] | ir[10]&nzp[1] | ir[9]&nzp[0]),

    .data_q(ben)
);

load_reg #(.DATA_WIDTH(3)) nzp_reg (
    .clk(clk),
    .reset(reset),

    .load(ld_cc),
    .data_i(next_nzp),

    .data_q(nzp)
);

endmodule