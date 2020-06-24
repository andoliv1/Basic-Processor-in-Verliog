// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
// EC413 Lab 2 Problem 2: ALU Test Bench

module ALU_tb();

reg [5:0] ctrl;
reg [31:0] opA, opB;
reg branch_op;
wire branch;
wire signed [31:0] result;

ALU dut (
  .ALU_Control(ctrl),
  .operand_A(opA),
  .operand_B(opB),
  .branch_op(branch_op),
  .branch(branch),
  .ALU_result(result)
);

initial begin
  ctrl = 6'b000000;
  opA = 4;
  opB = 5;

  #15
  $display("ALU Result 4 + 5: %d",result);
   #15
  ctrl = 6'b001000;
 #15
  $display("ALU Result 4 - 5: %d",result);
 #15
  ctrl = 6'b000010;
 #15
  $display("ALU Result 4 < 5: %d",result);
   #15
  opB = 32'hffffffff;
  #15
  $display("ALU Result 4 < -1: %d",result);
 #15
  opA = 32'hfffffff0;
   #15
  $display("ALU Result  -16 < -1: %d",result);
 #15
  opB=6'b110101;
  opA=6'b100110;
  ctrl=6'b000100;
   #15
  $display("ALU Result  110101 XOR 100110: %d",result);
   #15
  ctrl=6'b000111;
 #15
  $display("ALU Result  110101 AND 100110: %d",result);
   #15
   opA = 32'hfffffffe;
   ctrl = 6'b000010;
   #15
   $display("ALU Result -2 < -1: %d",result);
     #15
   // Add other test cases here
   opA = 4;
   opB = 32'hffffffff;
   //opB = 5;
   ctrl = 6'b001000;
  #15
   $display("ALU Result 4 - (-1): %d",result);
   #15
   ctrl = 6'b000100;
 #15
   $display("ALU Result 4 ^ -1: %d",result);
  #15
   ctrl = 6'b000111;
 #15
   $display("ALU Result 4 & -1: %d",result);
 #15
   ctrl = 6'b011111;
   branch_op = 1'b1;
   opB = 3;
   #15
   $display("ALU Result (should be 4) jal: %d", result);
   $display("Branch Result (should be 1) jal: %b", branch);
    #15
   ctrl = 6'b000000;
 #15
   $display("ALU Result (should be 7) jalr: %d", result);
   $display("Branch Result (should be 1) jalr: %b", branch);
 #15
   ctrl = 6'b010000;
 #15
   $display("ALU Result (should be 0) beq: %d", result);
   $display("Branch Result (should be 1) beq: %b", branch);
  #15
   ctrl = 6'b010001;
    #15
   $display("ALU Result (should be 1) bne: %d", result);
   $display("Branch Result (should be 1) bne: %b", branch);
  #15
   ctrl = 6'b010100;
  #15
   $display("ALU Result (should be 0) blt: %d", result);
   $display("Branch Result (should be 1) blt: %b", branch);
  #15
   ctrl = 6'b010101;
   #15
   $display("ALU Result (should be 1) bge: %d", result);
   $display("Branch Result (should be 1) bge: %b", branch);
 #15
   ctrl = 6'b010110;
  #15
   $display("ALU Result (should be 0) bltu: %d", result);
   $display("Branch Result (should be 1) bltu: %b", branch);
 #15
   ctrl = 6'b010111;
 #15
   $display("ALU Result (should be 1) bgeu: %d", result);
   $display("Branch Result (should be 1) bgeu: %b", branch);
 #15
   ctrl=6'b000110;
   opB = -1;
 #15
   $display("ALU Result 4 | -1: %d",result);
  #15
   ctrl=6'b000101;
   opA=24;
   opB = 3;
 #15
   $display("ALU Result 24 and 3 shift right : %d",result);
   #15
   ctrl=6'b000001;
   opB=1;
 #15
   $display("ALU Result 24 and 1 shift left : %d",result);
 #15
   ctrl=6'b001101;
   //opB = 32'hffffffff;
 #15
   $display("ALU Result 24 and 1 arithmetic right : %d",result);
 #15
   //opA = 32'b1111111111111111111111100000000;
   opA=-128;
   opB = 1;
   ctrl=6'b001101;
  #15
   $display("ALU Result -256 and 2 arithmetic right : %d",result);// the sign isn't being preserved ask 
  #15
   ctrl=6'b000101;
 #15
   $display("ALU Result -256 and 2 shift right : %d",result);
  opA = -4;
  opB = -3;
  ctrl = 6'b011111;
  branch_op = 1'b1;
 #15
 $display("ALU Result (should be -4) jal: %d", result);
 $display("Branch Result (should be 0) jal: %b", branch);
 #15
 ctrl = 6'b000000;
  #15
 $display("ALU Result (should be -7) jalr: %d", result);
 $display("Branch Result (should be 1) jalr: %b", branch);
 #15
 ctrl = 6'b010000;
 #15
 $display("ALU Result (should be 0) beq: %d", result);
 $display("Branch Result (should be 0) beq: %b", branch);
  #15
 ctrl = 6'b010001;
  #15
 $display("ALU Result (should be 1) bne: %d", result);
 $display("Branch Result (should be 1) bne: %b", branch);
 #15
 ctrl = 6'b010100;
 #15
 $display("ALU Result (should be 1) blt: %d", result);
 $display("Branch Result (should be 1) blt: %b", branch);
 #15
 ctrl = 6'b010101;
  #15
 $display("ALU Result (should be 0) bge: %d", result);
 $display("Branch Result (should be 0) bge: %b", branch);
 #15
 ctrl = 6'b010110;
  #15
 $display("ALU Result (should be 1) bltu: %d", result);
 $display("Branch Result (should be 1) bltu: %b", branch);
  #15
 ctrl = 6'b010111;
 #15
 $display("ALU Result (should be 0) bgeu: %d", result);
 $display("Branch Result (should be 0) bgeu: %b", branch);
end

endmodule
