module flush(
    input[2:0]PCSrc,
    input stall,
    //output FlushF,
    output FlushD,
    output FlushE
);

//assign FlushF = (PCSrc == 3'b001)? 1'b1 : 1'b0;
assign FlushD = (PCSrc == 3'b011 || PCSrc ==3'b010 /*|| PCSrc ==3'b001*/  || PCSrc ==3'b101  )? 1'b1 : 1'b0;
assign FlushE = ((PCSrc == 3'b011 || PCSrc ==3'b010 || PCSrc == 3'b001 || PCSrc ==3'b101 ) || (stall ==1'b1))? 1'b1 : 1'b0;


endmodule
