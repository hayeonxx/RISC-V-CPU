module D_E_DFF #(
    parameter WIDTH = 32,
    parameter RESET_VALUE = 0
)
(
    clk,
    n_rst,
    en,
    Flush,
    din,
    dout
);
    input clk;
    input n_rst;
    input en;
    input Flush;
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
        if(Flush)begin
            dout <= RESET_VALUE;
        end
        else if  (en) begin
            dout <= din;
        end
        
    end
end

endmodule