module maindec(
    opcode,
  //  PCSrc,
    ResultSrc,
    MemWrite,
    ALUSrcA,
    ALUSrcB,
    ImmSrc,
    RegWrite,
    Jump,
    ALUop,
    Branch
);
    // input
    input [6:0] opcode;
    
    // output
    output reg MemWrite, RegWrite, Jump;
    output reg [1:0] ALUSrcA;
    output reg ALUSrcB;
    output reg [1:0] ResultSrc;
    output reg [2:0] ImmSrc;
    output reg [1:0] ALUop;

    output reg Branch;
/*
    always@(*) begin
        if(B_taken == 1 || Jump == 1) 
            PCSrc = 2'b01;
        else if(opcode == 7'b110_0111)   //jalr
            PCSrc = 2'b10;
        else
            PCSrc = 2'b00;
    end
    */


    always@(*) begin    // main decoder
        case(opcode)
            7'b000_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_000_00_1_0_01_0_00_0;     // lw
            7'b010_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b0_001_00_1_1_00_0_00_0;     // sw
            7'b011_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_000_00_0_0_00_0_10_0;     // R-type
            7'b110_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b0_010_00_0_0_00_1_01_0;	   // beq/bne (B-type)
            7'b001_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_000_00_1_0_00_0_10_0;     // I-type ALU
            7'b110_1111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_011_00_0_0_10_0_01_1;     // jal (J-type)
            7'b110_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_000_00_1_0_10_0_10_0;     //jalr (I-type)
            7'b011_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_100_10_1_0_00_0_00_0;     // lui U-type
            7'b001_0111 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_100_01_1_0_00_0_00_0;     // auipc U-type
            7'b111_0011 : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'b1_101_00_1_0_00_0_11_0;     // csr10000000010000
            default : {RegWrite, ImmSrc, ALUSrcA, ALUSrcB, MemWrite, ResultSrc, Branch, ALUop, Jump} = 14'h0;
        endcase
    end

endmodule
