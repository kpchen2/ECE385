`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2024 03:15:18 PM
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

timeunit 10ns;
timeprecision 1ns;

//logic Clk;
//logic [15:0] s;
//logic [15:0] a;
//logic [15:0] b;
//logic cin, load;
logic 		clk;
logic		reset;
logic 		run_i; // _i stands for input
logic [15:0] sw_i;

logic 		sign_led;
logic [7:0]  hex_seg_a;
logic [3:0]  hex_grid_a;
logic [7:0]  hex_seg_b;
logic [3:0]  hex_grid_b;

always begin: CLOCK_GENERATION
    #1 clk = ~clk;
end
    
initial begin: CLOCK_INITIALIZATION
    clk = 1;
end

adder_toplevel test_adder(.*);

initial begin: TEST_VECTORS
    reset = 1;
    sw_i <= 16'h0000;
    run_i <= 1'b0;
    
    @(posedge clk);
    
    reset <= 1'b0;
    
    @(posedge clk);
    reset <= 1;
    
    repeat (4) @(posedge clk);
    reset <= 0;
    
    repeat (10) @(posedge clk);
    sw_i <= 16'h1111;
    
    repeat (3) @(posedge clk);
    run_i <= 1'b1;
    repeat (3) @(posedge clk);
    
//    @(posedge clk);
    run_i <= 1'b0;
    
    repeat (3) @(posedge clk);
    run_i <= 1'b1;
    repeat (3) @(posedge clk);
    
//    @(posedge clk);
    run_i <= 1'b0;
    
    @(posedge clk);
    sw_i <= 16'h2222;
    
    repeat (3) @(posedge clk);
    run_i <= 1'b1;
    repeat (3) @(posedge clk);
    
//    @(posedge clk);
    run_i <= 1'b0;
    
    repeat (10) @(posedge clk);
    
    $finish();
end

endmodule
