module sync_block (
		input [31:0]instr_temp,
		input [31:0]instr_temp_1d,
		input [31:0]PC,
		input FlushD_1d,
		input stall_1d,
		
		output reg[31:0]InstrD
);


always@(*)
begin
	if(FlushD_1d || PC == 32'h1000_0000)
	begin
		InstrD <= 32'h0000_0033;
	end
	else if(stall_1d)
	begin
		InstrD <= instr_temp_1d;
	end
	else
	begin 
		InstrD <= instr_temp;
	end

end

endmodule
