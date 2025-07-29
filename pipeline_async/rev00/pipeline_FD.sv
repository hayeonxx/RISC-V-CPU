module pipeline_FD(
    clk,
    n_rst,
    en,
    clr,
    Instr,
    PC,
    PC_plus4,
    opcode,
    funct3,
    funct7,
    InstrD,
    PCD,
    PC_plus4D,
    opcodeD,
    funct3D,
    funct7D
);
    input clk;
    input n_rst;
    input en;
    input clr;
    input [31:0] Instr;
    input [31:0] PC;
    input [31:0] PC_plus4;
    input [6:0] opcode;
    input [2:0] funct3;
    input [6:0] funct7;

    output reg [31:0] InstrD;
    output reg [31:0] PCD;
    output reg [31:0] PC_plus4D;
    output reg [6:0] opcodeD;
    output reg [2:0] funct3D;
    output reg [6:0] funct7D;

    parameter   RESET_PC = 32'h1000_0000;

    always @(posedge clk or negedge n_rst) begin
        if (!n_rst) begin
            InstrD <= 32'h_0000_0033;
            PCD <= RESET_PC;
            PC_plus4D <= 32'b0;
            opcodeD <= 7'b0;
            funct3D <= 3'b0;
            funct7D <= 7'b0;
        end 
        else if(clr)begin
            InstrD <= 32'h_0000_0033; //NOP
            PCD <= RESET_PC;
            PC_plus4D <= 32'b0;
            opcodeD <= 7'b0;
            funct3D <= 3'b0;
            funct7D <= 7'b0;        
            end
        else if(en) begin
            InstrD <= Instr;
            PCD <= PC;
            PC_plus4D <= PC_plus4;
            opcodeD <= opcode;
            funct3D <= funct3;
            funct7D <= funct7;
            end
        else begin
            InstrD <= InstrD;
            PCD <= PCD;
            PC_plus4D <= PC_plus4D;
            opcodeD <= opcodeD;
            funct3D <= funct3D;
            funct7D <= funct7D;
            end
        end

endmodule
