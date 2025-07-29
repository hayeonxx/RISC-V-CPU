`timescale 1ns/1ns

module data_mux (
`ifdef FPGA
    input clk,
 
`endif
    input [31:0]  read_data_mem,

    //Timer
    input cs_timer_n,
    input [31:0] read_data_timer,
        
    //TBMAN
    input cs_tbman_n,
    input [31:0] read_data_tbman,
    
    //GPIO
    input cs_gpio_n,
    input [31:0] read_data_gpio,

    //UART
    input cs_uart_n,
    input [31:0] read_data_uart,

    output reg [31:0] read_data 
);

 `ifdef FPGA 
    

    reg cs_timer_n_1d;
    reg [31:0] read_data_timer_1d;

    reg cs_tbman_n_1d;
    reg [31:0] read_data_tbman_1d;

    reg cs_gpio_n_1d;
    reg [31:0] read_data_gpio_1d;

    reg cs_uart_n_1d;
    reg [31:0] read_data_uart_1d;
   
   
  
    //------------------------
    //Timer
    //------------------------

    always @(posedge clk)
    begin 
        cs_timer_n_1d <= cs_timer_n;
    end

    always @(posedge clk)
    begin 
        read_data_timer_1d <= read_data_timer;
    end

    //------------------------
    //TBMAN
    //------------------------

    always @(posedge clk)
    begin 
        cs_tbman_n_1d <= cs_tbman_n;
    end

    always @(posedge clk)
    begin 
        read_data_tbman_1d <= read_data_tbman;
    end

    //------------------------
    //GPIO
    //------------------------

    always @(posedge clk)
    begin 
        cs_gpio_n_1d <= cs_gpio_n;
    end

    always @(posedge clk)
    begin 
        read_data_gpio_1d <= read_data_gpio;
    end

    //------------------------
    //UART
    //------------------------

    always @(posedge clk)
    begin 
        cs_uart_n_1d <= cs_uart_n;
    end

    always @(posedge clk)
    begin 
        read_data_uart_1d <= read_data_uart;
    end

`endif


`ifdef FPGA
    always @(*)
    begin
        if      (~cs_timer_n_1d) 	read_data = read_data_timer_1d;
        else if (~cs_tbman_n_1d) 	read_data = read_data_tbman_1d;
        else if (~cs_gpio_n_1d) 	read_data = read_data_gpio_1d;
        else if (~cs_uart_n_1d) 	read_data = read_data_uart_1d;
       else            				read_data = read_data_mem;
     end

`else // ASYNC MEM

  always @(*)
    begin
        if          (~cs_timer_n) 	read_data = read_data_timer;
        else if     (~cs_tbman_n) 	read_data = read_data_tbman;
        else if     (~cs_gpio_n) 	read_data = read_data_gpio;
        else if     (~cs_uart_n) 	read_data = read_data_uart;
       else            	            read_data = read_data_mem;
     end
`endif
 
endmodule


/*`timescale 1ns/1ps

module data_mux (
    // DATA MEM
    input           cs_dmem_n,
    input    [31:0]	read_data_dmem,

    // TBMAN
    input           cs_tbman_n,
    input    [31:0] read_data_tbman,

    // GPIO
    input           cs_gpio_n,
    input    [31:0] read_data_gpio,

    // TIMER
    input           cs_timer_n,
    input    [31:0] read_data_timer,

    // UART
    input           cs_uart_n,
    input    [31:0] read_data_uart,

    output reg [31:0] read_data 
);

    always @(*)
    begin
        if      (~cs_tbman_n) read_data = read_data_tbman;
        else if (~cs_dmem_n)  read_data = read_data_dmem;
        else if (~cs_gpio_n)  read_data = read_data_gpio;
        else if (~cs_timer_n) read_data = read_data_timer;
        else if (~cs_uart_n)  read_data = read_data_uart;
        else            	  read_data = 32'd0;
    end

endmodule 
*/
