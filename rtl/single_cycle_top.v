`include "defines.vh"

module single_cycle_top(
    input clk,
    input reset
);

//Defining all wires that are needed.
//IF Stage
wire [31:0] pc, pc_plus4, instr, next_pc;

//ID AND OF Stage
wire [6:0] opcode, funct7;
wire [4:0] rs1,rs2,rd;
wire [2:0] funct3;
wire [31:0] imm;
wire [31:0] rs1_data,rs2_data;
wire reg_write, mem_read, mem_write, alu_src, branch, jump;
wire [1:0] wb_sel;
wire [3:0] alu_ctrl;
wire funct7_bit30;

//EX Stage
wire [31:0] alu_a, alu_b, alu_result;
wire zero;
wire branch_taken;
wire [31:0] branch_target, jalr_target;
wire taken, is_jalr;
wire alu_a_src; //for AUIPC

//MA Stage
wire [31:0] mem_read_data;

//WB Stage
wire [31:0] wb_data;


//--------------------------------------------------------------------------
//IF STAGE
pc_reg pcreg(
    .clk(clk),
    .rst(reset),
    .next_pc(next_pc),
    .pc(pc)
);

pc_adder pcadder(
    .pc(pc),
    .pc_plus4(pc_plus4)
);

instr_mem imem(
    .pc(pc),
    .instr(instr)
);
//--------------------------------------------------------------------------
//ID & OF STAGE
instr_decoder dec(
    .instr(instr),
    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)
);

imm_gen ig(
    .instr(instr),
    .imm(imm)
);

reg_file rf(
    .clk(clk),
    .rs1_addr(rs1),
    .rs2_addr(rs2),
    .rd_addr(rd),
    .write_data(wb_data),   
    .reg_write(reg_write),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data)
);

control_unit cu(
    .opcode(opcode),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .branch(branch),
    .jump(jump),
    .wb_sel(wb_sel)
);

assign funct7_bit30=instr[30];

alu_control actrl(
    .opcode(opcode),
    .funct3(funct3),
    .funct7_bit30(funct7_bit30),
    .alu_ctrl(alu_ctrl)
);

//--------------------------------------------------------------------------
//EX STAGE

//ALU input mux A for AIUPC support
assign alu_a_src=(opcode==`OPC_AUIPC);
assign alu_a=alu_a_src?pc:rs1_data;

//ALU input mux B based on signal from control unit
assign alu_b = alu_src ? imm : rs2_data;

alu a(
    .a(alu_a),
    .b(alu_b),
    .alu_op(alu_ctrl),
    .result(alu_result),
    .zero(zero)
);

branch_comp bc(
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .funct3(funct3),
    .branch_taken(branch_taken)
);

assign branch_target=pc+imm; //sign extended imm is offset
assign jalr_target   = (rs1_data + imm) & ~32'b1; // doing complement with 1 so that last digit is always zero

assign is_jalr = (opcode == `OPC_JALR);
assign taken   = (branch & branch_taken) | jump;
assign next_pc = taken ? (is_jalr ? jalr_target : branch_target) : pc_plus4;

//--------------------------------------------------------------------------
//MA Stage
data_mem dmem(
    .clk(clk),
    .addr(alu_result),
    .write_data(rs2_data),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .funct3(funct3),
    .read_data(mem_read_data)
);

//--------------------------------------------------------------------------
//WB Stage
write_back_mux wbmux(
    .alu_result(alu_result),
    .mem_data(mem_read_data),
    .pc_plus4(pc_plus4),
    .imm(imm),
    .wb_sel(wb_sel),
    .wb_data(wb_data)
);

endmodule