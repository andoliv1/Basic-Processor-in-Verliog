// Name: Layan Bahaidarah 
// BU ID: U26666743
// EC413 Lab 2 Problem 2: ALU Test Bench

module ALU_tb();

reg [5:0] ctrl;
reg [31:0] opA, opB;

wire signed [31:0] result;

ALU dut (
  .ALU_Control(ctrl),
  .operand_A(opA),
  .operand_B(opB),
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

  
 

  // Add other test cases here
  //
  //
  //
end

endmodule
