// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
// EC413 Project: Ram Module

module ram #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 16
) (
  input  clock,

  // Instruction Port
  input  [ADDR_WIDTH-1:0] i_address,
  output [DATA_WIDTH-1:0] i_read_data,

  // Data Port
  input  wEn,
  input  [ADDR_WIDTH-1:0] d_address,
  input  [DATA_WIDTH-1:0] d_write_data,
  output [DATA_WIDTH-1:0] d_read_data

);

localparam RAM_DEPTH = 1 << ADDR_WIDTH;
reg[DATA_WIDTH-1:0] read_data;
reg [DATA_WIDTH-1:0]instruction;

reg [DATA_WIDTH-1:0] ram [0:RAM_DEPTH-1];

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
always @(posedge clock)
begin
    if(wEn == 1'b1)
        ram[d_address[15:2]] <= d_write_data;
end

assign d_read_data = ram[d_address[15:2]];
assign i_read_data = ram[i_address[15:2]];

endmodule
