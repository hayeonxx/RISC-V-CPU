module datapath(
    clk,
    n_rst,
    Instr,         // from imem
    ReadData,      // from dmem
    ResultSrc,
    ALUControl,
    ALUSrcA,
    ALUSrcB,
    ImmSrc,
    RegWrite,
    PC,            // for imem  
    ALUResultM,     // for dmem ..
    BE_WD, 
    N_flag,     
    Z_flag,
    C_flag,
    V_flag,
    byte_enable,
    MemWrite,
    MemWriteM,
    Jump, 
    Branch,
    InstrD,
    csr
);
    parameter   RESET_PC = 32'h1000_0000;

    //input
    input clk, n_rst, ALUSrcB, RegWrite;
    input [1:0] ALUSrcA;
    input [31:0] Instr, ReadData;
    input [1:0] ResultSrc;
    input Jump;
    input Branch;
    input [2:0] ImmSrc;
    input [4:0] ALUControl;
    input csr;
    input MemWrite;
    //output
    output MemWriteM;
    output [31:0] PC, ALUResultM;
    output [31:0] BE_WD;
    output [31:0] InstrD;
    output N_flag,Z_flag,C_flag,V_flag;
    output [3:0] byte_enable;

    wire MemWriteM;
    wire [31:0] PC_next, PC_target, PC_plus4;
    wire [31:0] ImmExt;                       
    wire [31:0] SrcAE, SrcBE;
    wire [31:0] bef_SrcA, bef_SrcB;
    wire [31:0] ResultW;
    wire [31:0] BE_RD;
    wire [31:0] BE_WD;
   
    wire [31:0] bef_SrcA_F, bef_SrcB_F;
    wire [31:0] bef_SrcAE_F, bef_SrcBE_F;
    // fetch->decode
    wire [31:0] InstrD;
    wire [31:0] PCD;
    wire [31:0] PC_plus4D;
    wire [4:0] RdD;
    wire [31:0] ImmExtD;

    //decode -> execute
    wire [31:0] InstrE;
    wire [31:0] ImmExtE;
    wire [31:0] bef_SrcBE, bef_SrcAE, PC_plus4E;
    wire [4:0] ALUControlE;
    wire [4:0] Ra1E, Ra2E; 
    wire [4:0] RdE;
    wire [1:0] ALUSrcAE;
    wire ALUSrcBE;
    wire [31:0] PCE;
    wire [31:0] PC_targetE;
    wire [1:0]  PCSrc, PCSrcD, PCSrcE;
    wire Branch, BranchE, Jump, JumpE;

    //EXECUTE -> MEMORY access
    wire [31:0] InstrM;
    wire [31:0] PC_plus4M;
    wire [31:0] WriteDataM;
    wire [31:0] ALUResultM;
    wire [31:0] ALUResult;
    wire [1:0] ResultSrcM;
    wire [4:0] RdM;
    wire [31:0] PCM;

    //MEMORY -> WRITE
    wire [31:0] ReadDataW;
    wire [31:0] PC_plus4W;
    wire [31:0] InstrW;
    wire [4:0 ]RdW;

    wire [31:0] ALUResultW;
    wire [1:0] ResultSrc, ResultSrcE;
    wire [1:0] ResultSrcW;
    

    wire [2:0] funct3, funct3D, funct3E, funct3W;
    wire [6:0] funct7, funct7D;
    wire [6:0] opcode, opcodeD, opcodeE;

    wire Btaken;
    
    reg [31:0] rf_wd;
    reg rf_we;
    //Hazard
    wire [1:0] ForwardAE, ForwardBE, ForwardAD, ForwardBD;
    wire en, clr;
    wire StallF, StallD, Stall, FlushE, FlushD, Flush;

    wire csrE, csrM, csrW;
    wire [15:0] tbman_addr, tbman_addrE, tbman_addrM;
    wire tbman_sel, tbman_selE, tbman_selM;
    wire [31:0] tbman_rdata, tbman_rdataM, tbman_rdataW,tbman_wdata, tbman_wdataE, tbman_wdataM;

    Hazard_Unit u_Hazard_Unit(
        .Ra1E(Ra1E),
        .Ra2E(Ra2E),
        .RdM(RdM),
        .RdW(RdW),
        .RegWriteW(RegWriteW),
        .RegWriteM(RegWriteM),
        .Ra1D(InstrD[19:15]),
        .Ra2D(InstrD[24:20]),
        .RdE(RdE),
        .ResultSrcE(ResultSrcE[0]),
        .PCSrcE(PCSrc),
        .StallF(StallF),
        .StallD(StallD),
        .Stall(Stall),
        .FlushE(FlushE),
        .FlushD(FlushD),
        .ForwardAD(ForwardAD),
        .ForwardBD(ForwardBD),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
    );

    pipeline_FD u_pipeline_FD(
        .clk(clk),
        .n_rst(n_rst),
        .en(!StallD),
        .clr(FlushD),
        .Instr(Instr),
        .PC(PC),
        .PC_plus4(PC_plus4),
        .opcode(Instr[6:0]),
        .funct3(Instr[14:12]),
        .funct7(Instr[31:25]),
        .InstrD(InstrD),
        .PCD(PCD),
        .PC_plus4D(PC_plus4D),
        .opcodeD(opcodeD),
        .funct3D(funct3D),
        .funct7D(funct7D)
    );

    pipeline_DE u_pipeline_DE(
        .clk(clk),
        .n_rst(n_rst),
        .en(!Stall),
        .clr(FlushE),
        .InstrD(InstrD),
        .PCD(PCD),
        .PC_plus4D(PC_plus4D),
        .RegWrite(RegWrite),
        .ResultSrc(ResultSrc),
        .MemWrite(MemWrite),
        .Jump(Jump),
        .Branch(Branch),
        .ALUControl(ALUControl),
        .ALUSrcA(ALUSrcA),
        .ALUSrcB(ALUSrcB),
        .bef_SrcA(bef_SrcA), //RD1D
        .bef_SrcB(bef_SrcB), //RD2D
        .ImmExtD(ImmExtD),
        .opcodeD(opcodeD),
        .funct3D(funct3D),
        .Ra1D(InstrD[19:15]),
        .Ra2D(InstrD[24:20]),
        .RdD(InstrD[11:7]),
        .csr(csr),
 
        .csrE(csrE),
        .InstrE(InstrE),
        .PCE(PCE),
        .PC_plus4E(PC_plus4E),
        .RegWriteE(RegWriteE),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .ALUSrcAE(ALUSrcAE),
        .ALUSrcBE(ALUSrcBE),
        .bef_SrcAE(bef_SrcAE), //RD1E
        .bef_SrcBE(bef_SrcBE),  //RD2E
        .ImmExtE(ImmExtE),
        .opcodeE(opcodeE),
        .funct3E(funct3E),
        .Ra1E(Ra1E),
        .Ra2E(Ra2E),
        .RdE(RdE)

    );

    //E->M
    pipeline_EM u_pipeplineEM(
        .clk(clk),
        .n_rst(n_rst),
       // .en(Stall),
        .clr(Flush),
        .ResultSrcE(ResultSrcE),
        .MemWriteE(MemWriteE),
        .RegWriteE(RegWriteE),
        .WriteDataE(bef_SrcAE_F),
        .InstrE(InstrE),
        .ALUResult(ALUResult),
        .bef_SrcBE(bef_SrcBE_F),
        .PC_plus4E(PC_plus4E),
        .RdE(RdE),
        .PCE(PCE),
        .opcodeE(opcodeE),
        .csrE(csrE),
        .tbman_selE(tbman_sel),        // TBMAN 선택 신호
        .tbman_addrE(tbman_addr),      // TBMAN 주소
        .tbman_wdataE(tbman_wdata), 
        .csrM(csrM),
        .ResultSrcM(ResultSrcM),
        .MemWriteM(MemWriteM),
        .RegWriteM(RegWriteM),
        .InstrM(InstrM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .PC_plus4M(PC_plus4M),
        .RdM(RdM),
        .PCM(PCM),
        .tbman_selM(tbman_selM),        // TBMAN 선택 신호
        .tbman_addrM(tbman_addrM),      // TBMAN 주소
        .tbman_wdataM(tbman_wdataM)
    );

    //M->W
    pipeline_MW u_pipeline_MW(
        .clk(clk),
        .n_rst(n_rst),
        .InstrM(InstrM),
        .ResultSrcM(ResultSrcM),
        .RegWriteM(RegWriteM),
        .ReadData(ReadData),
        .PC_plus4M(PC_plus4M),
        .ALUResultM(ALUResultM),
        .RdM(RdM),
        .csrM(csrM),
        .tbman_rdataM(tbman_rdataM),    // TBMAN 읽기 데이터
   // TBMAN 쓰기 데이터
        .ResultSrcW(ResultSrcW),
        .RegWriteW(RegWriteW),
        .ReadDataW(ReadDataW),
        .PC_plus4W(PC_plus4W),
        .ALUResultW(ALUResultW),
        .RdW(RdW),
        .InstrW(InstrW),
        .csrW(csrW),
   //     .tbman_selW(tbman_selW),        // TBMAN 선택 신호 (W 단계)
        .tbman_rdataW(tbman_rdataW)    // TBMAN 읽기 데이터 (W 단계)
     //   .tbman_addrW(tbman_addrW),      // TBMAN 주소 (W 단계)
   //     .tbman_wdataW(tbman_wdataW) 
    );
    
    mux3 u_pc_mux3(
        .in0(PC_plus4),
        .in1(PC_targetE),
        .in2(ALUResult),//m
        .sel(PCSrc),
        .out(PC_next)
    );
    
    flopenr u_pc_register(
        .clk(clk),
        .n_rst(n_rst),
        .en(!StallF),
        .d(PC_next),
        .q(PC)
    );

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
    
    reg_file_async rf(
        .clk(clk),
        .ra1(InstrD[19:15]),
        .ra2(InstrD[24:20]),
        .we(RegWriteW),//regwritew
        .wa(RdW),    //RD INSTR[11:7]
        .wd(ResultW), //resultw  
        .rd1(bef_SrcA_F),
        .rd2(bef_SrcB_F) 
    );

    extend u_extend(
        .ImmSrc(ImmSrc),
        .in(InstrD),
        .out(ImmExtD)
    );
    //hazard
    
    mux3 u_alu_SrcA_hazard_D(
        .in0(bef_SrcA_F), //RD1D
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardAD),
        .out(bef_SrcA)
    );

    mux3 u_alu_SrcB_hazard_D(
        .in0(bef_SrcB_F), //RD2D
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardBD),
        .out(bef_SrcB)
    );
    mux3 u_alu_SrcA_hazard_E(
        .in0(bef_SrcAE), //RD1D
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardAE),
        .out(bef_SrcAE_F) //RD1EW
    );

    mux3 u_alu_SrcB_hazard_E(
        .in0(bef_SrcBE), //RD2D
        .in1(ResultW),
        .in2(ALUResultM),
        .sel(ForwardBE),
        .out(bef_SrcBE_F) //RD2EW
    );

    mux3 u_alu_SrcA_mux3(
        .in0(bef_SrcAE_F),  //RD1EW
        .in1(PCE),
        .in2(32'b0),
        .sel(ALUSrcAE),
        .out(SrcAE)
    );
       
    mux2 u_alu_SrcB_mux2(
        .in0(bef_SrcBE_F), //RDWEW
        .in1(ImmExtE),
        .sel(ALUSrcBE),
        .out(SrcBE)
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

    alu u_ALU(
        .a_in(SrcAE),
        .b_in(SrcBE),
        .ALUControl(ALUControlE),
        .result(ALUResult),
        .aN(N_flag),
        .aZ(Z_flag),
        .aC(C_flag),
        .aV(V_flag)
    );

    branch_logic u_branch_logic(
        .funct3(funct3E),
        .Nflag(N_flag),
        .Zflag(Z_flag),
        .Cflag(C_flag),
        .Vflag(V_flag),
        .Branch(BranchE),
        .Btaken(Btaken)
    );

    pc_select u_pc_select_branch(
        .Z_flag(Z_flag),
        .opcode(opcodeE),
        .Jump(JumpE),
        .Btaken(Btaken),
        .PCSrc(PCSrc)
    );
    /*
    flopr u_flopr_read_Data(
        .clk(clk),
        .n_rst(n_rst),
        .d(ReadData),
        .q(delay_ReadData)
    );
    
    flopr u_stall_1d(
    .clk(clk),
    .n_rst(n_rst),
    .d(StallD),
    .q(stall_1d)
);
flopr u_flush_1d(
    .clk(clk),
    .n_rst(n_rst),
    .d(FlushD),
    .q(flush_1d)
);
flopr u_inst_tmp_1d(
    .clk(clk),
    .n_rst(n_rst),
    .d(Instr),
    .q(inst_tmp_1d)
);
mux4 u_select_inst(
    .in0(Instr),
    .in1(inst_tmp_1d),
    .in2(flush_1d),
    .in3(stall_1d),
    .PC(PC),
    .out(InstrD)//_1)
);*/
    be_logic u_be_logic(
        .clk(clk),
        .n_rst(n_rst),
        .funct3M(InstrM[14:12]),
        .funct3W(InstrW[14:12]),
        .Addr_last2M(ALUResultM[1:0]),
        .Addr_last2W(ALUResultW[1:0]),
        .WD(WriteDataM),  //WRITEDATAM
        .RD(ReadDataW), //readdataw
        .BE_RD(BE_RD),  
        .BE_WD(BE_WD),
        .byte_enable(byte_enable)
    );
    
    mux3 u_result_mux3(
        .in0(ALUResultW),
        .in1(BE_RD), //ReadDataW
        .in2(PC_plus4W),
        .sel(ResultSrcW),
        .out(ResultW)
    );

  
    reg [31:0] tohost_csr;  

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            tohost_csr <= 32'b0;  
        end 
        else if (csrE) begin
            case (funct3E)
                3'b001: tohost_csr <= bef_SrcAE_F; // CSRRW
                3'b101: tohost_csr <= ImmExtE;  // CSRRWI
                default: tohost_csr <= tohost_csr;
            endcase
        end
    end


endmodule
