module datapath(
    clk,
    n_rst,
    Instr,         // from imem
    ReadData,      // from dmem
    PCSrc,         // from controller ......
    ResultSrc,
    ALUControl,
    ALUSrcA,
    ALUSrcB,
    ImmSrc,
    RegWrite,
    PC,            // for imem  
    ALUResult,     // for dmem ..
    WriteData,
    ByteEnable,
	N,
    Z,
    C,
    V,
    stall,
    //FlushF,
    FlushD,
    FlushE,
	Csr,
    predictionE,
    Branch,
    prediction
);
	
	parameter RESET_PC = 32'h1000_0000;

    //input
    input clk, n_rst,  ALUSrcB, RegWrite;
    input [31:0] Instr, ReadData;
    input [1:0] ResultSrc, ALUSrcA;
    input [2:0] PCSrc; 
    input [2:0] ImmSrc;
    input [4:0] ALUControl;
    input Csr,Branch;
    //input FlushF;
    input FlushD;
    input FlushE;
    
	//output
    output [31:0] PC, ALUResult;
    output [31:0] WriteData;
    output N,Z,C,V;
    output [3:0] ByteEnable;
    output stall;
    output predictionE;

    wire [31:0] PC_next, PC_plus4;
    wire [31:0] ImmExt;                       
    wire [31:0] SrcA, bef_SrcB;
    wire [31:0] bef_SrcA, SrcB;
    wire [31:0] Result;
    wire [31:0] BE_WD,BE_RD;
	wire [31:0] tohost_csr;
    


    assign WriteData = BE_WD;
///////////////////---F_D_DFF----//////////////////////////////////
    wire [31:0] PCD;
    wire [31:0] PC_targetD;
    wire [31:0] PC_plus4D;

///////////////////---D_E_DFF----//////////////////////////////////
    wire [31:0] PCE;
    wire [31:0] PC_plus4E;
    wire [31:0] InstrE;
    wire [31:0] ImmExtE;
    wire [31:0] bef_SrcAE;
    wire [31:0] bef_SrcBE;
    wire [31:0] RdE;
    wire RegWriteE;
    wire [1:0] ResultSrcE;
    wire [31:0]PC_targetE;
    wire CsrE;
    //wire prediction;
    output prediction;

///////////////////---E_M_DFF----//////////////////////////////////
  
	wire [31:0] PC_plus4M;
    wire [31:0] InstrM;
    wire [31:0] WriteDataM;
    wire [31:0] ALUResultM;
    wire [31:0] RdM;
    wire RegWriteM;
    wire [1:0]ResultSrcM;
    wire [31:0]PCM;
    

///////////////////---M_W_DFF----//////////////////////////////////
    wire [31:0] PC_plus4W;
    wire [31:0] InstrW;
    wire [31:0] ALUResultW;
   // wire [31:0] ReadDataW;
    wire [31:0] RdW;
    wire RegWriteW;
    wire [1:0]ResultSrcW;
    

//////////////////---hazard----//////////////////////////////////////
    wire [1:0] ForwardAE;
    wire [1:0] ForwardBE;
    wire [1:0] ForwardAD;
    wire [1:0] ForwardBD;
    wire [31:0] bef_SrcAhz;
    wire [31:0] bef_SrcBhz;
    wire [31:0] hz_SrcA;
    wire [31:0] hz_SrcB;
    wire stall;
    wire stall_D; 
////////////////////////////////////////////////////    
    mux4 u_pc_next_mux4(
        .in0(PC_plus4),
        .in1(PC_targetE),
        .in2(ALUResult),
        .in3(PC_plus4),
        .in4(PC_plus4E),
        //.in5(PC_targetE),
        .in6(PC_targetD),
        .sel(PCSrc),
        .out(PC_next)
    );

    flopr #(.WIDTH(32),.RESET_VALUE(RESET_PC)) u_pc_register(.clk(clk),.n_rst(n_rst),.en(~stall)/*.Flush(FlushF),*/,.d(PC_next),.q(PC));
   /* flopr #(
		.RESET_VALUE(RESET_PC)
	)	u_pc_register(
        .clk(clk),
        .n_rst(n_rst),
        .en(~stall),
        .d(PC_next),
        .q(PC)
    );*/

    adder u_pc_plus4(
        .a(PC), 
        .b(32'h4), 
        .ci(1'b0), 
        .sum(PC_plus4),
        .N(),
        .Z(),
        .C(),
        .V()
    );
 ////////////////////---F_D_DFF----//////////////////////////////////////////////////////////////////////////////////////////////////
    F_D_DFF #(.WIDTH(32),.RESET_VALUE(RESET_PC)) PCF_D(.clk(clk),.n_rst(n_rst),.en(~stall),.Flush(FlushD),.din(PC),.dout(PCD));
    F_D_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) PC_plus4F_D(.clk(clk),.n_rst(n_rst),.en(~stall),.Flush(FlushD),.din(PC_plus4),.dout(PC_plus4D));
    
/////////////////////---D_E_DFF----/////////////////////////////////////////////////////////////////////////////////////////////////    
    D_E_DFF #(.WIDTH(32),.RESET_VALUE(RESET_PC)) PCD_E(.clk(clk),.n_rst(n_rst),.en(~stall),.Flush(FlushE),.din(PCD),.dout(PCE));
    D_E_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) PC_plus4D_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(PC_plus4D),.dout(PC_plus4E));
    D_E_DFF #(.WIDTH(32),.RESET_VALUE(32'h0000_0033)) InstrD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(Instr),.dout(InstrE));
    D_E_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) ImmExtD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(ImmExt),.dout(ImmExtE));
    D_E_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) bef_SrcAD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(bef_SrcAhz),.dout(bef_SrcAE)); 
    D_E_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) bef_SrcBD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(bef_SrcBhz),.dout(bef_SrcBE)); 
    D_E_DFF #(.WIDTH(32),.RESET_VALUE(32'h0000_0033)) RdD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(Instr),.dout(RdE));
    D_E_DFF #(.WIDTH(1),.RESET_VALUE(1'h0)) RegWriteD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(RegWrite),.dout(RegWriteE));
    D_E_DFF #(.WIDTH(1),.RESET_VALUE(1'h0)) predictionD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(prediction),.dout(predictionE));
    D_E_DFF #(.WIDTH(2),.RESET_VALUE(2'h0)) ResultSrcD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(ResultSrc),.dout(ResultSrcE));
    D_E_DFF #(.WIDTH(1),.RESET_VALUE(1'h0)) CsrD_E(.clk(clk),.n_rst(n_rst),.en(~stall) ,.Flush(FlushE),.din(Csr),.dout(CsrE));

/////////////////////---E_M_DFF----/////////////////////////////////////////////////////////////////////////////////////////////////    
    E_M_DFF #(.WIDTH(32),.RESET_VALUE(32'h0000_0033)) InstrE_M(.clk(clk),.n_rst(n_rst),.din(InstrE),.dout(InstrM));
    E_M_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) WriteDataE_M(.clk(clk),.n_rst(n_rst),.din(hz_SrcB),.dout(WriteDataM));
    E_M_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) ALUResultE_M(.clk(clk),.n_rst(n_rst),.din(ALUResult),.dout(ALUResultM));
    E_M_DFF #(.WIDTH(32),.RESET_VALUE(32'h0000_0033)) RdE_M(.clk(clk),.n_rst(n_rst),.din(RdE),.dout(RdM));
    E_M_DFF #(.WIDTH(1),.RESET_VALUE(1'h0)) RegWriteE_M(.clk(clk),.n_rst(n_rst),.din(RegWriteE),.dout(RegWriteM));
    E_M_DFF #(.WIDTH(2),.RESET_VALUE(2'h0)) ResultSrcE_M(.clk(clk),.n_rst(n_rst),.din(ResultSrcE),.dout(ResultSrcM));
    E_M_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) PC_plus4E_M(.clk(clk),.n_rst(n_rst),.din(PC_plus4E),.dout(PC_plus4M));
    E_M_DFF #(.WIDTH(32),.RESET_VALUE(RESET_PC)) PCE_M(.clk(clk),.n_rst(n_rst),.din(PCE),.dout(PCM));

/////////////////////---M_W_DFF----/////////////////////////////////////////////////////////////////////////////////////////////////    
    M_W_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) PC_plus4M_W(.clk(clk),.n_rst(n_rst),.din(PC_plus4M),.dout(PC_plus4W));
    M_W_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) ALUResultM_W(.clk(clk),.n_rst(n_rst),.din(ALUResultM),.dout(ALUResultW));
   // M_W_DFF #(.WIDTH(32),.RESET_VALUE(32'h0)) ReadDataM_W(.clk(clk),.n_rst(n_rst),.din(ReadData),.dout(ReadDataW));
    M_W_DFF #(.WIDTH(32),.RESET_VALUE(32'h0000_0033)) InstrM_W(.clk(clk),.n_rst(n_rst),.din(InstrM),.dout(InstrW));
    M_W_DFF #(.WIDTH(32),.RESET_VALUE(32'h0000_0033)) RdM_W(.clk(clk),.n_rst(n_rst),.din(RdM),.dout(RdW));
    M_W_DFF #(.WIDTH(1),.RESET_VALUE(1'h0)) RegWriteM_W(.clk(clk),.n_rst(n_rst),.din(RegWriteM),.dout(RegWriteW));
    M_W_DFF #(.WIDTH(2),.RESET_VALUE(2'h0)) ResultSrcM_W(.clk(clk),.n_rst(n_rst),.din(ResultSrcM),.dout(ResultSrcW));

////////////////////////--hazard--/////////////////////////////////////////////////////////////////////////////////////////
    hazard_unit u_hazardD_unit(.rs1(Instr[19:15]),.rs2(Instr[24:20]),.rdm(RdM[11:7]),.rdw(RdW[11:7]),.RegWriteM(RegWriteM),.RegWriteW(RegWriteW),.ForwardAE(ForwardAD),.ForwardBE(ForwardBD));
    mux3 hzD_alu_mux3(.in0(bef_SrcA),.in1(Result),.in2(ALUResultM),.sel(ForwardAD),.out(bef_SrcAhz));
    mux3 hzD_alu_mux2(.in0(bef_SrcB),.in1(Result),.in2(ALUResultM),.sel(ForwardBD),.out(bef_SrcBhz));
    
    mux3 hzE_alu_mux3(.in0(bef_SrcAE),.in1(Result),.in2(ALUResultM),.sel(ForwardAE),.out(hz_SrcA));
    mux3 hzE_alu_mux2(.in0(bef_SrcBE),.in1(Result),.in2(ALUResultM),.sel(ForwardBE),.out(hz_SrcB));
    hazard_unit u_hazardE_unit(.rs1(InstrE[19:15]),.rs2(InstrE[24:20]),.rdm(RdM[11:7]),.rdw(RdW[11:7]),.RegWriteM(RegWriteM),.RegWriteW(RegWriteW),.ForwardAE(ForwardAE),.ForwardBE(ForwardBE));
    stall u_stall(.rs1(Instr[19:15]),.rs2(Instr[24:20]),.rde(RdE[11:7]),.ResultSrc(ResultSrcE),.stall(stall));

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////   
    extend u_Extend(
        .ImmSrc(ImmSrc),
        .in(Instr[31:7]),
        .out(ImmExt)
    );
    
	Csr_Logic u_Csr_Logic(
        .clk(clk),
		.opcode(InstrE[6:0]),
		.funct3(InstrE[14:12]),
		.Csr(CsrE),
		.RD1_path(hz_SrcA),
		.ImmExt_path(ImmExtE),
		.tohost_csr(tohost_csr)
	);
	///id에서 IMMExtM과 PCD를 더하는 로직 adder로직 추가.
    adder u_pc_prediction(
        .a(ImmExt), 
        .b(PCD), 
        .ci(1'b0), 
        .sum(PC_targetD),
        .N(),
        .Z(),
        .C(),
        .V()
    );
    back_prediction u_back_prediction(
        .PC_targetD(PC_targetD),
        .Branch(Branch),
        .PCD(PCD),
        .prediction(prediction)
    );

    adder u_pc_target(
        .a(PCE), 
        .b(ImmExtE), 
        .ci(1'b0), 
        .sum(PC_targetE),
        .N(),
        .Z(),
        .C(),
        .V()
    );

	  
    /*adder u_pc_plus4M(
        .a(PCM), 
        .b(32'h4), 
        .ci(1'b0), 
        .sum(PC_plus4M),
        .N(),
        .Z(),
        .C(),
        .V()
    );*/

    

    reg_file_async rf(
        .clk(clk),
		.clkb(clk),
        .ra1(Instr[19:15]),
        .ra2(Instr[24:20]),
        .we(RegWriteW),
        .wa(RdW[11:7]),
        .wd(Result),
        .rd1(bef_SrcA),
        .rd2(bef_SrcB)
    );

    mux3 u_alu_mux3(
        .in0(hz_SrcA),
        .in1(PCE),
        .in2(32'h0),
        .sel(ALUSrcA),
        .out(SrcA)
    );

    mux2 u_alu_mux2(
        .in0(hz_SrcB),
        .in1(ImmExtE),
        .sel(ALUSrcB),
        .out(SrcB)
    );



    alu u_ALU(
        .a_in(SrcA),
        .b_in(SrcB),
        .ALUControl(ALUControl),
        .result(ALUResult),
        .aN(N),
        .aZ(Z),
        .aC(C),
        .aV(V)
    );



    be_logic_load u_be_load(
        .RD(ReadData),
        .Addr_Last2(ALUResultW[1:0]),
        .funct3(InstrW[14:12]),
        .BE_RD(BE_RD)
    );

    be_logic_store u_be_store(
        .WD(WriteDataM),
        .Addr_Last2(ALUResultM[1:0]),
        .funct3(InstrM[14:12]),
        .BE_WD(BE_WD),
		.ByteEnable(ByteEnable)
        
    );

    mux3 u_result_mux3(
        .in0(ALUResultW),
        .in1(BE_RD),
        .in2(PC_plus4W),
        .sel(ResultSrcW),
        .out(Result)
    );



endmodule
