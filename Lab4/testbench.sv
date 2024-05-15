`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2024 08:38:51 PM
// Design Name: 
// Module Name: testbench
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


module testbench();

timeunit 1ns;
timeprecision 1ns;

logic [7:0] sw;
logic Clk, RLC, run;

logic [3:0] hex_grid;
logic [7:0] hex_seg;
logic [7:0] Aval, Bval;
logic Xval;

logic [7:0] ans_a;
logic [7:0] ans_b;

always begin: CLOCK_GENERATION
    #1 Clk = ~Clk;
end

initial begin: CLOCK_INITIALIZATION
    Clk = 1;
end

multiplier test_multiplier(.*);

initial begin: TEST_VECTORS
    
    RLC = 1;
    sw <= 8'h02;
    run <= 1'b0;
    
    Xval <= 1'b0;
    
    @(posedge Clk);
    
    RLC <= 1'b0;
    
    @(posedge Clk);
    RLC <= 1;
    
    repeat (4) @(posedge Clk);
    RLC <= 0;
    
    repeat (6) @(posedge Clk);
    
    sw <= 8'h03;
    
    repeat (2) @(posedge Clk);
    run <= 1;
    
    repeat (4) @(posedge Clk);
    run <= 0;
    
    repeat (24) @(posedge Clk);
    sw <= 8'hFE;
    
    repeat (4) @(posedge Clk);
    run <= 1;
    
    repeat (4) @(posedge Clk);
    run <= 0;
    
    repeat (24) @(posedge Clk);
    sw <= 8'h02;
    
    repeat (4) @(posedge Clk);
    run <= 1;
    
    repeat (4) @(posedge Clk);
    run <= 0;
    
    repeat (24) @(posedge Clk);
    sw <= 8'hFE;
    
    repeat (4) @(posedge Clk);
    run <= 1;
    
    repeat (4) @(posedge Clk);
    run <= 0;

end

endmodule
