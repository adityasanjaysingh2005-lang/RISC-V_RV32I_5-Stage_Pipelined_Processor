`include "defines.vh"

module mux2to1(
        input [`XLEN-1:0] a,b
        input sel,
        output [`XLEN-1:0] y
);
assign y=sel?b:a;

endmodule