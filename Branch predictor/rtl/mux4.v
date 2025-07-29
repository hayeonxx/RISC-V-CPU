module mux4(
    in0,
    in1,
    in2,
    in3,
    in4,
    //in5,
    in6,
    sel,
    out
);
    input [31:0] in0, in1, in2,in3,in4,in6; 
    input [2:0] sel;
    output reg [31:0] out;
    
    always@(*)begin
        if(sel == 3'b000)
            out = in0;
        else if(sel == 3'b011)
            out = in1;
        else if(sel == 3'b010)
            out = in2;
        else if(sel == 3'b001)
            out = in3;
        else if(sel == 3'b101)
            out = in4;
            /*
        else if(sel == 3'b110)
            out = in5;*/
        else if(sel == 3'b111)
            out = in6;
        else
            out = 32'h0;
    end

endmodule
