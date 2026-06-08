`include "defines.vh"

module alu_control(
    input      [6:0] opcode,
    input      [2:0] funct3,
    input            funct7_bit30,
    output reg [3:0] alu_op
);

    always @(*) begin
        case (opcode)
            `OPC_LOAD:   alu_op = `ALU_ADD;
            `OPC_STORE:  alu_op = `ALU_ADD;
            `OPC_AUIPC:  alu_op = `ALU_ADD;
            `OPC_JALR:   alu_op = `ALU_ADD;
            `OPC_JAL:    alu_op = `ALU_ADD;
            `OPC_LUI:    alu_op = `ALU_LUI;

            `OPC_R, `OPC_I_ALU: begin
                case (funct3)
                    3'b000: alu_op = funct7_bit30 ? `ALU_SUB : `ALU_ADD;
                    3'b001: alu_op = `ALU_SLL;
                    3'b010: alu_op = `ALU_SLT;
                    3'b011: alu_op = `ALU_SLTU;
                    3'b100: alu_op = `ALU_XOR;
                    3'b101: alu_op = funct7_bit30 ? `ALU_SRA : `ALU_SRL;
                    3'b110: alu_op = `ALU_OR;
                    3'b111: alu_op = `ALU_AND;
                    default: alu_op = `ALU_ADD;
                endcase
            end

            default: alu_op = `ALU_ADD;
        endcase
    end

endmodule