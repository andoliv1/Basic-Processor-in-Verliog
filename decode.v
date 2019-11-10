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
 
 assign s_imm_32={{20{s_imm_msb[6]}},s_imm_msb,s_imm_lsb};
 assign u_imm_32={{12{u_imm[19]}},u_imm};
 assign i_imm_32={{20{i_imm_orig[11]}},i_imm_orig};
 assign uj_imm={{12{uj_imm[19]}},uj_imm};
 assign sb_imm_32={{20{sb_imm_orig[11]}},sb_imm_orig};

reg next_PC_select_1,branch_op_1,wEn_1,wb_sel_1,mem_wEn_1,op_B_sel_1;
reg[1:0] op_A_sel_1;
reg[31:0] imm32_1;
reg[5:0] ALU_Control_1;
always@(*)
begin 
case(opcode)
   R_TYPE:
   begin
       next_PC_select_1=0;
       branch_op_1=0;
       wEn_1=1;
       wb_sel_1=0;
       mem_wEn_1=0;
       op_A_sel_1=2'b00;
       op_B_sel_1=0;
       imm32_1=32'b0;
       if(funct3==3'b000)
       begin
           if(funct7==7'b0)
           ALU_Control_1=6'b0;//add
           else
           ALU_Control_1=6'b001000;//sub
       end
       else if(funct3==3'b111)
           ALU_Control_1=6'b000111;//and
       else if(funct3==3'b110)
           ALU_Control_1=6'b000110;//or
       else if(funct3==3'b010)
           ALU_Control_1=6'b000010;//slt
       else if(funct3==3'b001)
           ALU_Control_1=6'b000001;//sll
       else if(funct3==3'b011)
          ALU_Control_1=6'b000010;//sltu
       else if(funct3==3'b100)
           ALU_Control_1=6'b000100;//xor
       else if(funct3==3'b101)
       begin
           if(funct7==7'b0)
           ALU_Control_1=6'b000101;//srl
           else
           ALU_Control_1=6'b001101;//sra
       end
   end
   I_TYPE:
   begin
       next_PC_select_1=0;
       branch_op_1=0;
       wEn_1=1;
       wb_sel_1=0;
       mem_wEn_1=0;
       op_A_sel_1=2'b00;
       op_B_sel_1=1;//make sure if 1 or 0
       imm32_1=i_imm_32;
       if(funct3==3'b000)
           ALU_Control_1=6'b0;
       else if(funct3==3'b111)
           ALU_Control_1=6'b000111;//andi
       else if(funct3==3'b110)
           ALU_Control_1=6'b000110;//ori
       else if(funct3==3'b010)
           ALU_Control_1=6'b000010;//slti
       else if(funct3==3'b001)
           ALU_Control_1=6'b000001;//slli (figure out shamt)
       else if(funct3==3'b011)
          ALU_Control_1=6'b000010;//sltiu
       else if(funct3==3'b100)
           ALU_Control_1=6'b000100;//xori
       else if(funct3==3'b101)
               begin
                   if(funct7==7'b0)
                   ALU_Control_1=6'b000101;//srli(figure out shamt)
                   else
                   ALU_Control_1=6'b001101;//srai(figure out shamt)
                   end
      end
      STORE:
      begin
           next_PC_select_1=0;
           branch_op_1=0;
           wEn_1=0;
           wb_sel_1=0;
           mem_wEn_1=1;
           imm32_1=s_imm_32;
           op_A_sel_1=2'b00;
           op_B_sel_1=1;//make sure if 1 or 0
           ALU_Control_1=6'b0;  
      end
      LOAD:
         begin
              next_PC_select_1=0;
              branch_op_1=0;
              wEn_1=1;
              wb_sel_1=1;
              mem_wEn_1=0;
              imm32_1=s_imm_32;
              op_A_sel_1=2'b00;
              op_B_sel_1=1;//make sure if 1 or 0
              ALU_Control_1=6'b0;  
         end
        BRANCH:
            begin
            next_PC_select_1=1;
            branch_op_1=1;
            wEn_1=0;
            wb_sel_1 = 0;
            mem_wEn_1 = 0;
            op_A_sel_1 = 2'b00;
            op_B_sel_1 = 1'b0;
            imm32_1 = sb_imm_32;
            if(funct3 == 3'b000)
                ALU_Control_1 = 6'b010000;
            else if(funct3 == 3'b001)
                ALU_Control_1= 6'b010001;
            else if(funct3 == 3'b100)
                ALU_Control_1 = 6'b010100;
            else if(funct3 == 3'b101)
                ALU_Control_1= 6'b010101;
            else if(funct3 == 3'b110)
                ALU_Control_1= 6'b010110;
            else
                ALU_Control_1 = 6'b010111;
            end  
          JALR:
            begin
            next_PC_select_1 = 1;
            branch_op_1 = 0;
            wEn_1 = 1;
            wb_sel_1 = 1;
            mem_wEn_1 = 0;
            op_A_sel_1 = 2'b01;
            op_B_sel_1 = 1;
            imm32_1 = uj_imm_32;
            ALU_Control_1 = 6'b111111;
            end
          JAL:
            begin
            next_PC_select_1 = 1;
            branch_op_1 = 0;
            wEn_1 = 0;
            wb_sel_1 = 0;
            mem_wEn_1 = 0;
            op_A_sel_1 = 2'b01;
            op_B_sel_1 = 1;
            imm32_1 = uj_imm_32;
            ALU_Control_1 =6'b011111;
            end
          AUIPC:
            begin
            next_PC_select_1 = 0;
            branch_op_1 = 0;
            wEn_1 = 0;
            wb_sel_1 = 0;
            mem_wEn_1 = 0;
            op_A_sel_1 = 2'b01;
            op_B_sel_1 = 1;
            imm32_1 = u_imm_32;
            ALU_Control_1 = 6'b000000;
            end
          LUI:
            begin
            next_PC_select_1 = 0;
            branch_op_1 = 0;
            wEn_1 = 1;
            wb_sel_1 = 0;
            mem_wEn_1 = 0;
            op_A_sel_1 = 2'b00;
            op_B_sel_1 = 1;
            imm32_1 = u_imm_32;
            ALU_Control_1 = 6'b000000;
            end
            endcase
            end

assign next_PC_select =  next_PC_select_1;
assign branch_op = branch_op_1;
assign wEn = wEn_1;
assign wb_sel = wb_sel_1;
assign mem_wEn = mem_wEn_1;
assign op_A_sel= op_A_sel_1;
assign op_B_sel = op_B_sel_1;
assign imm32 = imm32_1;
assign ALU_Control = ALU_Control_1;

endmodule
