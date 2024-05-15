module reg_8 (
    input  logic 		  Clk, 
	input  logic 		  Reset, 
	input  logic 		  Shift_In, 
	input  logic 		  Load, 
	input  logic 		  Shift_En,
	input  logic [7:0]    D,

	output logic 		  Shift_Out,
	output logic [7:0] 	  Data_Out
);

	// logic [7:0] Data_Out_d;
	
    always_ff @(posedge Clk)
    begin
        if (Reset)
        begin
            Data_Out <= 8'h0;
        end
        else if (Load)
        begin
            Data_Out <= D;
        end
        else if (Shift_En)
        begin
            Data_Out <= { Shift_In, Data_Out[7:1] };
        end
        else
        begin
            Data_Out <= Data_Out;
        end
    end

	assign Shift_Out = Data_Out[0];

endmodule

