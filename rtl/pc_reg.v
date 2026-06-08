`include "defines.vh"

module pc_reg(
        input clk, rst,
        input [`XLEN-1:0] next_pc,
        output reg [`XLEN-1:0] pc
);

always @(posedge clk)
begin
    if(rst)
        pc<=0;
    else
        pc<=next_pc;
end

endmodule