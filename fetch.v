// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
// EC413 Project: Fetch Module

module fetch #(
  parameter ADDRESS_BITS = 16
) (
  input  clock,
  input  reset,
  input  next_PC_select,
  input  [ADDRESS_BITS-1:0] target_PC,
  output [ADDRESS_BITS-1:0] PC
);

reg [ADDRESS_BITS-1:0] PC_reg;

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/
assign PC = PC_reg;
always @(posedge clock or posedge reset)
begin
	if(reset == 1'b1)
		PC_reg<= 0;
	else if(next_PC_select == 1'b1) 
		PC_reg <= target_PC;
	else 
		PC_reg <= PC_reg + 4;
end

endmodule
