module riscvsingle(
    clk,
    n_rst,
    PC,
    Instr,
    MemWriteM,
    ALUResult,
    WriteData,
    ReadData,
	  byte_enable
);
	parameter   RESET_PC = 32'h1000_0000;
    //input
    input clk, n_rst;
    input [31:0] Instr, ReadData;
    //output
    output MemWriteM;
    output [31:0] PC, ALUResult, WriteData;
	  output [3:0] byte_enable;

    wire N_flag, Z_flag, C_flag, V_flag;
    wire RegWrite, RegWriteM; 
    wire [1:0] PCSrc;
    wire [1:0] ALUSrcA;
    wire ALUSrcB;
    wire [1:0] ResultSrc, ResultSrcE;
    wire [2:0] ImmSrc;
    wire [4:0] ALUControl;
    wire [4:0] ALUControlE;
    wire Branch;
    wire [31:0] InstrD;
    wire MemWrite;
    wire Jump;

    controller u_controller(
        .clk(clk),
        .n_rst(n_rst),
        .N_flag(N_flag),
        .Z_flag(Z_flag),
        .C_flag(C_flag),
        .V_flag(V_flag),
        .opcode(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[31:25]),
        .InstrD(InstrD),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .Jump(Jump),
        .Branch(Branch)
    );

    datapath #(
		.RESET_PC(RESET_PC)
	) i_datapath(
        .clk(clk),
        .n_rst(n_rst),
        .Instr(Instr),   
        .InstrD(InstrD),     
        .ReadData(ReadData),    
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControl),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .PC(PC),            
        .ALUResultM(ALUResult),   
        .BE_WD(WriteData),      
        .N_flag(N_flag),
        .Z_flag(Z_flag),
        .C_flag(C_flag),
        .V_flag(V_flag),
		    .byte_enable(byte_enable),
        .MemWrite(MemWrite),
        .MemWriteM(MemWriteM),
        .Jump(Jump),
        .Branch(Branch)
    );

endmodule
