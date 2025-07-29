module Csr_Logic(
	input clk,
	input [6:0]opcode,
	input [2:0]funct3,
	input Csr,
	input [31:0] RD1_path,
	input [31:0] ImmExt_path,
	output reg [31:0] tohost_csr
);

always @(posedge clk)
begin
	if(Csr ==1'b1)
		begin
		case(funct3)
			3'b001: tohost_csr <= RD1_path;
			3'b101: tohost_csr <= ImmExt_path;
			default : tohost_csr <= 32'h0;
		endcase
		end
	else
		tohost_csr <= 32'h0;
end

endmodule
