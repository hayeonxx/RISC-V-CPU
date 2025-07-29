module stall(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rde,
    input [1:0] ResultSrc,
    output reg  stall
);

always@(*)
begin
    if(((rs1 == rde) || (rs2 == rde)) && (ResultSrc[0]))
    begin
        stall = 1'b1;
    end
    else
    begin
        stall = 1'b0;
    end
end

endmodule
