module controller(
    clk,
    n_rst,
    N_flag,
    Z_flag,
    C_flag,
    V_flag,
    opcode,
    funct3,
    funct7,
    InstrD,
  //  PCSrc,
    ResultSrc,
   // ResultSrcW,
    MemWrite,
    ALUSrcA,
    ALUSrcB,
    ImmSrc,
    RegWrite,
   // RegWriteW,
    ALUControl,
    Jump,
 //   Btaken,
    Branch
);
    // input
    input clk;
    input n_rst;
    input N_flag, Z_flag, C_flag, V_flag;
    input [6:0] opcode;
    input [2:0] funct3;
    input [6:0] funct7;
    input [31:0] InstrD;
   // input Btaken;
    // output
 //   output [1:0] PCSrc;
    output MemWrite, ALUSrcB;
    output RegWrite, Jump;
    output [1:0] ALUSrcA;
    output [1:0] ResultSrc;
    output [2:0] ImmSrc;
    output [4:0] ALUControl;
    output Branch;
    wire [1:0] ALUop;
   // wire Btaken;

    //fd
  
  
    wire [1:0] ResultSrc;
    wire [4:0] ALUControl;
    

    wire MemWrite;

    wire [1:0] PCSrc;
   

    maindec mdec(
        .opcode(opcode),
       // .PCSrc(PCSrc),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .Jump(Jump),
        .ALUop(ALUop),
        .Branch(Branch)
    );

    aludec adec(
        .opcode(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .ALUop(ALUop),
        .ALUControl(ALUControl)
    );
    /*
    
    branch_logic u_branch_logic(
        .funct3(funct3E),
        .Nflag(N_flag),
        .Zflag(Z_flag),
        .Cflag(C_flag),
        .Vflag(V_flag),
        .Btaken(Btaken),
        .Branch(BranchE)
    );
    pc_select u_pc_select_branch(
        .Z_flag(Z_flag),
        .opcode(opcodeE),
        .Jump(JumpE),
        .Btaken(Btaken),
        .PCSrcE(PCSrcE)
    );*/
endmodule
