module be_logic_store(
    WD,
    Addr_Last2,
    funct3,
    BE_WD,
	ByteEnable
);
 input [31:0] WD;
 input [1:0] Addr_Last2;
 input [2:0] funct3;

output reg [31:0] BE_WD;
output reg [3:0] ByteEnable; 


	always@(*)
	begin
		if(funct3 == 3'b000)begin //sb
			if(Addr_Last2 == 2'b00)begin
				BE_WD = {24'h0,WD[7:0]};
				ByteEnable = 4'b0001;
			end
			else if(Addr_Last2 == 2'b01)begin
                BE_WD = {16'h0,WD[7:0],8'h0};
				ByteEnable = 4'b0010;	
			end
			else if(Addr_Last2 == 2'b10)begin
                BE_WD = {8'h0,WD[7:0],16'h0};
				ByteEnable = 4'b0100;
			end
			else if(Addr_Last2 == 2'b11)begin
                BE_WD = {WD[7:0],24'h0};
				ByteEnable =4'b1000;
			end
			else begin
				BE_WD = 32'b0;
				ByteEnable = 4'b0000;
			end
		 end
 	   else if(funct3 == 3'b001)begin //sh
		   if(Addr_Last2 == 2'b00)begin
                BE_WD = {16'h0,WD[15:0]};
				ByteEnable = 4'b0011;
		   end
		   else if(Addr_Last2 == 2'b10)begin
                BE_WD = {WD[15:0],16'h0};
			    ByteEnable = 4'b1100;
		   end
		   else begin
			    BE_WD = 32'b0;
				ByteEnable = 4'b0000;
		   end
	   end
	  else if(funct3 == 3'b010)begin //sw
				BE_WD = WD;
				ByteEnable = 4'b1111;
	  end
	  else begin
		BE_WD = 32'b0;
		ByteEnable = 4'b0000;
	  end
	end

endmodule