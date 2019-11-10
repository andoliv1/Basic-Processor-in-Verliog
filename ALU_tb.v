// Name: Layan Bahaidarah 
// BU ID: U26666743
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

  #10
  $display("ALU Result 4 + 5: %d",result);
  #10
  ctrl = 6'b001000;
  #10
  $display("ALU Result 4 - 5: %d",result);
  #10
  ctrl = 6'b000010;
  #10
  $display("ALU Result 4 < 5: %d",result);
  #10
  opB = 32'hffffffff;
  #10
  $display("ALU Result 4 < -1: %d",result);
  #10
  opA = 32'hfffffff0;
  #10
  $display("ALU Result  -16 < -1: %d",result);
  #10
  opB=6'b110101;
  opA=6'b100110;
  ctrl=6'b000100;
  #10
  $display("ALU Result  110101 XOR 100110: %d",result);
  #10 
  ctrl=6'b000111;
  #10
  $display("ALU Result  110101 AND 100110: %d",result);
   #10
   opA = 32'hfffffffe;
   ctrl = 6'b000010;
   #10
   $display("ALU Result -2 < -1: %d",result);
 
   // Add other test cases here
   opA = 4;
   opB = 32'hffffffff;
   //opB = 5;
   ctrl = 6'b001000;
   #10
   $display("ALU Result 4 - (-1): %d",result);
   #10
   ctrl = 6'b000100;
   #10
   $display("ALU Result 4 ^ -1: %d",result);
   #10
   ctrl = 6'b000111;
   #10
   $display("ALU Result 4 & -1: %d",result);
   #10
   ctrl = 6'b011111;
   branch_op = 1'b1;
   opB = 3;
   #10
   $display("ALU Result (should be 4) jal: %d", result);
   $display("Branch Result (should be 1) jal: %b", branch);
   #10
   ctrl = 6'b111111;
   #10
   $display("ALU Result (should be 4) jalr: %d", result);
   $display("Branch Result (should be 1) jalr: %b", branch);
   #10
   ctrl = 6'b010000;
   #10
   $display("ALU Result (should be 0) beq: %d", result);
   $display("Branch Result (should be 1) beq: %b", branch);
   #10
   ctrl = 6'b010001;
   #10
   $display("ALU Result (should be 1) bne: %d", result);
   $display("Branch Result (should be 1) bne: %b", branch);
   #10
   ctrl = 6'b010100;
   #10
   $display("ALU Result (should be 0) blt: %d", result);
   $display("Branch Result (should be 1) bgeu: %b", branch);
   #10
   ctrl = 6'b010101;
   #10
   $display("ALU Result (should be 1) bge: %d", result);
   $display("Branch Result (should be 0) bge: %b", branch);
   #10
   ctrl = 6'b010110;
   #10
   $display("ALU Result (should be 0) bltu: %d", result);
   $display("Branch Result (should be 1) bltu: %b", branch);
   #10
   ctrl = 6'b010111;
   #10
   $display("ALU Result (should be 1) bgeu: %d", result);
   $display("Branch Result (should be 1) bgeu: %b", branch);
   ctrl=6'b000110;
   #10
   $display("ALU Result 4 | -1: %d",result);
   #10
   ctrl=6'b000101;
   opA=24;
   opB = 3;
   #10
   $display("ALU Result 24 and 3 shift right : %d",result);
   #10
   ctrl=6'b000001;
   opB=1;
   #10
   $display("ALU Result 24 and 1 shift left : %d",result);
   #10
   ctrl=6'b001101;
   opB = 1;
   #10
   $display("ALU Result 24 and 1 arithmetic right : %d",result);
   #10
   opA = 32'hb0000000;
   opB = 2;
   ctrl=6'b001101;
   #10
   $display("ALU Result -1342177280 and 2 arithmetic right : %d",result);// the sign isn't being preserved ask 
   #10
   ctrl=6'b000101;
   #10
   $display("ALU Result -1342177280 and 2 shift right : %d",result);

  // Add other test cases here
  //
  //
  //
end

endmodule
