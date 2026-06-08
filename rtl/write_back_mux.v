`include "defines.vh"

module write_back_mux(
    input  [`XLEN-1:0] alu_result,
    input  [`XLEN-1:0] mem_data,
    input  [`XLEN-1:0] pc_plus4,
    input  [`XLEN-1:0] imm,
    input  [1:0]  wb_sel,
    output reg [`XLEN-1:0] wb_data
);

    always @(*) begin
        case (wb_sel)
            `WB_ALU: wb_data = alu_result; // for ADD, SUB, etc
            `WB_MEM: wb_data = mem_data;  // for LW, LH, etc
            `WB_PC4: wb_data = pc_plus4; // for JAL, JALR
            `WB_IMM: wb_data = imm; // for LUI
            default: wb_data = 32'b0;
        endcase
    end

endmodule