module data_mux(
    //data mem
    input cs_dmem_n,
    input [31:0] read_data_dmem,

    //tbman
    input cs_tbman_n,
    input [31:0] read_data_tbman,

    //timer
    input cs_timer_n,
    input [31:0] read_data_timer,

    output reg [31:0] read_data
);

always @(*) begin
    if(!cs_dmem_n)
        read_data = read_data_dmem;
    else if(!cs_tbman_n)
        read_data = read_data_tbman;
  //  else if(!cs_timer_n)
 //       read_data = read_data_timer;
    else
        read_data = 32'd0;
end

endmodule