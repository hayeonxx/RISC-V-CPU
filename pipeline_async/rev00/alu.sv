module alu(
    a_in,
    b_in,
    ALUControl,
    result,
    aN,
    aZ,
    aC,
    aV
);
    input [31:0] a_in, b_in;
    input [4:0] ALUControl;
    output reg [31:0] result; 
    output reg aN;
    output reg aZ;
    output reg aC;
    output reg aV;

    // FLAG 
    wire N, Z, C, V;
    wire add_sub_b;
    wire [31:0] adder_result, and_result, or_result, xor_result, SLT_result, SLTU_result, sll_result, srl_result, sra_result;
    wire [31:0] b_in_inv;

    assign add_sub_b = (ALUControl == 5'b1_0000 || ALUControl == 5'b1_0111 || ALUControl == 1_1000);
    assign b_in_inv = (add_sub_b) ? ~b_in : b_in; //sub or slt or sltu 2's complement

    adder u_add_32bit_add(
        .a(a_in),
        .b(b_in_inv),
        .ci(add_sub_b),
        .sum(adder_result),
        .N(N),
        .Z(Z),
        .C(C),
        .V(V)
    );    
    
    always@(*)begin
        if (ALUControl == 5'b0_0000 || ALUControl == 5'b1_0000 || ALUControl == 5'b0_0101  || ALUControl == 5'b0_0100 || ALUControl == 5'b0_0110 || ALUControl == 5'b1_0111 ) begin  //add,sub,srl,sll,b-type,u-type,slt
            {aN, aZ, aC, aV} = {N, Z, C, V};
        end
        else if (ALUControl == 5'b0_0001) begin
            aN = and_result[31];
            aZ = (and_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 5'b0_0010) begin
            aN = or_result[31];
            aZ = (or_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else if (ALUControl == 5'b0_0011) begin
            aN = xor_result[31];
            aZ = (xor_result == 32'h0) ? 1'b1 : 1'b0;
            aC = 1'b0;
            aV = 1'b0;
        end
        else begin
            {aN, aZ, aC, aV} = 4'h0;	
        end
    end
    
    assign and_result = a_in & b_in;
    assign or_result = a_in | b_in;
    assign xor_result = a_in ^ b_in;
    assign SLT_result = aN ^ aV;
    assign SLTU_result = (a_in < b_in) ? 32'b1 : 32'b0;
    assign sll_result = a_in << b_in[4:0];
    assign srl_result = a_in >> b_in[4:0];
    assign sra_result = $signed(a_in) >>> b_in[4:0];

    always@(*) begin
        case(ALUControl)
            5'b0_0000 : result = adder_result;        // add
            5'b1_0000 : result = adder_result;        // sub
            5'b0_0001 : result = and_result;          // and
            5'b0_0010 : result = or_result;           // or
            5'b0_0011 : result = xor_result;           //xor
            //3'b010 : result = SLT_result;          // SLT
            5'b1_0111 : result = SLT_result;          // SLT
            5'b1_1000 : result = SLTU_result;       //SLTU
            5'b0_0100 : result = sll_result;           //sll ,slli
            5'b0_0101 : result = srl_result;           //srl
            5'b0_0110 : result = sra_result;         //sra,srai
            default : result = 32'h0000_0033;
        endcase
    end

endmodule
