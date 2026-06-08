`include "defines.vh"

module imm_gen(
    input [`XLEN-1:0] instr,
    output reg [`XLEN-1:0] imm    
);
wire [4:0] opcode; //all opcodes have 11 as last 2 digits
assign opcode=instr[6:2];

always @(*)
begin
    case (opcode)
    5'b01101: imm={instr[31:12],12'b0}; //LUI U Type
    5'b00101: imm={instr[31:12],12'b0}; //AUIPC U Type
    5'b00100: imm={{20{instr[31]}},instr[31:20]}; //I Type - ALU
    5'b00000: imm={{20{instr[31]}},instr[31:20]}; //I Type - Load
    5'b11001: imm={{20{instr[31]}},instr[31:20]}; //I Type - JALR
    5'b01000: imm={{20{instr[31]}},instr[31:25],instr[11:7]}; //S Type
    5'b11011: imm={{12{instr[31]}},instr[19:12],instr[20],instr[30:21],1'b0}; //J Type
    5'b11000: imm={{20{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0}; //B Type
    //J and B-Type have implicit 0 in bit 0. 
    default: imm=32'b0;
    endcase 
end

endmodule