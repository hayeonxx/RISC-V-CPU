module hazard_unit(
    input [4:0] rs1,
    input [4:0] rs2,
    input [4:0] rdm,
    input [4:0] rdw,
    input RegWriteM,
    input RegWriteW,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE
);

always@(*)
begin
    if(((rs1 == rdm) && (RegWriteM)) &&(rs1 != 0))
    begin
        ForwardAE = 2'b10;
    end
    else if(((rs1 == rdw) && (RegWriteW)) &&(rs1 != 0))
    begin
        ForwardAE = 2'b01;
    end
    else
    begin
        ForwardAE = 2'b00;
    end
end

always@(*)
begin
    if(((rs2 == rdm) && (RegWriteM)) &&(rs2 != 0))
    begin
        ForwardBE = 2'b10;
    end
    else if(((rs2 == rdw) && (RegWriteW)) &&(rs2 != 0))
    begin
        ForwardBE = 2'b01;
    end
    else
    begin
        ForwardBE = 2'b00;
    end
end

endmodule