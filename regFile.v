// Name: Layan Bahaidarah Andreas Francisco
// BU ID: U26666743 U85066104
// EC413 Lab 2 Problem 1: Register File module

module regFile (
  input clock,
  input reset,
  input wEn, // Write Enable
  input [31:0] write_data,
  input [4:0] read_sel1,
  input [4:0] read_sel2,
  input [4:0] write_sel,
  output [31:0] read_data1,
  output [31:0] read_data2
);


reg   [31:0] reg_file[0:31];

assign read_data1 = reg_file[read_sel1];
assign read_data2 = reg_file[read_sel2];

always@(reset) begin 
    reg_file[0]<= 0;
    end
    

always@(posedge clock) begin

        if(wEn & write_sel!=5'b0) begin
        reg_file[write_sel]<=write_data;
end
end

endmodule
             
/******************************************************************************
*                      Start Your Code Here
******************************************************************************/


