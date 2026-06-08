`include "defines.vh"

module pc_adder(
    input [`XLEN-1:0] pc,
    output [`XLEN-1:0] pc_plus4
);
assign pc_plus4=pc + 4;
endmodule