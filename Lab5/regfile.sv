`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/29/2024 05:17:57 PM
// Design Name: 
// Module Name: regfile
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


module regfile(
    input logic clk,
    input logic reset,
    input logic ld_reg,
    input logic [2:0] sr1mux_out,
    input logic [2:0] sr2,
    input logic [2:0] drmux_out,
    input logic [15:0] bus_output,
    output logic [15:0] sr2_out,
    output logic [15:0] sr1_out,
    output logic [15:0] R0, R1, R2, R3, R4, R5, R6, R7
    );
    
always_ff @ (posedge clk)
begin
    if (reset) begin
        R0 <= 0;
        R1 <= 0;
        R2 <= 0;
        R3 <= 0;
        R4 <= 0;
        R5 <= 0;
        R6 <= 0;
        R7 <= 0;
    end
    else if (ld_reg) begin
        case(drmux_out)
            3'b000: R0 <= bus_output;
            3'b001: R1 <= bus_output;
            3'b010: R2 <= bus_output;
            3'b011: R3 <= bus_output;
            3'b100: R4 <= bus_output;
            3'b101: R5 <= bus_output;
            3'b110: R6 <= bus_output;
            3'b111: R7 <= bus_output;
        endcase
    end
end    

always_comb
begin
    case(sr1mux_out)
        3'b000: sr1_out = R0;
        3'b001: sr1_out = R1;
        3'b010: sr1_out = R2;
        3'b011: sr1_out = R3;
        3'b100: sr1_out = R4;
        3'b101: sr1_out = R5;
        3'b110: sr1_out = R6;
        3'b111: sr1_out = R7;
        default:    sr1_out = 0;
    endcase
    case(sr2)
        3'b000: sr2_out = R0;
        3'b001: sr2_out = R1;
        3'b010: sr2_out = R2;
        3'b011: sr2_out = R3;
        3'b100: sr2_out = R4;
        3'b101: sr2_out = R5;
        3'b110: sr2_out = R6;
        3'b111: sr2_out = R7;
        default:    sr2_out = 0;
    endcase
end

endmodule
