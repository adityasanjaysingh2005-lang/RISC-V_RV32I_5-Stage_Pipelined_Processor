`include "defines.vh"

module reg_file(
    input clk,
    input [4:0] rs1_addr, rs2_addr, rd_addr,
    input [`XLEN-1:0] write_data,
    input reg_write,
    output [`XLEN-1:0] rs1_data,
    output [`XLEN-1:0] rs2_data
);

    reg [31:0] regfile [0:31];

    //hardcoding x0=0
    assign rs1_data = (rs1_addr == 5'b0) ? 32'b0 : regfile[rs1_addr];
    assign rs2_data = (rs2_addr == 5'b0) ? 32'b0 : regfile[rs2_addr];

    always @(posedge clk)
    begin
        if(reg_write && rd_addr!=5'b0)
        regfile[rd_addr]<=write_data;
    end



endmodule