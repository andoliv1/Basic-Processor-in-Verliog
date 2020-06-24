// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
// EC413 Project: Top Level Module

module top #(
  parameter ADDRESS_BITS = 16
) (
  input clock,
  input reset,
  output [31:0] wb_data
);


/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

// Fetch Wires
wire next_PC_select;
wire [ADDRESS_BITS-1:0] target_PC;
wire [ADDRESS_BITS-1:0] PC;

// Decode Wires
wire [31:0] imm32;
wire branch,wEn,branch_op;
wire [4:0] read_sel1, read_sel2, write_sel;
wire [1:0] op_A_sel;
wire op_B_sel;
wire [5:0] ALU_control;
wire mem_wEn;
wire wb_sel;

// Reg File Wires
wire  [31:0]read_data1;
wire  [31:0]read_data2;
wire  [31:0]write_data;

// Execute Wires
wire  [31:0]operand_A;
wire  [31:0]operand_B;
wire  [31:0] ALU_result;

// Memory Wires
wire [31:0]i_read_data;
wire [31:0]d_read_data;
wire [15:0]d_address;
// Writeback wires
wire signed [15:0] JALR_target;

fetch #(
  .ADDRESS_BITS(ADDRESS_BITS)
) fetch_inst (
  .clock(clock),
  .reset(reset),
  .next_PC_select(next_PC_select),
  .target_PC(target_PC),
  .PC(PC)
);


decode #(
  .ADDRESS_BITS(ADDRESS_BITS)
) decode_unit (

  // Inputs from Fetch
  .PC(PC),
  .instruction(i_read_data),

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
  .branch_op(branch_op),
  .imm32(imm32),
  .op_A_sel(op_A_sel),
  .op_B_sel(op_B_sel),
  .ALU_Control(ALU_control),

  // Outputs to Memory
  .mem_wEn(mem_wEn),

  // Outputs to Writeback
  .wb_sel(wb_sel)

);

regFile regFile_inst (
  .clock(clock),
  .reset(reset),
  .wEn(wEn), // Write Enable
  .write_data(write_data),
  .read_sel1(read_sel1),
  .read_sel2(read_sel2),
  .write_sel(write_sel),
  .read_data1(read_data1),
  .read_data2(read_data2)
);

assign operand_B = (op_B_sel == 1'b0)? read_data2:
                    imm32;
                    
assign operand_A = (op_A_sel == 2'b00)? read_data1:
                   (op_A_sel == 2'b01)? PC:
                   (op_A_sel == 2'b10)? PC + 4:
                   32'b0;                   
                   
assign write_data = (wb_sel == 1'b1)? d_read_data:
                     ALU_result;

                   
assign JALR_target = $signed(read_data1 + imm32);
assign JALR_target[0] = 0;

ALU alu_inst(
  .branch_op(branch_op),
  .ALU_Control(ALU_control),
  .operand_A(operand_A),
  .operand_B(operand_B),
  .ALU_result(ALU_result),
  .branch(branch)
);               
  
assign d_address = ALU_result;

ram #(
  .ADDR_WIDTH(ADDRESS_BITS)
) main_memory (
  .clock(clock),

  // Instruction Port
  .i_address(PC),
  .i_read_data(i_read_data),

  // Data Port
  .wEn(mem_wEn),
  .d_address(d_address),
  .d_write_data(read_data2),
  .d_read_data(d_read_data)
);

assign wb_data = write_data;
                    
endmodule
