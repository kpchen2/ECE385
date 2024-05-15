`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2024 11:53:03 PM
// Design Name: 
// Module Name: computation_unit
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


module computation_unit(
    input logic [7:0] a, s,
    input logic cin,
    input logic sub,
    
    output logic [7:0] out,
    output logic out_x
);
    
    logic [8:0] a_new, s_new, s_temp;
    logic dummy;
    assign a_new[8] = a[7];
    assign s_temp[8] = s[7];
    assign a_new[7:0] = a;
    assign s_temp[7:0] = s;
    
    logic c1, c2, c3, c4, c5, c6, c7, c8;
    logic c_temp;
    logic x_temp;
    
    always_comb
    begin
        if (sub == 1)
        begin
            s_new[7:0] = ~s_temp[7:0];
            s_new[8] = s_temp[8];
            c_temp = 1;
        end
        else
        begin
            s_new = s_temp;
            c_temp = 0;
        end
    end
        
    full_addr FA0 (.x (a_new[0]), .y (s_new[0]), .z (c_temp), .s (out[0]), .c (c1));
    full_addr FA1 (.x (a_new[1]), .y (s_new[1]), .z (c1), .s (out[1]), .c (c2));
    full_addr FA2 (.x (a_new[2]), .y (s_new[2]), .z (c2), .s (out[2]), .c (c3));
    full_addr FA3 (.x (a_new[3]), .y (s_new[3]), .z (c3), .s (out[3]), .c (c4));
    full_addr FA4 (.x (a_new[4]), .y (s_new[4]), .z (c4), .s (out[4]), .c (c5));
    full_addr FA5 (.x (a_new[5]), .y (s_new[5]), .z (c5), .s (out[5]), .c (c6));
    full_addr FA6 (.x (a_new[6]), .y (s_new[6]), .z (c6), .s (out[6]), .c (c7));
    full_addr FA7 (.x (a_new[7]), .y (s_new[7]), .z (c7), .s (out[7]), .c (c8));
    full_addr FA8 (.x (a_new[8]), .y (s_new[8]), .z (c8), .s (dummy), .c (out_x));
        
endmodule

module full_addr (input x,y,z, output s,c);
    assign s = x^y^z;
    assign c = (x&y)|(y&z)|(x&z);
endmodule