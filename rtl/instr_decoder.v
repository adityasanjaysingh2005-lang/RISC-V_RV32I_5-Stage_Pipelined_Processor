`include "defines.vh"

module instr_decoder(
    input [31:0] instr,
    output [6:0] funct7,
    output [4:0] rs2,
    output [4:0] rs1,
    output [2:0] funct3,
    output [4:0] rd,
    output [6:0] opcode
);
assign funct7=instr[31:25];
assign rs2=instr[24:20];
assign rs1=instr[19:15];
assign funct3=instr[14:12];
assign rd=instr[11:7];
assign opcode=instr[6:0];

endmodule