// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
// EC413 Project: Ram Test Bench

module ram_tb();

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 16;

reg  clock;

// Instruction Port
reg  [ADDR_WIDTH-1:0] i_address;
wire [DATA_WIDTH-1:0] i_read_data;

// Data Port
reg  wEn;
reg  [ADDR_WIDTH-1:0] d_address;
reg  [DATA_WIDTH-1:0] d_write_data;
wire [DATA_WIDTH-1:0] d_read_data;


ram #(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH)
) uut (
  .clock(clock),

  // Instruction Port
  .i_address(i_address),
  .i_read_data(i_read_data),

  // Data Port
  .wEn(wEn),
  .d_address(d_address),
  .d_write_data(d_write_data),
  .d_read_data(d_read_data)

);

always #5 clock = ~clock;


initial begin
  clock = 1'b1;
  d_address = 16'd0;
  d_write_data = 16'd0;
  wEn = 1'b0;

  #10
  wEn = 1'b0;
  d_write_data = 1;
  d_address = 0;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  #10
  wEn = 1'b1;
  d_write_data = 8;
  d_address = 16;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);
  d_write_data = 2;
  d_address = 12;
  #10
  $display("Data Address %d: %h", d_address, d_read_data);


  /***************************
  * Add more test cases here *
  ***************************/
   #10
   wEn = 1'b0;
   i_address = 4;
   #10
   $display("Data Address %d: %h", i_address, i_read_data);
   #10
   i_address = 16; 
   #10
   $display("Data Address %d: %h", i_address, i_read_data);
   #10
   wEn = 1'b1;
   d_address = 20;
   d_write_data = 32;
   #10
   $display("Data Address %d: %h", d_address, d_read_data);
   wEn = 1'b0;
   d_address = 24;
   d_write_data = 31;
   #10
   $display("Data Address %d: %h", d_address, d_read_data);
   wEn = 1'b1;
   d_address = 24;
   d_write_data = 31;
   #10
   $display("Data Address %d: %h", d_address, d_read_data);
   wEn = 1'b1;
   d_address = 28;
   d_write_data = 11;
   #10
   $display("Data Address %d: %h", d_address, d_read_data);
   wEn = 1'b1;
   d_address = 32;
   d_write_data = 1;
   #10
   $display("Data Address %d: %h", d_address, d_read_data);
   wEn = 1'b0;
   d_address = 32;
   d_write_data = 5;
   #10
   $display("Data Address %d: %h", d_address, d_read_data);
   $stop();

end

endmodule
