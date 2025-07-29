module M_W_DFF #(
    parameter WIDTH = 32,
    parameter RESET_VALUE = 0
)
(
    clk,
    n_rst,
    din,
    dout
);
    input clk;
    input n_rst;
    input [WIDTH-1:0]din;
    
    output reg[WIDTH-1:0]dout;

always@(posedge clk or negedge n_rst)
begin
    if(!n_rst) 
    begin
        dout <= RESET_VALUE;
    end
    else 
    begin
        dout <= din;
    end
end

endmodule