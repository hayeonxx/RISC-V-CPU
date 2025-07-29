// dualport_mem_synch_rw_dualclk_stub.v
/*module dualport_mem_synch_rw_dualclk (
    input  [11:0] addr1,
    input  [11:0] addr2,
    input  [3:0]  be1,
    input  [3:0]  be2,
    input  [31:0] data_in1,
    input  [31:0] data_in2,
    input         we1,
    input         we2,
    input         clk1,
    input         clk2,
    output [31:0] data_out1,
    output [31:0] data_out2
);
 // black-box: no internals
endmodule
*/


// Quartus Prime SystemVerilog Template
//
// True Dual-Port RAM with different read/write addresses and single read/write clock
// and with a control for writing single bytes into the memory word; byte enable

// Read during write produces old data on ports A and B and old data on mixed ports
// For device families that do not support this mode (e.g. Stratix V) the mem is not inferred

module dualport_mem_synch_rw_dualclk
	#(
		parameter
		BYTE_WIDTH = 8,
		ADDRESS_WIDTH = 12,
		BYTES = 4,
		DATA_WIDTH = BYTE_WIDTH * BYTES,
  		MIF_HEX = "",
  		MIF_BIN = ""
)
(
	input [ADDRESS_WIDTH-1:0] addr1,
	input [ADDRESS_WIDTH-1:0] addr2,
	input [BYTES-1:0] be1,
	input [BYTES-1:0] be2,
	input [DATA_WIDTH-1:0] data_in1, 
	input [DATA_WIDTH-1:0] data_in2, 
	input we1, we2, clk1, clk2,
	output [DATA_WIDTH-1:0] data_out1,
	output [DATA_WIDTH-1:0] data_out2

);

/*	localparam DEPTH = 1 << ADDRESS_WIDTH;

	// model the RAM with two dimensional packed array
	//reg [BYTES-1:0][BYTE_WIDTH-1:0] mem[DEPTH-1:0];
 	//합성때문에 추가
	reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
	reg [DATA_WIDTH-1:0] data_reg1;
	reg [DATA_WIDTH-1:0] data_reg2;


  integer i;

  initial begin
    if (MIF_HEX != "") begin
      $display("MIF_HEX_PASS");
      $readmemh(MIF_HEX, mem);
    end
    else if (MIF_BIN != "") begin
      $readmemb(MIF_BIN, mem);
    end
    else begin
      $display("MIF_HEX_FAIL");
      for (i = 0; i < DEPTH; i = i + 1) begin
        mem[i] = 0;
      end
    end
  end


  //initial
  //begin : INIT
  //  $readmemh("bios.hex", mem);
  //end

	// port A
always@(posedge clk1)
	begin
		/*if(we1) begin
		// edit this code if using other than four bytes per word
			if(be1[0]) mem[addr1][0] <= data_in1[7:0];
			if(be1[1]) mem[addr1][1] <= data_in1[15:8];
			if(be1[2]) mem[addr1][2] <= data_in1[23:16];
			if(be1[3]) mem[addr1][3] <= data_in1[31:24];
		end*/
/*		if (we1) begin
    	 	if (be1[0]) mem[addr1][ 0*BYTE_WIDTH +: BYTE_WIDTH] <= data_in1[ 0*BYTE_WIDTH +: BYTE_WIDTH];
     	 	if (be1[1]) mem[addr1][ 1*BYTE_WIDTH +: BYTE_WIDTH] <= data_in1[ 1*BYTE_WIDTH +: BYTE_WIDTH];
     	 	if (be1[2]) mem[addr1][ 2*BYTE_WIDTH +: BYTE_WIDTH] <= data_in1[ 2*BYTE_WIDTH +: BYTE_WIDTH];
     	 	if (be1[3]) mem[addr1][ 3*BYTE_WIDTH +: BYTE_WIDTH] <= data_in1[ 3*BYTE_WIDTH +: BYTE_WIDTH];
    	end
	end


   
	// port B
	always@(posedge clk2)
	begin
		/*if(we2) begin
		// edit this code if using other than four bytes per word
			if(be2[0]) mem[addr2][0] <= data_in2[7:0];
			if(be2[1]) mem[addr2][1] <= data_in2[15:8];
			if(be2[2]) mem[addr2][2] <= data_in2[23:16];
			if(be2[3]) mem[addr2][3] <= data_in2[31:24];
		end*/
/*	if (we2) begin
    	 	if (be2[0]) mem[addr1][ 0*BYTE_WIDTH +: BYTE_WIDTH] <= data_in1[ 0*BYTE_WIDTH +: BYTE_WIDTH];
     	 	if (be2[1]) mem[addr1][ 1*BYTE_WIDTH +: BYTE_WIDTH] <= data_in1[ 1*BYTE_WIDTH +: BYTE_WIDTH];
     	 	if (be2[2]) mem[addr1][ 2*BYTE_WIDTH +: BYTE_WIDTH] <= data_in1[ 2*BYTE_WIDTH +: BYTE_WIDTH];
     	 	if (be2[3]) mem[addr1][ 3*BYTE_WIDTH +: BYTE_WIDTH] <= data_in1[ 3*BYTE_WIDTH +: BYTE_WIDTH];
    	end
	end


	// assign data_reg1 = mem[addr1];
	// assign data_reg2 = mem[addr2];

  always @(posedge clk1)
  begin
     	data_reg1 <= mem[addr1];
  end

  always @(posedge clk2)
  begin
    data_reg2 <= mem[addr2];
  end

	assign data_out1 = data_reg1;
	assign data_out2 = data_reg2;
*/
endmodule
