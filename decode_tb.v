// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
// EC413 Project: Decode Test Bench

module decode_tb();

parameter NOP = 32'b000000000000_00000_000_00000_0010011; // addi zero, zero, 0
parameter ADDRESS_BITS = 16;

// Inputs from Fetch
reg [ADDRESS_BITS-1:0] PC;
reg [31:0] instruction;

// Inputs from Execute/ALU
reg [ADDRESS_BITS-1:0] JALR_target;
reg branch;

// Outputs to Fetch
wire next_PC_select;
wire [ADDRESS_BITS-1:0] target_PC;

// Outputs to Reg File
wire [4:0] read_sel1;
wire [4:0] read_sel2;
wire [4:0] write_sel;
wire wEn;

// Outputs to Execute/ALU
wire branch_op; // Tells ALU if this is a branch instruction
wire signed [31:0] imm32;
wire [1:0] op_A_sel;
wire op_B_sel;
wire [5:0] ALU_Control;
wire result;

// Outputs to Memory
wire mem_wEn;

// Outputs to Writeback
wire wb_sel;

decode #(
  .ADDRESS_BITS(ADDRESS_BITS)
) uut (

  // Inputs from Fetch
  .PC(PC),
  .instruction(instruction),

  // Inputs from Execute/ALU
  .JALR_target(JALR_target),
  .branch(branch),

  // Outputs to Fetch
  .next_PC_select(next_PC_select),
  .target_PC(target_PC),

  // Outputs to Reg File
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .wEn(wEn),

  // Outputs to Execute/ALU
  .branch_op(branch_op), // Tells ALU if this is a branch instruction
  .imm32(imm32),
  .op_A_sel(op_A_sel),
  .op_B_sel(op_B_sel),
  .ALU_Control(ALU_Control),

  // Outputs to Memory
  .mem_wEn(mem_wEn),

  // Outputs to Writeback
  .wb_sel(wb_sel)

);


//ALU dut (
//  .ALU_Control(ALU_Control),
//  .operand_A(op_A_sel),
//  .operand_B(opB),
//  .branch_op(branch_op),
//  .branch(branch),
//  .ALU_result(result)
//);



task print_state;
  begin
    $display("Time:         %0d", $time);
    $display("instruction:  %b", instruction);
    $display("PC:           %h", PC);
    $display("JALR_target:  %h", JALR_target);
    $display("branch        %b", branch);
    $display("next_PC_sel   %b", next_PC_select);
    $display("target_PC     %h", target_PC);
    $display("read_sel1:    %d", read_sel1);
    $display("read_sel2:    %d", read_sel2);
    $display("write_sel:    %d", write_sel);
    $display("wEn:          %b", wEn);
    $display("branch_op:    %b", branch_op);
    $display("imm32:        %b", imm32);
    $display("op_A_sel:     %b", op_A_sel);
    $display("op_B_sel:     %b", op_B_sel);
    $display("ALU_Control:  %b", ALU_Control);
    $display("mem_wEn:      %b", mem_wEn);
    $display("wb_sel:       %b", wb_sel);
    $display("--------------------------------------------------------------------------------");
    $display("\n\n");
  end
endtask



initial begin
  $display("Starting Decode Test");
  $display("--------------------------------------------------------------------------------");
  instruction = NOP;
  PC          = 0;
  JALR_target = 0;
  branch      = 0;

  #20
  // Display output of NOP instruction
  $display("addi zero, zero, 0");
  print_state();
  // Test a new instruction
  instruction = 32'b111111111111_00000_000_01011_0010011; // addi a1, zero, -1

  #20
  // Here we are printing the state of the register file.
  // We should see the result of the add a6, a1, a2 instruction but not the
  // sub a7, a2, a4 instruction because there has not been a posedge clock yet
  $display("addi a1, zero, -1");
  print_state();
  instruction = 32'b0000000_01100_01011_000_10000_0110011; // add a6, a1, a2

  #20
  $display("add a6, a1, a2");
  print_state();
  instruction = 32'b0100000_01110_01100_000_10001_0110011; // sub a7, a2, a4

  #20
  $display("sub a7, a2, a4");
  print_state();
  instruction = 32'b0000000_01111_01011_010_01010_0110011; // slt a0, a1, a5

  #20
  $display("slt a0, a1, a5");
  print_state();
  instruction = 32'b0000000_01111_01011_100_01110_0110011; // xor a4, a1, a5

  #20
  $display("xor a4, a1, a5");
  print_state();
  instruction = 32'b0000000_01011_01101_111_01101_0110011; // and a3, a3, a1

  #20
  $display("and a3, a3, a1");
  print_state();
  instruction = 32'b011000000000_00000_000_01011_0010011; // addi a1, zero, 1536
  
  #20
    $display("addi a1, zero, 1536");
    print_state();

  instruction = 32'b0000000_01100_01011_010_00000_0100011; // sw a2, 0(a1);

  #20
  $display("sw a2, 0(a1)");
  print_state();
  instruction = 32'b000000000000_01011_010_10010_0000011; // lw s2, 0(a1);

  #20
  $display("lw s2, 0(a1)");
  print_state();
  instruction = NOP;

  PC = 16'h0114;
  instruction = 32'h0140006f; //jal	zero,128 (Should jump to 0x128)

  #20
  $display("jal	zero,128");
  print_state();

  JALR_target = 16'h0154;
  PC = 16'h0094;
  instruction = 32'h0c4080e7; // jalr ra,196(ra) (should jump to ra+0x196)

  #20
  $display("jalr ra,196(ra)");
  print_state();

/******************************************************************************
*                     Add Test Cases Here
******************************************************************************/
  instruction = 32'b0001000__01101_01011_000_00000_1100011; // beq a3,a1,128
  branch = 1'b1;
  #20
  $display("beq a3,a1,128 ");
  print_state();
  instruction = 32'b0000011_01100_01011_010_00001_0100011; // sw a2, 0(a1);
  #20
  $display("sw a2, 97(a1)");
  print_state(); 
  instruction = 32'b00000000000001011010_00111_0010111; // auipc x7, 90
  #20
  $display("auipc x7, 90)");
  print_state();
  instruction = 32'b00000000000000011000_00001_0110111; // LUI a1, 24
  #20
  $display("LUI a1,24 ");

   print_state();
   instruction = 32'b0000000_01100_01111_001_10010_0110011; // SLL x18, x12, x15
 
   #20
   $display("sll x18, x12, x15");
   
    print_state();
     instruction = 32'b0001100_01101_01011_100_00001_1100011; // blt a3,a1,384
   
     #20
     $display("blt a3, a1, 2432");
     
    print_state();
    instruction = 32'b100000101011_00111_111_00111_0010011; // andi x7, x7, -2005
     
    #20
    $display("andi x7, x7, -2005");
    print_state();
    instruction = 32'b0100000_00111_01011_101_01110_0110011; // sra x14, x11, x7
       
    #20
    $display("sra x14, x11, x7");
    print_state();
    
    instruction = 32'b0100000_11111_01011_101_01110_0010011; // srai x14, x11, 32
           
    #20
    $display("srai x14, x11, 31");
    print_state();
  
  $stop();
end

endmodule
