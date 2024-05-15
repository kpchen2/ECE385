`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2024 08:04:21 PM
// Design Name: 
// Module Name: multiplier
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


module multiplier(
    input logic [7:0] sw,
    input logic clk, RLC, run,
    
    output logic [3:0] hex_grid,
    output logic [7:0] hex_seg,
    output logic [7:0] Aval, Bval,
    output logic Xval
);

    logic X;
    logic [7:0] A;
    logic [7:0] B;
    logic Ain;
    logic Bin;
    logic [7:0] A_keep;
    logic [7:0] B_keep;
    logic Aout;
    logic Bout;
    
    logic canAdd;
    logic canShift;
    logic canSub;
    logic canRLC;
    
    logic [7:0] computation_result;
    logic computation_out;
    
    logic [7:0] sw_SH;
    logic run_SH;
    logic RLC_SH;
    
    // assign LED = {sw_SH, run_SH, RLC_SH};
    assign Xval = X;
    assign Aval = A;
    assign Bval = B;
    
    reg_8 registerA (
		.Clk        (clk),
		.Reset      (RLC_SH | canRLC),
		.Shift_In   (X),
        .Load       (canAdd | canSub),
        .Shift_En   (canShift),
		.D          (computation_result),

		.Shift_Out  (Aout),
		.Data_Out   (A) 
	);
	
	reg_8 registerB (
		.Clk        (clk),
		.Reset      (0),
		.Shift_In   (Aout),
        .Load       (RLC_SH),
        .Shift_En   (canShift),
		.D          (sw),

		.Shift_Out  (Bout),
		.Data_Out   (B) 
	);
                    
	computation_unit compute (
		.a            (A),
		.s            (sw_SH),
		.cin          (1'b0),
		.sub          (canSub),
		
		.out          (computation_result),
		.out_x        (X)
	);

	control cont (
		.clk        (clk),
		.rlc        (RLC_SH),
		.run        (run_SH),
		.m_prev     (B[0]),
		.m          (B[1]),

		.shift      (canShift),
		.add        (canAdd),
		.sub        (canSub),
		.rlc_ld     (canRLC)
	);
    
    HexDriver HexA (
		.clk        (clk),
		.reset      (RLC_SH),

		.in         ({A[7:4], A[3:0], B[7:4], B[3:0]}),
		.hex_seg    (hex_seg),
		.hex_grid   (hex_grid)
	);

    sync_debounce button_sync [1:0] (
        .Clk (clk),
        
        .d ({RLC, run}),
        .q ({RLC_SH, run_SH})
    );
    
    sync_debounce Din_sync [7:0] (
        .Clk (clk),
        
        .d (sw),
        .q (sw_SH)
    );

endmodule
