    `include "defines.vh"

    module branch_comp(
        input  [`XLEN-1:0] rs1_data,
        input  [`XLEN-1:0] rs2_data,       // was rs1_data (copy paste error)
        input  [2:0]  funct3,         // was [3:0], funct3 is only 3 bits
        output reg    branch_taken    // must be reg, driven by always block
    );

        always @(*) begin
            case (funct3)
                3'b000: branch_taken = (rs1_data == rs2_data);
                3'b001: branch_taken = (rs1_data != rs2_data);              // use != directly
                3'b100: branch_taken = ($signed(rs1_data) < $signed(rs2_data));
                3'b101: branch_taken = ($signed(rs1_data) >= $signed(rs2_data));
                3'b110: branch_taken = (rs1_data < rs2_data);
                3'b111: branch_taken = (rs1_data >= rs2_data);
                default: branch_taken = 1'b0;
            endcase
        end

    endmodule