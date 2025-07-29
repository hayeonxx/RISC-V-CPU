module regfile(
    clk,
    rs1,
    rs2,
    write_enable,
    rd,
    rd_data,
    rs1_data,
    rs2_data
);
    input clk, write_enable;
    input [4:0] rs1, rs2, rd;
    input [31:0] rd_data;
    output [31:0] rs1_data, rs2_data;
    
    reg [31:0] x[31:0];

    //write
    always@(posedge clk) begin
        if (write_enable) begin
            x[rd] <= rd_data;
        end
    end

    //read
    assign rs1_data = (rs1 == 5'h0) ? 32'h0 : x[rs1];
    assign rs2_data = (rs2 == 5'h0) ? 32'h0 : x[rs2];

endmodule
