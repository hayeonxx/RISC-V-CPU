module Hazard_Unit(
    //Data Forwarding
    input [4:0] Ra1E,
    input [4:0] Ra2E,
    input [4:0] RdM,
    input [4:0] RdW,
    input RegWriteM,
    input RegWriteW,
    
    //Stalling
    input [4:0] Ra1D,
    input [4:0] Ra2D,
    input [4:0] RdE,
    input ResultSrcE,
    input [1:0] PCSrcE,

    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output reg [1:0] ForwardAD,
    output reg [1:0] ForwardBD,
    output reg StallF,
    output reg StallD,
    output reg Stall,
    output reg FlushE,
    output reg FlushD
);

always@(*) begin
    if (((Ra1D == RdM) && RegWriteM) && (Ra1D != 0)) begin
        ForwardAD = 2'b10;
    end
    else if (((Ra1D == RdW) && RegWriteW) && (Ra1D != 0))begin
        ForwardAD = 2'b01;
    end
    else begin
        ForwardAD = 2'b00;
    end
end

always@(*) begin
    if (((Ra2D == RdM) && RegWriteM) && (Ra2D != 0)) begin
        ForwardBD = 2'b10;
    end
    else if (((Ra2D == RdW) && RegWriteW) && (Ra2D != 0))begin
        ForwardBD = 2'b01;
    end
    else begin
        ForwardBD = 2'b00;
    end
end

always@(*) begin
    if (((Ra1E == RdM) && RegWriteM) && (Ra1E != 0)) begin
        ForwardAE = 2'b10;
    end
    else if (((Ra1E == RdW) && RegWriteW) && (Ra1E != 0))begin
        ForwardAE = 2'b01;
    end
    else begin
        ForwardAE = 2'b00;
    end
end

always@(*) begin
    if (((Ra2E == RdM) && RegWriteM) && (Ra2E != 0)) begin
        ForwardBE = 2'b10;
    end
    else if (((Ra2E == RdW) && RegWriteW) && (Ra2E != 0))begin
        ForwardBE = 2'b01;
    end
    else begin
        ForwardBE = 2'b00;
    end
end

//Stalling
wire lwStall;

assign lwStall = (((Ra1D == RdE) || (Ra2D == RdE)) && ResultSrcE);

assign StallF = lwStall;
assign StallD = lwStall;
assign Stall = lwStall;

assign FlushE = lwStall || (PCSrcE != 2'b00) ; 
assign FlushD = (PCSrcE != 2'b00);
endmodule


