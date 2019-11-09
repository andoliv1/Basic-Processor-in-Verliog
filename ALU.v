// Name: Layan
// BU ID: U26666743
// EC413 Lab 2 Problem 2: ALU

module ALU (
  input [5:0]  ALU_Control,
  input [31:0] operand_A,
  input [31:0] operand_B,
  input branch_op,
  output branch,
  output [31:0] ALU_result
);
//reg [31:0] out temp;
wire signed [31:0] a_sign, b_sign, out,SLT;
assign a_sign=operand_A;
assign b_sign=operand_B;
assign SLT=a_sign<b_sign;
assign out= (ALU_Control== 6'b000000)? a_sign+ b_sign:
            (ALU_Control== 6'b001000)?a_sign - b_sign:
            (ALU_Control== 6'b000100)? operand_A ^ operand_B:
            (ALU_Control== 6'b000111)? operand_A & operand_B:
            (ALU_Control== 6'b000010)? SLT:
            (ALU_Control== 6'b000000? 
            32'b00000000000000000000000000000000;     
assign ALU_result=out;
/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

endmodule
