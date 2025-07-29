module maindec(
    opcode,
	Branch,
    ResultSrc,
    MemWrite,
    ALUSrcA,
	ALUSrcB,
    ImmSrc,
    RegWrite,
    Jump,
	Csr,
	
    ALUop
);
    // input
   	input [6:0] opcode;
	
    // output
    output reg [1:0]Jump;
    output reg Branch, MemWrite, ALUSrcB, RegWrite,Csr;
    output reg [1:0] ResultSrc,ALUSrcA;
	output reg [2:0] ImmSrc;
    output reg [1:0] ALUop;
 
	
	
	
    always@(*)begin
		if(opcode == 7'b111_0011)begin
			Csr = 1'b1;
		end
		else begin 
			Csr = 1'b0;
		end
	end


    always@(*) begin    // main decoder
        case(opcode)
            7'b000_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b10_0000_1001_00000;     // lw
            7'b010_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b00_0100_1100_00000;     // sw
            7'b011_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b10_0000_0000_01000;     // R-type
            7'b110_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b00_1000_0000_10100;     // B-type
            7'b001_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b10_0000_1000_01100;     // I-type ALU
            7'b110_1111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b10_1100_0010_00010;     // jal
            7'b110_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b10_0000_1010_00001;     // jalr
            7'b011_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b11_0010_1000_00000;     // Lui
            7'b001_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b11_0001_1000_00000;     // auipc
            7'b111_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'b01_1100_0000_00000;     // Csr
			default : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 15'h0;
        endcase
    end

endmodule
