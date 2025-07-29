module pipeline_MW(
    input clk,
    input n_rst,
    input RegWriteM,
    input [1:0] ResultSrcM,
    input [31:0] ReadData,
    input [31:0] ALUResultM,
    input [4:0] RdM,
    input [31:0] PC_plus4M,
    input [31:0] InstrM,
    input csrM,
 //   input tbman_selM,
    input [31:0] tbman_rdataM,
  //  input [15:0] tbman_addrM,
  //  input [31:0] tbman_wdataM,

    output reg csrW,
    output reg RegWriteW,
    output reg [1:0] ResultSrcW,
    output reg [31:0] ReadDataW,
    output reg [31:0] ALUResultW,
    output reg [4:0] RdW,
    output reg [31:0] PC_plus4W,
    output reg [31:0] InstrW,
  //  output reg tbman_selW,
    output reg [31:0] tbman_rdataW
 //   output reg [15:0] tbman_addrW,
 //   output reg [31:0] tbman_wdataW
);

  always @(posedge clk or negedge n_rst) begin
      if (!n_rst) begin
        InstrW <= 32'h0000_0033;
        ResultSrcW <= 2'b0;
        RegWriteW <= 1'b0;
        ReadDataW <= 32'b0;
        PC_plus4W <= 32'b0;
        ALUResultW <= 32'b0;
        RdW <= 5'b0;
        csrW <= 1'b0;
    //   tbman_selW <= 1'b0;
        tbman_rdataW <= 32'b0;
    //    tbman_addrW <= 16'b0;
     //   tbman_wdataW <= 32'b0;
      end 
      else begin
        InstrW <= InstrM;
        ResultSrcW <= ResultSrcM;
        RegWriteW <= RegWriteM;
        ReadDataW <= ReadData;
        PC_plus4W <= PC_plus4M;
        ALUResultW <= ALUResultM;
        RdW <= RdM;
        csrW <= csrM;
    //    tbman_selW <= tbman_selM;
        tbman_rdataW <= tbman_rdataM;
     //   tbman_addrW <= tbman_addrM;
     //   tbman_wdataW <= tbman_wdataM;
      end    
  end

endmodule
