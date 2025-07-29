module extend(
	ImmSrc,
	in,
	out
);
	input [2:0] ImmSrc;
	input [31:0] in;     // from instruction[31:0]
	output reg [31:0] out;
	
	assign opcode = in[6:0];
	//assign funct3 = in[7:5];
	// ImmSrc 000 = I-type
	// ImmSrc 001 = S-type
	// ImmSrc 010 = B-type
	// ImmSrc 011 = J-type
	// ImmSrc 100 = U-type
	// ImmSrc 101 = CSRRWI

	always@(*) begin
		if (ImmSrc == 3'b000) begin
			out = {{20{in[31]}}, in[31:20]};	
		end	 
		else if (ImmSrc == 3'b001)                                    // S-type
			out = {{20{in[31]}}, in[31:25], in[11:7]};		
		else if (ImmSrc == 3'b010)                                                // B-type	
			out = {{20{in[31]}}, in[7], in[30:25], in[11:8], 1'b0};	
		else if (ImmSrc == 3'b011)                                    // J-type
			out = {{12{in[31]}}, in[31], in[19:12], in[20], in[30:21], 1'b0}; 
		else if (ImmSrc == 3'b100)
			out = {in[31:12], 12'b0};     
		else if (ImmSrc == 3'b101) 
			out = {27'b0, in[19:15]};	// U-type
		else 
			out = 32'h0;
	end
endmodule
