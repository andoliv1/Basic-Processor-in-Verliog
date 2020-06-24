// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
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
wire signed [31:0] a_sign, b_sign,out ,SLT, shifted;
reg signed [31:0] outp;
assign a_sign=operand_A;
assign b_sign=operand_B;
assign shifted=a_sign>>b_sign;
assign SLT=a_sign<b_sign;

assign out= (ALU_Control== 6'b000000)? a_sign+ b_sign: //ADD, ADDI
            (ALU_Control== 6'b001000)? a_sign - b_sign://SUB
            (ALU_Control== 6'b000100)? operand_A ^ operand_B://XOR
            (ALU_Control== 6'b000111)? operand_A & operand_B://AND ANDI
            (ALU_Control== 6'b000010)? SLT://SLT, SLTI
            (ALU_Control== 6'b011111)? a_sign: //JAL
            (ALU_Control== 6'b111111)? a_sign: //JALR
            (ALU_Control== 6'b010000)? (a_sign == b_sign): //BEQ
            (ALU_Control== 6'b010001)? (a_sign != b_sign): //BNE
            (ALU_Control== 6'b010100)? SLT: // BLT
            (ALU_Control== 6'b010101)? (a_sign >= b_sign): //BGE
            (ALU_Control== 6'b010110)? (operand_A < operand_B): //BLTU
            (ALU_Control== 6'b010111)? (operand_A >= operand_B): //BGEU
            (ALU_Control== 6'b000011)? (operand_A<operand_B): //SLTIU, SLTU
	        (ALU_Control== 6'b001101)? (({a_sign[31],shifted[30:0]}))://SRA, SRAI                                                                                                                     
            (ALU_Control== 6'b000101)? (operand_A>>operand_B)://SRL, SRLI                                                                                                                   
            (ALU_Control== 6'b000001)? (operand_A<<operand_B)://SLL, SLLI                                                                                                                   
            (ALU_Control== 6'b000110)? operand_A | operand_B://ORI                         	
            32'b00000000000000000000000000000000;
            

assign ALU_result=out;
assign branch = (branch_op == 1'b1)? ALU_result: 1'b0;
/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

endmodule
