`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 04:26:04 PM
// Design Name: 
// Module Name: mux
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module bus_mux(
    input logic gate_marmux,
    input logic gate_pc,
    input logic gate_mdr,
    input logic gate_alu,
    
    input logic [15:0] addrmux,
    input logic [15:0] pc,
    input logic [15:0] mdr,
    input logic [15:0] alu,
    
    output logic [15:0] bus
);

always_comb
begin
    if (gate_marmux == 1) begin
        bus = addrmux;
    end else if (gate_pc == 1) begin
        bus = pc;
    end else if (gate_mdr == 1) begin
        bus = mdr;
    end else begin
        bus = alu;
    end
end
endmodule


module addr1_mux(
    input logic s,
    input logic [15:0] c0, c1,
    
    output logic [15:0] out
);

always_comb
begin
    if (s == 0) begin
        out = c0;
    end else begin
        out = c1;
    end
end
endmodule


module addr2_mux(
    input logic [1:0] s,
    input logic [15:0] c0, c1, c2, c3,
    
    output logic [15:0] out
);

always_comb
begin
    if (s == 0) begin
        out = c0;
    end else if (s == 1) begin
        out = c1;
    end else if (s == 2) begin
        out = c2;
    end else begin
        out = c3;
    end
end
endmodule


module dr_mux(
    input logic dr,
    input logic [2:0] ir,
    output logic [2:0] drmux_out
);

always_comb
begin
    case(dr)
        0:  drmux_out = ir;
        1:  drmux_out = 3'b111;
        default: ;
    endcase
end
endmodule


module sr1_mux(
    input logic sr1,
    input logic [2:0] ir1, ir2,
    output logic [2:0] sr1mux_out
);

always_comb
begin
    case(sr1)
        0:  sr1mux_out = ir1;
        1:  sr1mux_out = ir2;
        default: ;
    endcase
end
endmodule


module sr2_mux(
    input logic sr2,
    input logic [15:0] sext_ir, sr2_out,
    
    output logic [15:0] sr2mux_out
);

always_comb
begin
    case(sr2)
        0: sr2mux_out = sr2_out;
        1: sr2mux_out = sext_ir;
        default: ;
    endcase
end
endmodule


module pc_mux(
    input logic [1:0] pc_in,
    input logic [15:0] bus, addr_out, pc_increment,
    output logic [15:0] pcmux_out
);

always_comb
begin
    case(pc_in)
        2'b00:  pcmux_out = pc_increment;
        2'b01:  pcmux_out = bus;
        2'b10:  pcmux_out = addr_out;
        2'b11:  pcmux_out = 0;
        default: ;
    endcase
end
endmodule


module alu_mux (
    input logic [1:0] aluk,
    input logic [15:0] A,
    input logic [15:0] B,
    
    output logic [15:0] out
);

always_comb
begin
    if (aluk == 0) begin
        out = A+B;
    end else if (aluk == 1) begin
        out = A&B;
    end else if (aluk == 2) begin
        out = ~A;
    end else begin
        out = A;
    end
end
endmodule


module mdr_next (
    input logic mio_en,
    input logic [15:0] mem_rdata,
    input logic [15:0] bus,
    
    output logic [15:0] mdr_next_out
);

always_comb
begin
    case(mio_en)
        0:  mdr_next_out = mem_rdata;
        1:  mdr_next_out = bus;
        default: ;
    endcase
end
endmodule