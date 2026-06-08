`include "defines.vh"

module mux4to1(
        input [`XLEN-1:0] a,b,c,d
        input [1:0] sel,
        output [`XLEN-1:0] y
);
assign y=sel[1]?(sel[0]?d:c):(sel[0]?b:a);


endmodule