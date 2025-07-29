module be_logic(
    clk,
    n_rst,
    funct3M,
    funct3W,
    Addr_last2M,
    Addr_last2W,
    WD,
    RD,
    BE_RD,
    BE_WD,
    byte_enable
);
    input clk, n_rst;
    input [2:0] funct3M;
    input [2:0] funct3W;
    input [1:0] Addr_last2M;
    input [1:0] Addr_last2W;
    input [31:0] WD;
    input [31:0] RD;
    output reg [31:0] BE_RD;
    output reg [31:0] BE_WD;
    output reg [3:0] byte_enable;
   /* reg [31:0] RD_reg;
    always @(posedge clk) begin
        RD_reg <= RD;
    end
    
    flopr u_flopr_readdata(
        .clk(clk),
        .n_rst(n_rst),
        .d(ReadData),
        .q(delay_ReadData)
    );*/

//00:[7:0],01:[15:8],10:[23:16],11:[31:24]
    always@(*) begin
        if(funct3W == 3'b000) begin      //LB 
            if(Addr_last2W == 2'b00)
                BE_RD = {{24{RD[7]}}, RD[7:0]};
            else if(Addr_last2W == 2'b01)
                BE_RD = {{24{RD[15]}}, RD[15:8]};
            else if(Addr_last2W == 2'b10)
                BE_RD = {{24{RD[23]}}, RD[23:16]};
            else
                BE_RD = {{24{RD[31]}}, RD[31:24]};
        end
        else if(funct3W == 3'b001) begin  //LH
            if(Addr_last2W == 2'b00)
                BE_RD = {{16{RD[15]}}, RD[15:0]};
            else if(Addr_last2W == 2'b10)
                BE_RD = {{16{RD[31]}}, RD[31:16]};
        end
        else if(funct3W == 3'b010) begin //LW
            BE_RD = {RD[31:0]};
        end
        else if(funct3W == 3'b100) begin //LBU
            if(Addr_last2W == 2'b00)
                BE_RD = {24'b0, RD[7:0]};
            else if(Addr_last2W == 2'b01)
                BE_RD = {24'b0, RD[15:8]};
            else if(Addr_last2W == 2'b10)
                BE_RD = {24'b0, RD[23:16]};
            else
                BE_RD = {24'b0, RD[31:24]};
        end
        else if(funct3W == 3'b101) begin //LHU
            if(Addr_last2W == 2'b00)
                BE_RD = {16'b0, RD[15:0]};
            else if(Addr_last2W == 2'b10)
                BE_RD = {16'b0, RD[31:16]};
        end
    end

    always@(*) begin
        if(funct3M == 3'b000) begin      //SB 
            if(Addr_last2M == 2'b00)
                BE_WD = {{24{WD[7]}}, WD[7:0]};
            else if(Addr_last2M == 2'b01)
                BE_WD = {{16{WD[7]}}, WD[7:0], 8'h0};
            else if(Addr_last2M == 2'b10)
                BE_WD = {{8{WD[7]}}, WD[7:0], 16'h0};
            else //if(Addr_last2 == 2'b11)
                BE_WD = {WD[7:0], 24'h0};
        end
        else if(funct3M == 3'b001) begin  //SH
            if(Addr_last2M == 2'b00)
                BE_WD = {{16{WD[15]}}, WD[15:0]};
            else if(Addr_last2M == 2'b10)
                BE_WD = {WD[15:0],{16{WD[15]}}};
        end
        else if(funct3M == 3'b010) begin //SW
            BE_WD = {WD[31:0]};
        end
    end

    always@(*) begin
        if(funct3M == 3'b000 || funct3M == 3'b100)begin //byte
            if(Addr_last2M == 2'b00)
                byte_enable = 4'b0001;
            else if(Addr_last2M == 2'b01)
                byte_enable = 4'b0010;
            else if(Addr_last2M == 2'b10)
                byte_enable = 4'b0100;
            else if(Addr_last2M == 2'b11)
                byte_enable = 4'b1000;
        end
        else if(funct3M == 3'b001 || funct3M == 3'b101)begin //half_word
            if(Addr_last2M == 2'b00)
                byte_enable = 4'b0011;
            else if(Addr_last2M == 2'b10)
                byte_enable = 4'b1100;
        end
        else if(funct3M == 3'b010)  //word
            byte_enable = 4'b1111;
    end


endmodule