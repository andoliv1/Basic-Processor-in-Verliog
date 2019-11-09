// Name: Layan
// BU ID: U26666743
// EC413 Lab 2 Problem 2: ALU

module ALU (
  input [5:0]  ALU_Control,
  input [31:0] operand_A,
  input [31:0] operand_B,
  output [31:0] ALU_result
);
//reg [31:0] out temp;
wire signed [31:0] a_sign, b_sign, out,SLT;
assign a_sign=operand_A;
assign b_sign=operand_B;
assign SLT=a_sign<b_sign;
//always@(*) begin
//case(ALU_Control)
//    6'b000000:out = operand_A + operand_B;
//    6'b001000:out = a_sign - b_sign;
//    6'b000100:out = operand_A ^ operand_B;
//    6'b000111:out = operand_A & operand_B;
//    6'b000010:if(operand_A[31]==1'b1 && operand_B[31]==1'b0) out=32'b00000000000000000000000000000001;
//            else if(operand_A[31]==1'b0&&operand_B[31]==1'b1) out=32'b00000000000000000000000000000000;
//            else if(operand_A[31]==1'b0 && operand_B [31]==1'b1)begin
//                temp=operand_A-operand_B;
//                    if(temp>=2'b00)
//                        out=32'b00000000000000000000000000000000;
//                    else 
//                        out=32'b00000000000000000000000000000001;
//                 end
//            else begin
//                temp=operand_A-operand_B;
//                   if(temp>2'b00)
//                      out=32'b00000000000000000000000000000001;
//                   else 
//                      out=32'b00000000000000000000000000000000;
//                 end
//    default:out = operand_A + operand_B;
//   endcase
//end

assign out= (ALU_Control== 6'b000000)? a_sign+ b_sign:
            (ALU_Control== 6'b001000)?a_sign - b_sign:
            (ALU_Control== 6'b000100)? operand_A ^ operand_B:
            (ALU_Control== 6'b000111)? operand_A & operand_B:
            (ALU_Control== 6'b000010)? SLT:
            32'b00000000000000000000000000000000;
        
assign ALU_result=out;
/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

endmodule
