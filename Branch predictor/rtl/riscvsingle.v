module riscvsingle(
    clk,
    n_rst,
    PC,
    Instr,
    MemWriteE,
    ALUResult,
    WriteData,
	ByteEnable,
    ReadData
);

	parameter RESET_PC = 32'h1000_0000;
    //input
    input clk, n_rst;
    input [31:0] Instr, ReadData;
    //output
    output [31:0] PC, ALUResult, WriteData;
    output [3:0]ByteEnable;

	wire  ALUSrcB, RegWrite, MemWrite, N, Z, C ,V;
    wire Csr; 
    wire [2:0] PCSrc; 
    wire [1:0] ALUSrcA,Jump;  
    wire [1:0] ResultSrc;
    wire [2:0] ImmSrc;
	wire [4:0] ALUControl;
/////////////---FD-----/////////////////////////////////////////
    wire [31:0] InstrD;
    wire stall_1d;
    wire FlushD_1d;
    wire [31:0]instr_temp_1d;
    wire Branch,prediction;

/////////////---DE-----/////////////////////////////////////////    
    output MemWriteE;
    wire [31:0] InstrE;
 
    wire BranchE,predictionE;
    wire [1:0] JumpE;
    
    wire [4:0]ALUControlE;
    wire [1:0] ALUSrcAE;
    wire ALUSrcBE;
    
////////////---EM-----///////////////////////////////////////////
    
    

////////////---MW-----//////////////////////////////////////////


////////////---hazard-----//////////////////////////////////////////
    wire stall;

    //wire FlushF;
    wire FlushD;
    wire FlushE;

/////////////---hazard-----/////////////////////////////////////////////////////////////////////////////////////////////////////////
flush u_flush(.PCSrc(PCSrc),.stall(stall)/*.FlushF(FlushF),*/,.FlushD(FlushD),.FlushE(FlushE));


////////////---FD------///////////////////////////////////////////////////////////////////////////////////////////////

sync_block u_sync_block(.instr_temp(Instr),.instr_temp_1d(instr_temp_1d),.PC(PC),.FlushD_1d(FlushD_1d),.stall_1d(stall_1d),.InstrD(InstrD));

delay #(.WIDTH(1),.RESET_VALUE(1'h0)) u_stall_1d(.clk(clk),.n_rst(n_rst),.din(stall),.dout(stall_1d));
delay #(.WIDTH(1),.RESET_VALUE(1'h0)) u_FlushD_1d(.clk(clk),.n_rst(n_rst),.din(FlushD),.dout(FlushD_1d));
delay #(.WIDTH(32),.RESET_VALUE(32'h0000_0033)) InstrD_1d(.clk(clk),.n_rst(n_rst),.din(Instr),.dout(instr_temp_1d));



    controller u_controller(
		.Branch(Branch),
        .opcode(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7(InstrD[30]),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .ALUSrcA(ALUSrcA),
		.ALUSrcB(ALUSrcB),
        .ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .ALUControl(ALUControl),
        .Csr(Csr),
		.Jump(Jump)
    );
///////////////---DE-----///////////////////////////////////////////////////////////////////////////////////////////////////////
D_E_DFF #(.WIDTH(32),.RESET_VALUE(32'h0000_0033)) InstrD_E(.clk(clk),.n_rst(n_rst),.en(~stall),.Flush(FlushE),.din(InstrD),.dout(InstrE));
D_E_DFF #(.WIDTH(1),.RESET_VALUE(1'h0)) BranchD_E(.clk(clk),.n_rst(n_rst),.en(~stall),.Flush(FlushE),.din(Branch),.dout(BranchE));
D_E_DFF #(.WIDTH(2),.RESET_VALUE(2'h0)) JumpD_E(.clk(clk),.n_rst(n_rst),.en(~stall),.Flush(FlushE),.din(Jump),.dout(JumpE));

D_E_DFF #(.WIDTH(1),.RESET_VALUE(1'h0)) MemWriteD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(MemWrite),.dout(MemWriteE));
D_E_DFF #(.WIDTH(5),.RESET_VALUE(5'h0)) ALUControlD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(ALUControl),.dout(ALUControlE));
D_E_DFF #(.WIDTH(2),.RESET_VALUE(2'h0)) ALUSrcAD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(ALUSrcA),.dout(ALUSrcAE));
D_E_DFF #(.WIDTH(1),.RESET_VALUE(1'h0)) ALUSrcBD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(ALUSrcB),.dout(ALUSrcBE));


//////////////---EM-----////////////////////////////////////////////////////////////////////////////////////////////////////////



/////////////---MW-----/////////////////////////////////////////////////////////////////////////////////////////////////////////




	Branch_Logic u_branch(
		.funct3(InstrE[14:12]),
		.N(N),
		.Z(Z),
		.C(C),
		.V(V),
        .predictionE(predictionE), 
		.prediction(prediction),
        .BranchE(BranchE),
        .Jump(JumpE),
        .PCSrc(PCSrc)
		
	);

    

    datapath #(
			.RESET_PC(RESET_PC)
	) i_datapath(
        .clk(clk),
        .n_rst(n_rst),
        .Instr(InstrD),        
        .ReadData(ReadData),    
        .PCSrc(PCSrc),      
        .ResultSrc(ResultSrc),
        .ALUControl(ALUControlE),
        .ALUSrcA(ALUSrcAE),
        .ALUSrcB(ALUSrcBE),
		.ImmSrc(ImmSrc),
        .RegWrite(RegWrite),
        .PC(PC),            
        .ALUResult(ALUResult),   
        .WriteData(WriteData),      
        .ByteEnable(ByteEnable),
		.N(N),
        .Z(Z),
        .C(C),
        .V(V),
        .stall(stall),
        .Branch(Branch),
        //.FlushF(FlushF),
        .FlushD(FlushD),
        .FlushE(FlushE),
		.Csr(Csr),
        .predictionE(predictionE),
        .prediction(prediction)
    );


endmodule
