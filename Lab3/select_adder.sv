module select_adder (
	input  logic  [15:0] a, 
    input  logic  [15:0] b,
	input  logic         cin,
	
	output logic  [15:0] s,
	output logic         cout
);

	/* TODO
		*
		* Insert code here to implement a CSA adder.
		* Your code should be completly combinational (don't use always_ff or always_latch).
		* Feel free to create sub-modules or other files. */
		logic c4;
		logic [2:0] ca;
		logic [2:0] cb;
		logic [15:0] sa;
		logic [15:0] sb;
		
		cra_4_bit CRA0 (.a (a[3:0]), .b (b[3:0]), .cin(cin), .s(s[3:0]), .cout(c4));
		cra_4_bit CRA1a (.a (a[7:4]), .b (b[7:4]), .cin(1'b0), .s(sa[7:4]), .cout(ca[0]));
		cra_4_bit CRA1b (.a (a[7:4]), .b (b[7:4]), .cin(1'b1), .s(sb[7:4]), .cout(cb[0]));
		cra_4_bit CRA2a (.a (a[11:8]), .b (b[11:8]), .cin(1'b0), .s(sa[11:8]), .cout(ca[1]));
		cra_4_bit CRA2b (.a (a[11:8]), .b (b[11:8]), .cin(1'b1), .s(sb[11:8]), .cout(cb[1]));
		cra_4_bit CRA3a (.a (a[15:12]), .b (b[15:12]), .cin(1'b0), .s(sa[15:12]), .cout(ca[2]));
		cra_4_bit CRA3b (.a (a[15:12]), .b (b[15:12]), .cin(1'b1), .s(sb[15:12]), .cout(cb[2]));
		
		mux2 m0 (.sa (sa[7:4]), .sb (sb[7:4]), .cin(c4), .ca(ca[0]), .cb(cb[0]), .s (s[7:4]));
		mux2 m1 (.sa (sa[11:8]), .sb (sb[11:8]), .cin((c4&cb[0])|ca[0]), .ca(ca[1]), .cb(cb[1]), .s (s[11:8]));
		mux2 m2 (.sa (sa[15:12]), .sb (sb[15:12]), .cin((((c4&cb[0])|ca[0])&cb[1])|ca[1]), .ca(ca[2]), .cb(cb[2]), .s (s[15:12]));
		assign cout = ((((c4&cb[0])|ca[0]&cb[1])|ca[1])&cb[2])|ca[2];
endmodule

module mux2 (
    input logic [3:0] sa,
    input logic [3:0] sb,
    input logic cin,
    input logic ca,
    input logic cb,
    output logic [3:0] s
);
    assign s[0] = (cin&sb[0])|(~cin&sa[0]);
    assign s[1] = (cin&sb[1])|(~cin&sa[1]);
    assign s[2] = (cin&sb[2])|(~cin&sa[2]);
    assign s[3] = (cin&sb[3])|(~cin&sa[3]);
endmodule

module cra_4_bit (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic cin,
    output logic [3:0] s,
    output logic cout
);
    logic c1,c2,c3;
    
    full_adder FA0 (.x (a[0]), .y (b[0]), .z (cin), .s (s[0]), .c (c1));
    full_adder FA1 (.x (a[1]), .y (b[1]), .z (c1), .s (s[1]), .c (c2));
    full_adder FA2 (.x (a[2]), .y (b[2]), .z (c2), .s (s[2]), .c (c3));
    full_adder FA3 (.x (a[3]), .y (b[3]), .z (c3), .s (s[3]), .c (cout));
    
endmodule
