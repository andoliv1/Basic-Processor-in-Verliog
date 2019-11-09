// Name: Layan Bahaidarah
// BU ID: U26666743
// EC413 Lab 2 Problem 3: Top Level Module

module top (
  input clock,
  input reset,

  input [31:0] instruction,
  input [5:0] ALU_Control,
  input op_B_sel,
  input wEn,

  output [31:0] ALU_result
);


wire [4:0] read_sel1;
wire [4:0] read_sel2;
wire [4:0] write_sel;

wire [31:0] imm;

assign read_sel1 = instruction[19:15];
assign read_sel2 = instruction[24:20];
assign write_sel = instruction[11:7];

// Sign extension
assign imm = { {20{instruction[31]}}, instruction[31:20]};

/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

// add any wire or reg variables you need here
wire[31:0] read_data1, read_data2, opB, ALU_res;

// Fill in port connections
regFile regFile_inst (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(ALU_res),// output of ALU
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);


assign opB= (op_B_sel==1'b1)? imm:read_data2;



// Fill in port connections
ALU alu_inst(
  .ALU_Control(ALU_Control),
  .operand_A(read_data1),
  .operand_B(opB),
  .ALU_result(ALU_result)
);
assign ALU_res=ALU_result;


endmodule
