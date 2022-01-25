module alu(
		input		[3:0]	ctl,
		input		[31:0]	a, b,
		output reg	[31:0]	out,
		output				zero);

	wire [31:0] sub_ab;
	wire [31:0] add_ab;
	wire 		oflow_add;
	wire 		oflow_sub;
	wire 		oflow;
	wire 		slt;
	assign sub_ab = a - b;
	assign add_ab = a + b;
	assign oflow_add = (a[31] == b[31] && add_ab[31] != a[31]) ? 1 : 0;
	assign oflow_sub = (a[31] == b[31] && sub_ab[31] != a[31]) ? 1 : 0;
	assign oflow = (ctl == 4'b0010) ? oflow_add : oflow_sub;
	// set if less than, 2s compliment 32-bit numbers
	assign slt = oflow_sub ? ~(a[31]) : a[31];
    // explicacao do porque slt para definir o resultado de blt está certo:
    // sign-bit   res  a_bit                             exemplo       
    // 1 == 1  &&  1 != 1  -> oflow=0 neg_a > neg_b  ( -10 - -2  )  -> a < b    [ < ] = slt=1
    // 1 == 1  &&  0 != 1  -> oflow=1 neg_a < neg_b  ( -2  - -10 )  -> a > b    [ > ] = slt=0
    // 0 == 0  &&  0 != 0  -> oflow=0 pos_a > pos_b  ( 10  -  2  )  -> a > b    [ > ] = slt=0
    // 0 == 0  &&  1 != 0  -> oflow=1 pos_a < pos_b  (  2  -  10 )  -> a < b    [ < ] = slt=1
    //
    // 0 != 1              -> oflow=0                               -> a > b    [ > ] = slt=0
    // 1 != 0              -> oflow=0                               -> a < b    [ < ] = slt=1
    assign zero = (0 == out) || (1 == slt);
	always @(*) begin
		case (ctl)
			4'd2:  out <= add_ab;				/* add */
			4'd0:  out <= a & b;				/* and */
			4'd12: out <= ~(a | b);				/* nor */
			4'd1:  out <= a | b;				/* or */
			4'd3:  out <= a << b;				/* sll */
			4'd7:  out <= {{31{1'b0}}, slt};	/* slt */
			4'd6:  out <= sub_ab;				/* sub */
			4'd13: out <= a ^ b;				/* xor */
			default: out <= 0;
		endcase
	end

endmodule

/*  the alu operation is determined exclusively by alu control bits (3) */

/*  alu control bits are determined in the alu control unit
*   by two signals : funct3 and aluop */

/*  funct3 bits (3) comes from instruction (14-12) bits */

/*  aluop bits (2) are determined in the control unit exclusively by
*   the opcode */

/* the opcode represents the instruction type */

/* note: there was a problem with the or instruction */

module alu_control(
		input wire [3:0] funct, // problema aqui: funct deveria ter 3 bits mas recebia 4, fodendo o controle todo. resolvido simplesmente truncando essa merda
		input wire [1:0] aluop,
		output reg [3:0] aluctl);

	reg [3:0] _funct;

	always @(*) begin
		case(funct[2:0])
			3'd0:  _funct = 4'd2;	/* add */
			3'd1:  _funct = 4'd3;	/* sll */
			3'd8:  _funct = 4'd6;	/* sub */
			3'd5:  _funct = 4'd1;	/* more akin to srl */
			3'd6:  _funct = 4'd1;	/* or */
			3'd7:  _funct = 4'd12;	/* nor */
			3'd10: _funct = 4'd7;	/* slt */
			default: _funct = 4'd0;
		endcase
	end

	always @(*) begin
		case(aluop)
			2'd0: aluctl = 4'd2;	/* add */
			2'd1: aluctl = 4'd6;	/* sub */
			2'd2: aluctl = _funct;  /* I type defaults here */
			2'd3: aluctl = 4'd2;	/* add */
			default: aluctl = 0;
		endcase
	end

endmodule
