module pipeline_DE(
    input clk,
    input n_rst,
    input en,
    input clr,
    input [31:0] InstrD,
    input [31:0] PCD,
    input [31:0] PC_plus4D,
    input RegWrite,
    input [1:0] ResultSrc,
    input MemWrite,
    input Jump,
    input Branch,
    input [4:0] ALUControl,
    input [1:0] ALUSrcA,
    input ALUSrcB,
    //input csr,
    input [31:0] bef_SrcA,
    input [31:0] bef_SrcB,
    input [31:0] ImmExtD,
    input [6:0] opcodeD,
    input [2:0] funct3D,
    input [4:0] Ra1D,
    input [4:0] Ra2D,
    input [4:0] RdD,

    output reg [31:0] InstrE,
    output reg [31:0] PCE,
    output reg [31:0] PC_plus4E,
    output reg RegWriteE,
    output reg [1:0] ResultSrcE,
    output reg MemWriteE,
    output reg JumpE,
    output reg BranchE,
    output reg [4:0] ALUControlE,
    output reg [1:0] ALUSrcAE,
    output reg ALUSrcBE,
    //output reg csrE,
    output reg [31:0] bef_SrcAE,
    output reg [31:0] bef_SrcBE,
    output reg [31:0] ImmExtE,
    output reg [6:0] opcodeE,
    output reg [2:0] funct3E,
    output reg [4:0] Ra1E,
    output reg [4:0] Ra2E,
    output reg [4:0] RdE

);
    parameter   RESET_PC = 32'h1000_0000;

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            InstrE <= 32'h0000_0033;
            PCE <= RESET_PC ;
            PC_plus4E <= 32'b0;
            RegWriteE <= 1'b0;
            ResultSrcE <= 2'b0;
            MemWriteE <= 1'b0;
            JumpE <= 1'b0;
            BranchE <= 1'b0;
            ALUControlE <= 5'b0;
            ALUSrcAE <= 2'b0;
            ALUSrcBE <= 1'b0;
            bef_SrcAE <= 32'b0;
            bef_SrcBE <= 32'b0;
            ImmExtE <= 32'b0;
            opcodeE <= 7'b0;
            funct3E <= 3'b0;
            Ra1E <= 5'b0;
            Ra2E <= 5'b0;
            RdE <= 5'b0;
        end 
        else if(clr) begin
                InstrE <= 32'h0000_0033;
                PCE <= RESET_PC ;
                PC_plus4E <= 32'b0;
                RegWriteE <= 1'b0;
                ResultSrcE <= 2'b0;
                MemWriteE <= 1'b0;
                JumpE <= 1'b0;
                BranchE <= 1'b0;
                ALUControlE <= 5'b0;
                ALUSrcAE <= 2'b0;
                ALUSrcBE <= 1'b0;
                bef_SrcAE <= 32'b0;
                bef_SrcBE <= 32'b0;
                ImmExtE <= 32'b0;
                opcodeE <= 7'b0;
                funct3E <= 3'b0;
                Ra1E <= 5'b0;
                Ra2E <= 5'b0;
                RdE <= 5'b0;
            end
            else if(en) begin
                InstrE <= InstrD;
                PCE <= PCD;
                PC_plus4E <= PC_plus4D;
                RegWriteE <= RegWrite;
                ResultSrcE <= ResultSrc;
                MemWriteE <= MemWrite;
                JumpE <= Jump;
                BranchE <= Branch;
                ALUControlE <= ALUControl;
                ALUSrcAE <= ALUSrcA;
                ALUSrcBE <= ALUSrcB;
                bef_SrcAE <= bef_SrcA;
                bef_SrcBE <= bef_SrcB;
                ImmExtE <= ImmExtD;
                opcodeE <= opcodeD;
                funct3E <= funct3D;
                Ra1E <= Ra1D;
                Ra2E <= Ra2D;
                RdE <= RdD;
            end 
            else begin
                InstrE <= InstrD;
                PCE <= PCD;
                PC_plus4E <= PC_plus4D;
                RegWriteE <= RegWrite;
                ResultSrcE <= ResultSrc;
                MemWriteE <= MemWrite;
                JumpE <= Jump;
                BranchE <= Branch;
                ALUControlE <= ALUControl;
                ALUSrcAE <= ALUSrcA;
                ALUSrcBE <= ALUSrcB;
                bef_SrcAE <= bef_SrcA;
                bef_SrcBE <= bef_SrcB;
                ImmExtE <= ImmExtD;
                opcodeE <= opcodeD;
                funct3E <= funct3D;
                Ra1E <= Ra1D;
                Ra2E <= Ra2D;
                RdE <= RdD;               
            end
        end
    
endmodule