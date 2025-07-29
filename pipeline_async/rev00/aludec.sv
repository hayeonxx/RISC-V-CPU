module aludec(
    opcode,
    funct3,
    funct7,
    ALUop,
    ALUControl
);
    // input
    input [6:0] opcode;
    input [2:0] funct3;
    input [1:0] ALUop;
    input [6:0] funct7;
    // output
    output reg [4:0] ALUControl;

    always@(*)begin                // ALU decoder
        if(ALUop == 2'b00)
            ALUControl = 5'b0_0000;                                                                                                     // lw, sw(add)
        else if(ALUop == 2'b01)
            ALUControl = 5'b1_0000;                                                                                                   // beq (sub) b-type
        else if(ALUop == 2'b10) begin
            if (funct3 == 3'b000 && ({opcode[5], funct7[5]} == 2'b00 || {opcode[5], funct7[5]} == 2'b01 || {opcode[5], funct7[5]} == 2'b10 || opcode == 7'b110_0111 ) )  // add
                ALUControl = 5'b0_0000;
            else if (funct3 == 3'b000 && ({opcode[5], funct7[5]} == 2'b11))															 // sub
                ALUControl = 5'b1_0000;
            else if (funct3 == 3'b001)                                                                                                //sll,slli,
                    ALUControl = 5'b0_0100;
            else if (funct3 == 3'b101) begin
                if({funct7[5]} == 1'b1)                                                                                             //sra ,srai                                   
                    ALUControl = 5'b0_0110;
                else                                                                                                                //srl
                    ALUControl = 5'b0_0101;
            end
            else if (funct3 == 3'b010)																								 // slt
                ALUControl = 5'b1_0111;
            else if (funct3 == 3'b011)                                                                                              // sltu
                ALUControl = 5'b1_1000;
            else if ( funct3 == 3'b100)                                                                                               // xor
                ALUControl = 5'b0_0011;        
            else if (funct3 == 3'b110)																								 // or
                ALUControl = 5'b0_0010;
            else if (funct3 == 3'b111)																							     // and
                ALUControl = 5'b0_0001;
            else 
                ALUControl = 5'h0;
        end
    end
        

endmodule
