  // Name: Your Name
// BU ID: Your ID
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

 
 
 assign s_imm_msb=instruction[31:25];
 assign s_imm_lsb=instruction[11:7];
 assign u_imm=instruction[31:12];
 assign i_imm_orig= instruction[31:20];
 assign uj_imm={instruction[31],instruction[21:12],instruction[22],instruction[30:23]};
 assign sb_imm_orig={instruction[31],instruction[7],instruction[30:25],instruction[11:8]};

always@(*)
begin 
case(opcode)
    R_TYPE:
        begin
        next_PC_select=0;
        branch_op=0;
        wEn=1;
        mem_wEn=0;
        op_A_sel=2'b00;
        op_B_sel=0;
        if(funct3==3'b000)
        begin 
            if(funct7==7'b0)
            ALU_Control=6'b0;
            else
            ALU_C
            
         
        end
    
    
/******************************************************************************
*                      Start Your Code Here
******************************************************************************/

endmodule
