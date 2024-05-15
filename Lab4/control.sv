`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2024 08:53:48 PM
// Design Name: 
// Module Name: control
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


module control(
	input logic clk, rlc, run, m_prev, m,
	
	output logic shift, add, sub, rlc_ld
);

	enum logic [4:0] {
		s_start, 
		s_clear, 
		s_check_m, 
		s_add1, 
		s_shift1,
		s_add2,
		s_shift2,
		s_add3, 
		s_shift3,
		s_add4,
		s_shift4,
		s_add5, 
		s_shift5,
		s_add6,
		s_shift6,
		s_add7, 
		s_shift7,
		s_sub,
		s_shift8,
		s_done,
		s_hold
	} cur_state, next_state;
	
	always_comb
    begin
        unique case (cur_state)
        // start 
            s_start:
            begin
                add = 0;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
                
                if (rlc)
                begin
                    rlc_ld = 1;
                end
                else
                begin
                    rlc_ld = 0;
                end
            end
            
            // clear
            s_clear:
            begin
                add = 0;
                sub = 0;
                shift = 0;
                rlc_ld = 1;
            end
            
            // check m
            s_check_m:
            begin
                add = 0;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            // add1
            s_add1:
            begin
                add = 1;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            // shift1
            s_shift1:
            begin
                add = 0;
                sub = 0;
                shift = 1;
                rlc_ld = 0;
            end
            
            // add2
            s_add2:
            begin
                add = 1;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            // shift2
            s_shift2:
            begin
                add = 0;
                sub = 0;
                shift = 1;
                rlc_ld = 0;
            end
            
            // add3
            s_add3:
            begin
                add = 1;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            // shift3
            s_shift3:
            begin
                add = 0;
                sub = 0;
                shift = 1;
                rlc_ld = 0;
            end
            
            // add4
            s_add4:
            begin
                add = 1;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            // shift4
            s_shift4:
            begin
                add = 0;
                sub = 0;
                shift = 1;
                rlc_ld = 0;
            end
            
            // add5
            s_add5:
            begin
                add = 1;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            // shift5
            s_shift5:
            begin
                add = 0;
                sub = 0;
                shift = 1;
                rlc_ld = 0;
            end
            
            // add6
            s_add6:
            begin
                add = 1;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            // shift6
            s_shift6:
            begin
                add = 0;
                sub = 0;
                shift = 1;
                rlc_ld = 0;
            end
            
            // add7
            s_add7:
            begin
                add = 1;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            // shift7
            s_shift7:
            begin
                add = 0;
                sub = 0;
                shift = 1;
                rlc_ld = 0;
            end
            
            // sub
            s_sub:
            begin
                add = 0;
                sub = 1;
                shift = 0;
                rlc_ld = 0;
            end
            
            // shift8
            s_shift8:
            begin
                add = 0;
                sub = 0;
                shift = 1;
                rlc_ld = 0;
            end
            
            // done
            s_done:
            begin
                add = 0;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            // hold
            s_hold:
            begin
                add = 0;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
            
            default:
            begin
                add = 0;
                sub = 0;
                shift = 0;
                rlc_ld = 0;
            end
        endcase
    end
    
    // ------------------------------------------------------------
    
    always_comb
    begin
        
        next_state = cur_state;
        unique case (cur_state)
            // start 
            s_start:
            begin
                if (run)
                begin
                    next_state = s_clear;
                end
                else
                begin
                    next_state = cur_state;
                end
            end
            
            // clear
            s_clear:
            begin;
                next_state = s_check_m;
            end
            
            // check m
            s_check_m:
            begin
                if (m_prev == 1)
                begin
                    next_state = s_add1;
                end
                else
                begin
                    next_state = s_shift1;
                end
            end
            
            // add1
            s_add1:
            begin
                next_state = s_shift1;
            end
            
            // shift1
            s_shift1:
            begin
                if (m == 1)
                begin
                    next_state = s_add2;
                end
                else
                begin
                    next_state = s_shift2;
                end
            end
            
            // add2
            s_add2:
            begin
                next_state = s_shift2;
            end
            
            // shift2
            s_shift2:
            begin
                if (m == 1)
                begin
                    next_state = s_add3;
                end
                else
                begin
                    next_state = s_shift3;
                end
            end
            
            // add3
            s_add3:
            begin
                next_state = s_shift3;
            end
            
            // shift3
            s_shift3:
            begin
                if (m == 1)
                begin
                    next_state = s_add4;
                end
                else
                begin
                    next_state = s_shift4;
                end
            end
            
            // add4
            s_add4:
            begin
                next_state = s_shift4;
            end
            
            // shift4
            s_shift4:
            begin
                if (m == 1)
                begin
                    next_state = s_add5;
                end
                else
                begin
                    next_state = s_shift5;
                end
            end
            
            // add5
            s_add5:
            begin
                next_state = s_shift5;
            end
            
            // shift5
            s_shift5:
            begin
                if (m == 1)
                begin
                    next_state = s_add6;
                end
                else
                begin
                    next_state = s_shift6;
                end
            end
            
            // add6
            s_add6:
            begin
                next_state = s_shift6;
            end
            
            // shift6
            s_shift6:
            begin
                if (m == 1)
                begin
                    next_state = s_add7;
                end
                else
                begin
                    next_state = s_shift7;
                end
            end
            
            // add7
            s_add7:
            begin
                next_state = s_shift7;
            end
            
            // shift7
            s_shift7:
            begin
                if (m == 1)
                begin
                    next_state = s_sub;
                end
                else
                begin
                    next_state = s_shift8;
                end
            end
            
            // sub
            s_sub:
            begin
                next_state = s_shift8;
            end
            
            // shift8
            s_shift8:
            begin
                next_state = s_done;
            end
            
            // done
            s_done:
            begin
                if (~run)
                begin
                    next_state = s_hold;
                end
                else
                begin
                    next_state = cur_state;
                end
            end
            
            // hold
            s_hold:
            begin
                next_state = s_start;
            end
            
        endcase
    end
    
    always_ff @(posedge clk)
    begin
        if (rlc)
        begin
            cur_state <= s_start;
        end
        else
            cur_state <= next_state;
        begin
            
        end
    end
            

endmodule
