`include "defines.vh"

module instr_mem(
    input [`XLEN-1:0] pc,
    output [`XLEN-1:0] instr
    
);
    reg [`XLEN-1:0] mem [0:1023];

    initial
    begin
        $readmemh("mem/test.hex",mem); //okay so here we store all the instrcutions we want to execute.
    end

    assign instr=mem[pc[31:2]]; //last 2 digits are zero as is

endmodule