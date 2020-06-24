// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
// EC413 Lab 2 Problem 1: Register File Test Bench


module regFile_tb();

reg clock, reset, wEn;
reg [0:4] write_sel,read_sel1, read_sel2;
reg[0:31] write_data;
wire [0:31] read_data1, read_data2;
/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

// Fill in port connections
regFile uut (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(write_data),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);


always #5 clock = ~clock;

initial begin
  clock <= 1'b1;
  reset <= 1'b1;
  #20;
  reset <= 1'b0;
  wEn<=1'b1;
  write_sel <= 5'b00001;
  write_data <= 32'b00000000000000000000000000000001;
  read_sel1 <= 5'b00010;
  read_sel2 <= 5'b00011; 
  #20 
  reset <= 1'b0;
  wEn<=1'b1;
  write_sel <= 5'b00010;
  write_data <= 32'b00000000000000000000000000000011;
  read_sel1 <= 5'b00001;
  read_sel2 <= 5'b00011; 
  #20 
  reset <= 1'b0;
  wEn<=1'b1;
  write_sel <= 5'b00100;
  write_data <= 32'b00000000000000000000000000000111;
  read_sel1 <= 5'b00100;
  read_sel2 <= 5'b00010; 
 end


  // Test reads and writes to the register file here

endmodule
