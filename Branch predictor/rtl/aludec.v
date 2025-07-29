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
    input funct7;
    // output
    output reg [4:0] ALUControl;

    always@(*)begin                // ALU decoder
        if(ALUop == 2'b00)
            ALUControl = 5'b00000;                                                                                                   // lw, sw, Lui, auipc, jalr
        else if(ALUop == 2'b01)begin
           	ALUControl = 5'b00001; //else	
		end 						// b-type
        else if(ALUop == 2'b10) begin
            if (funct3 == 3'b000 && ({opcode[5], funct7} == 2'b00 || {opcode[5], funct7} == 2'b01 || {opcode[5], funct7} == 2'b10))  // add
                ALUControl = 5'b00000;
            else if (funct3 == 3'b000 && {opcode[5], funct7} == 2'b11)																 // sub
                ALUControl = 5'b00001;
            else if (funct3 == 3'b010)																								 // slt
                ALUControl = 5'b00101;
            else if (funct3 == 3'b110)																								 // or
                ALUControl = 5'b00011;
            else if (funct3 == 3'b111)																							     // and
                ALUControl = 5'b00010;
			else if (funct3 == 3'b100)
																																  	 // xor
				ALUControl = 5'b00100;
			else if (funct3 == 3'b001)
				ALUControl = 5'b00110;
																																	 // sll
			else if (funct3 == 3'b101 && ({opcode[5],funct7}==2'b00 || {opcode[5],funct7}==2'b10))
				ALUControl = 5'b00111;																								 // srl
			else if (funct3 == 3'b101 && funct7 == 1'b1)
				ALUControl = 5'b01000;																							     // sra
			else if (funct3 == 3'b011)
				ALUControl = 5'b01001;																								 // sltu
			else
                ALUControl = 5'h0;
		end
		else if(ALUop == 2'b11)begin
			if(funct3 == 3'b001)
				ALUControl = 5'b00110;																							     // slli		 	
			else if(funct3 == 3'b101 && funct7 == 1'b1)
				ALUControl = 5'b01000;																								 // srai
			else if(funct3 == 3'b000 && ({opcode[5],funct7}==2'b00 || {opcode[5],funct7} == 2'b01 || {opcode[5],funct7} ==2'b10)) //addi
				ALUControl = 5'b00000;
            else if (funct3 == 3'b000 && {opcode[5], funct7} == 2'b11)																 // subi
                ALUControl = 5'b00001;
            else if (funct3 == 3'b010)																								 // slti
                ALUControl = 5'b00101;
            else if (funct3 == 3'b110)																								 // ori
				ALUControl = 5'b00011;
            else if (funct3 == 3'b111)																							     // andi
                ALUControl = 5'b00010;
			else if (funct3 == 3'b100)
																																  	 // xori
				ALUControl = 5'b00100;
			else if (funct3 == 3'b101 && ({opcode[5],funct7}==2'b00 || {opcode[5],funct7}==2'b10))
				ALUControl = 5'b00111;																								 // srli
			else if(funct3 == 3'b011)
				ALUControl = 5'b01001;																								 // sltiu
			else
				ALUControl = 5'h0;
		end
    end
        

endmodule
