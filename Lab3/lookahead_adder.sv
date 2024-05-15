module lookahead_adder (
	input  logic  [15:0] a, 
    input  logic  [15:0] b,
	input  logic         cin,
	
	output logic  [15:0] s,
	output logic         cout
);

	/* TODO
		*
		* Insert code here to implement a CLA adder.
		* Your code should be completly combinational (don't use always_ff or always_latch).
		* Feel free to create sub-modules or other files. */
		logic [15:0] c;
		logic [3:0] P;
		logic [3:0] G;
		cla4 C0 (.a (a[3:0]), .b (b[3:0]), .cin (cin), .s (s[3:0]), .PG (P[0]), .GG (G[0]));
        cla4 C1 (.a (a[7:4]), .b (b[7:4]), .cin (G[0]|(cin&P[0])), .s (s[7:4]), .PG (P[1]), .GG (G[1]));
        cla4 C2 (.a (a[11:8]), .b (b[11:8]), .cin (G[1]|(G[0]&P[1])|(cin&P[0]&P[1])), .s (s[11:8]), .PG (P[2]), .GG (G[2]));
        cla4 C3 (.a (a[15:12]), .b (b[15:12]), .cin (G[2]|(G[1]&P[2])|(G[0]&P[2]&P[1])|(cin&P[0]&P[1]&P[2])), .s (s[15:12]), .PG (P[3]), .GG (G[3]));
        assign cout = G[3]|(G[2]&P[3])|(G[1]&P[3]&P[2])|(G[0]&P[3]&P[2]&P[1])|(cin&P[0]&P[1]&P[2]&P[3]);
endmodule


module cla4 (
    input logic [3:0] a,
    input logic [3:0] b,
    input logic cin,
    output logic [3:0] s,
    output logic PG,
    output logic GG
);
    logic [3:0] g;
    logic [3:0] p;
    assign g = a&b;
    assign p = a^b;
    
    assign PG = p[0]&p[1]&p[2]&p[3];
    assign GG = g[3]|(g[2]&p[3])|(g[1]&p[3]&p[2])|(g[0]&p[3]&p[2]&p[1]);
    
    full_adder FA0 (.x (a[0]), .y (b[0]), .z (cin), .s (s[0]), .c ());
    full_adder FA1 (.x (a[1]), .y (b[1]), .z ((cin&p[0])|g[0]), .s (s[1]), .c ());
    full_adder FA2 (.x (a[2]), .y (b[2]), .z ((cin&p[0]&p[1])|(g[0]&p[1])|g[1]), .s (s[2]), .c ());
    full_adder FA3 (.x (a[3]), .y (b[3]), .z ((cin&p[0]&p[1]&p[2])|(g[0]&p[1]&p[2])|(g[1]&p[2])|g[2]), .s (s[3]));
endmodule
