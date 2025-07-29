module controller(
    opcode,
    funct3,
    funct7,
    Branch,
	ResultSrc,
    MemWrite,
    ALUSrcA,
	ALUSrcB,
    ImmSrc,
    RegWrite,
    ALUControl,
	Csr,
    Jump
);
    // input
    input [6:0] opcode;
    input [2:0] funct3;
    input funct7;
    // output
    output Branch, MemWrite, ALUSrcB, RegWrite;
    output Csr;
    output [1:0] ResultSrc, ALUSrcA,Jump;
	output [2:0] ImmSrc;
    output [4:0] ALUControl;

    wire [1:0] ALUop;

    maindec mdec(
		.Branch(Branch),
		.opcode(opcode),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
		.Csr(Csr),
        .ALUop(ALUop)
    );
    
    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        .ALUControl(ALUControl)
    );

endmodule
