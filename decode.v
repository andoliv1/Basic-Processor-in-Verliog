// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
// EC413 Project: Decode Module

module decode #(
  parameter ADDRESS_BITS = 16
) (
  // Inputs from Fetch
  input [ADDRESS_BITS-1:0] PC,
  input [31:0] instruction,

  // Inputs from Execute/ALU
  input [ADDRESS_BITS-1:0] JALR_target,
  input branch,

  // Outputs to Fetch
  output next_PC_select,
  output [ADDRESS_BITS-1:0] target_PC,

  // Outputs to Reg File
  output [4:0] read_sel1,
  output [4:0] read_sel2,
  output [4:0] write_sel,
  output wEn,

  // Outputs to Execute/ALU
  output branch_op, // Tells ALU if this is a branch instruction
  output [31:0] imm32,
  output [1:0] op_A_sel,
  output op_B_sel,
  output [5:0] ALU_Control,

  // Outputs to Memory
  output mem_wEn,

  // Outputs to Writeback
  output wb_sel

);

localparam [6:0]R_TYPE  = 7'b0110011,
                I_TYPE  = 7'b0010011,
                STORE   = 7'b0100011,
                LOAD    = 7'b0000011,
                BRANCH  = 7'b1100011,
                JALR    = 7'b1100111,
                JAL     = 7'b1101111,
                AUIPC   = 7'b0010111,
                LUI     = 7'b0110111;


// These are internal wires that I used. You can use them but you do not have to.
// Wires you do not use can be deleted.
wire[6:0]  s_imm_msb;//for s_type
wire[4:0]  s_imm_lsb;// for s_type
wire[19:0] u_imm;//for u_type
wire[11:0] i_imm_orig;//for i_type
wire[19:0] uj_imm;//for j_type
wire[11:0] s_imm_orig;// not currently using 
wire[12:0] sb_imm_orig;// for b_type

wire[31:0] sb_imm_32;
wire[31:0] u_imm_32;
wire[31:0] i_imm_32;
wire[31:0] s_imm_32;
wire[31:0] uj_imm_32;

wire [6:0] opcode;
wire [6:0] funct7;
wire [2:0] funct3;
wire [1:0] extend_sel;
wire [ADDRESS_BITS-1:0] branch_target;
wire [ADDRESS_BITS-1:0] JAL_target;


// Read registers
assign read_sel2  = instruction[24:20];
assign read_sel1  = instruction[19:15];

/* Instruction decoding */
assign opcode = instruction[6:0];
assign funct7 = instruction[31:25];
assign funct3 = instruction[14:12];

/* Write register */
assign write_sel = instruction[11:7];

wire[4:0] shamt;
wire[31:0] shamt_32;

assign shamt = instruction[24:20];
assign shamt_32 = {27'b000000000000000000000000000, shamt};

assign imm32= (R_TYPE == opcode)? 32'b0:

             (I_TYPE == opcode && funct3 == 3'b001)? shamt_32://SLLI
             
             (I_TYPE == opcode && funct3 == 3'b101 && funct7==7'b0)? shamt_32://SRLI
             
             (I_TYPE == opcode && funct3 == 3'b101 && funct7==7'b0100000)? shamt_32://SRAI
             
             (I_TYPE == opcode)?{{20{instruction[31]}},instruction[31:20]}:
             
             (STORE == opcode)? {{20{instruction[31]}},instruction[31:25],instruction[11:7]}:
             
             (LOAD == opcode)? {{20{instruction[31]}},instruction[31:20]}:
             
             (BRANCH == opcode && branch == 1'b1)? {{19{instruction[31]}},instruction[31],instruction[7],instruction[30:25],instruction[11:8], 1'b0}:
             
             (AUIPC == opcode)? {instruction[31:12],12'b0}:
             
             (JAL == opcode)? {{11{instruction[31]}},instruction[31],instruction[19:12],instruction[20],instruction[30:21],1'b0}:
             
             (LUI == opcode)? {instruction[31:12],12'b0}:
             
             (JALR == opcode)? {{20{instruction[31]}},instruction[31:20]}:
             
             32'b00000000000000000000000000000100;

assign target_PC = (JALR == opcode)? JALR_target:
                   (JAL == opcode || BRANCH == opcode)? {{16{PC[15]}},PC} + imm32:
                   {{16{PC[15]}},PC} +32'b00000000000000000000000000000100;
                   

assign next_PC_select=(R_TYPE == opcode)? 0:
                   (I_TYPE == opcode)? 0:
                   (STORE == opcode)? 0:
                   (LOAD == opcode)? 0:
                   (BRANCH == opcode)? 1:
                   (JAL == opcode)? 1:
                   (JALR == opcode)? 1:
                   (AUIPC == opcode)? 1:
                   (LUI == opcode)? 0:
                   0;

             assign branch_op=(R_TYPE == opcode)? 0:
                                 (I_TYPE == opcode)? 0:
                                 (STORE == opcode)? 0:
                                 (LOAD == opcode)? 0:
                                 (BRANCH == opcode)? 1:
                                 (JAL == opcode)? 0:
                                 (JALR == opcode)? 0:
                                 (AUIPC == opcode)? 0:
                                 (LUI == opcode)? 0:
                                 0;
             
             assign wEn= (R_TYPE == opcode)? 1:
                         (I_TYPE == opcode)? 1:
                         (STORE == opcode)? 0:
                         (LOAD == opcode)? 1:
                         (BRANCH == opcode)? 0:
                         (JAL == opcode)? 1:
                         (JALR == opcode)? 1:
                         (AUIPC == opcode)? 1:
                         (LUI == opcode)? 1:
                         0;
             
             assign op_A_sel=(R_TYPE == opcode)? 2'b00://we need to make sure of this
                             (I_TYPE == opcode)? 2'b00:
                             (STORE == opcode)? 2'b00:
                             (LOAD == opcode)? 2'b00:
                             (BRANCH == opcode)? 2'b00: 
                             (JAL == opcode)? 2'b10:
                             (JALR == opcode)? 2'b10:
                             (AUIPC == opcode)? 2'b01:
                             (LUI == opcode)? 2'b11:
                             0;
             
             assign op_B_sel=(R_TYPE == opcode)? 0://we need to make sure of this
                             (I_TYPE == opcode)? 1:
                             (STORE == opcode)? 1:
                             (LOAD == opcode)? 1:
                             (BRANCH == opcode)? 0: 
                             (JAL == opcode)? 1:
                             (JALR == opcode)? 1:
                             (AUIPC == opcode)? 1:
                             (LUI == opcode)? 1:
                             0;
//         
             assign mem_wEn= (R_TYPE == opcode)? 0:
                             (I_TYPE == opcode)? 0:
                             (STORE == opcode)? 1:
                             (LOAD == opcode)? 0:
                             (BRANCH == opcode)? 0:
                             (JAL == opcode)? 0:
                             (JALR == opcode)? 0:
                             (AUIPC == opcode)? 0:
                             (LUI == opcode)? 0:
                             0;
             assign wb_sel=  (R_TYPE == opcode)? 0:
                             (I_TYPE == opcode)? 0:
                             (STORE == opcode)? 0:
                             (LOAD == opcode)? 1:
                             (BRANCH == opcode)? 0:
                             (JAL == opcode)? 0:
                             (JALR == opcode)? 0:
                             (AUIPC == opcode)? 0:
                             (LUI == opcode)? 0:
                             0;

assign ALU_Control=(R_TYPE == opcode&&funct3==3'b000&&funct7==7'b0)?6'b0:/*add*/
                  (R_TYPE == opcode&&funct3==3'b000&&funct7==7'b0100000)?6'b001000://sub
                  (R_TYPE == opcode&&funct3==3'b111)?6'b000111://and
                  (R_TYPE == opcode&&funct3==3'b110)?6'b000110://or
                  (R_TYPE == opcode&&funct3==3'b010)?6'b000010://slt
                  (R_TYPE == opcode&&funct3==3'b001)?6'b000001://sll
                  (R_TYPE == opcode&&funct3==3'b011)?6'b000011://sltu
                  (R_TYPE == opcode&&funct3==3'b100)?6'b000100://xor
                  (R_TYPE == opcode&&funct3==3'b101&&funct7==7'b0)?6'b000101:/*srl*/
                  (R_TYPE == opcode&&funct3==3'b101&&funct7==7'b0100000)?6'b001101://sra

                  (I_TYPE == opcode&&funct3==3'b000)?6'b0://addi
                  (I_TYPE == opcode&&funct3==3'b111)?6'b000111://andi
                  (I_TYPE == opcode&&funct3==3'b110)?6'b000110://ori
                  (I_TYPE == opcode&&funct3==3'b010)?6'b000010://slti
                  (I_TYPE == opcode&&funct3==3'b001)?6'b000001://slli
                  (I_TYPE == opcode&&funct3==3'b011)?6'b000011://sltiu
                  (I_TYPE == opcode&&funct3==3'b100)?6'b000100://xori
                  (I_TYPE == opcode&&funct3==3'b101&&funct7==7'b0)?6'b000101://srli
                  (I_TYPE == opcode&&funct3==3'b101&&funct7==7'b0100000)?6'b001101://srai

                  (STORE == opcode)? 6'b0:

                  (LOAD == opcode)? 6'b0:

                  (BRANCH == opcode&&funct3 == 3'b000)?6'b010000://beq
                  (BRANCH == opcode&&funct3 == 3'b001)?6'b010001://bne
                  (BRANCH == opcode&&funct3 == 3'b100)?6'b010100://blt
                  (BRANCH == opcode&&funct3 == 3'b101)?6'b010101://bge
                  (BRANCH == opcode&&funct3 == 3'b110)?6'b010110://bltu
                  (BRANCH == opcode&&funct3 == 3'b111)?6'b010111://bgeu

                  (JAL == opcode)? 6'b011111:

                  (JALR == opcode)? 6'b111111:

                  (AUIPC == opcode)? 6'b000000:

                  (LUI == opcode)? 6'b000000:

                  6'b0;
 
    
    
    
/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

endmodule
