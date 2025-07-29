module pipeline_EM(
    input clk,
    input n_rst,
    input clr,
    input RegWriteE,
    input [1:0] ResultSrcE,
    input MemWriteE,
    input [31:0] InstrE,
    input [31:0] PCE,
    input [31:0] PC_plus4E,
    input [31:0] bef_SrcBE,
    input [4:0] RdE,
    input [31:0] ALUResult,
    input [31:0] WriteDataE,
    input [6:0] opcodeE,
    input csrE,
    input tbman_selE,
    input [15:0] tbman_addrE,
    input [31:0] tbman_wdataE,

    output reg csrM,
    output reg RegWriteM,
    output reg [1:0] ResultSrcM,
    output reg MemWriteM,
    output reg [31:0] InstrM,
    output reg [31:0] ALUResultM,//ALU
    output reg [31:0] WriteDataM,
    output reg [31:0] PCM,
    output reg [4:0] RdM,
    output reg [31:0] PC_plus4M,
    output reg tbman_selM,
    output reg [15:0] tbman_addrM,
    output reg [31:0] tbman_wdataM 

);

  parameter   RESET_PC = 32'h1000_0000;

 always @(posedge clk or negedge n_rst) begin
        if(!n_rst) begin
          InstrM <= 32'h0000_0033;
          PCM <= RESET_PC;
          PC_plus4M <= 32'b0;
          ResultSrcM <= 2'b0;
          MemWriteM <= 1'b0;
          RegWriteM <= 1'b0;
          ALUResultM <= 32'b0;
          WriteDataM <= 32'b0;
          RdM <= 5'b0;
          csrM <= 1'b0;
          tbman_selM <= 1'b0;
          tbman_addrM <= 16'b0;
          tbman_wdataM <= 32'b0;
        end
        else if (clr) begin
          InstrM <= 32'h0000_0033; // NOP
          PCM <= RESET_PC;
          PC_plus4M <= 32'b0;
          ResultSrcM <= 2'b0;
          MemWriteM <= 1'b0;
          RegWriteM <= 1'b0;
          ALUResultM <= 32'b0;
          WriteDataM <= 32'b0;
          RdM <= 5'b0;
          csrM <= 1'b0;
          tbman_selM <= 1'b0;
          tbman_addrM <= 16'b0;
          tbman_wdataM <= 32'b0;
        end
        else begin
            InstrM <= InstrE;
            PC_plus4M <= PC_plus4E;
            ResultSrcM <= ResultSrcE;
            MemWriteM <= MemWriteE;
            RegWriteM <= RegWriteE;
            ALUResultM <= ALUResult;
            WriteDataM <= bef_SrcBE;
            RdM <= RdE;
            PCM <= PCE;
            csrM <= csrE;
            tbman_selM <= tbman_selE;
            tbman_addrM <= tbman_addrE;
            tbman_wdataM <= tbman_wdataE;
          end
        end
endmodule
