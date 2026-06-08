`include "defines.vh"

module control_unit(
    input      [6:0] opcode,
    output reg       reg_write,
    output reg       mem_read,
    output reg       mem_write,
    output reg       alu_src,
    output reg       branch,
    output reg       jump,
    output reg [1:0] wb_sel
);

    always @(*) begin
        // default everything to 0 first
        reg_write  = 0;
        mem_read   = 0;
        mem_write  = 0;
        alu_src    = 0;
        branch     = 0;
        jump       = 0;
        wb_sel     = `WB_ALU;

        case (opcode)
            `OPC_R: begin
                reg_write = 1;
                alu_src   = 0;
                wb_sel    = `WB_ALU;
            end

            `OPC_I_ALU: begin
                reg_write = 1;
                alu_src   = 1;
                wb_sel    = `WB_ALU;
            end

            `OPC_LOAD: begin
                reg_write = 1;
                mem_read  = 1;
                alu_src   = 1;
                wb_sel    = `WB_MEM;
            end

            `OPC_STORE: begin
                mem_write = 1;
                alu_src   = 1;
            end

            `OPC_BRANCH: begin
                branch  = 1;
                alu_src = 0;
            end

            `OPC_JAL: begin
                reg_write = 1;
                jump      = 1;
                alu_src   = 1;
                wb_sel    = `WB_PC4;
            end

            `OPC_JALR: begin
                reg_write = 1;
                jump      = 1;
                alu_src   = 1;
                wb_sel    = `WB_PC4;
            end

            `OPC_LUI: begin
                reg_write = 1;
                alu_src   = 1;
                wb_sel    = `WB_IMM;
            end

            `OPC_AUIPC: begin
                reg_write = 1;
                alu_src   = 1;
                wb_sel    = `WB_ALU;
            end
        endcase
    end

endmodule