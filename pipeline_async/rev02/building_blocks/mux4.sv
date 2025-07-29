module mux_inst(
	in0,//instr
	in1,//inst_tmp_1d
    in2,//flush_1d
    in3,//stall_1d
    PC,
	out//InstrD
);
	input [31:0] in0,in1,PC; 
	input  in2,in3;
	output reg [31:0] out;



    always @(*)
        if(in2||PC==32'h1000_0000) begin
            out <= 32'h0000_0033;
        end
        else if(in3) begin
            out<= in1;
        end
        else begin
            out<= in0;
        end      

    

endmodule
