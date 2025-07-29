module back_prediction(
    input [31:0]PC_targetD,
    input Branch,
    input [31:0]PCD,
    output reg prediction
);

always@(*)
begin
    if(Branch ==1'b1 && PC_targetD < PCD)
        prediction = 1'b1;
    else
        prediction = 1'b0; 
end


endmodule