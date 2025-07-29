module be_logic_load(
    RD,
    Addr_Last2,
    funct3,
    BE_RD
);
 input [31:0] RD;
 input [1:0] Addr_Last2;
 input [2:0] funct3;

output reg [31:0] BE_RD; 


	 always@(*) 
    begin
            if(funct3 == 3'b000)  //lb
            begin
                if(Addr_Last2 == 2'b00) begin
                    BE_RD = {{24{RD[7]}},RD[7:0]};
                end
                else if(Addr_Last2 == 2'b01) begin
                    BE_RD = {{24{RD[15]}},RD[15:8]};
                end
                else if(Addr_Last2 == 2'b10) begin
                    BE_RD = {{24{RD[23]}},RD[23:16]};
                end
                else if(Addr_Last2 == 2'b11) begin
                    BE_RD = {{24{RD[31]}},RD[31:24]};
                end
                else begin
                    BE_RD = 32'b0;
                end
            end
            else if(funct3 == 3'b001 ) begin //lh
                if(Addr_Last2 == 2'b00) begin
                    BE_RD = {{16{RD[15]}},RD[15:0]};
                end
                else if(Addr_Last2 == 2'b10) begin
                    BE_RD = {{16{RD[31]}},RD[31:16]};
                end
                 else begin
                    BE_RD = 32'b0;
                end
            end
            else if(funct3 == 3'b010) begin //lw
                BE_RD = RD; 
                
            end
            else if(funct3 == 3'b100) begin //lbu
                if(Addr_Last2 == 2'b00) begin
                    BE_RD = {24'h0,RD[7:0]}; 
				end
                else if(Addr_Last2 == 2'b01) begin
                    BE_RD = {24'h0,RD[15:8]}; 
                end
                else if(Addr_Last2 == 2'b10) begin
                    BE_RD = {24'h0,RD[23:16]}; 
                end
                else if(Addr_Last2 == 2'b11) begin
                    BE_RD = {24'h0,RD[31:24]}; 
                end
                 else begin
                    BE_RD = 32'b0;
                end
            end
            else if(funct3 == 3'b101) begin  //lhu
                if(Addr_Last2 == 2'b00) begin
                    BE_RD = {16'h0,RD[15:0]};
                end
                else if(Addr_Last2 == 2'b10) begin
                    BE_RD = {16'h0,RD[31:16]};
                 end
                 else begin
                    BE_RD = 32'b0;
                end

            end

            else begin
                BE_RD = RD;
               end      
    end
    
endmodule