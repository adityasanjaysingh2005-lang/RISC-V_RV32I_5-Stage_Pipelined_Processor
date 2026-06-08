`include "defines.vh"

module data_mem(
    input clk,
    
    input [`XLEN-1:0] addr,
    input [`XLEN-1:0] write_data,
    input mem_read,
    input mem_write,
    input [2:0] funct3,

    output reg [`XLEN-1:0] read_data
    
);

reg [`XLEN-1:0] mem [0:1023];

wire [9:0] word_addr = addr[11:2];
//Basically this much is useful as we only have 1024 memory addresses, so it becomes enough
//plus last 2 digits are bit offsets which we do not require.

always @(posedge clk) begin
        if (mem_write) begin
            case (funct3)
                3'b010: mem[word_addr] <= write_data;                // SW
                3'b001: mem[word_addr][15:0] <= write_data[15:0];    // SH
                3'b000: mem[word_addr][7:0]  <= write_data[7:0];     // SB
                default: ;  // no write
            endcase
        end
    end

always @(*) begin
        if (mem_read) begin
            case (funct3)
                3'b010: read_data = mem[word_addr];                              // LW
                3'b001: read_data = {{16{mem[word_addr][15]}}, mem[word_addr][15:0]}; // LH
                3'b101: read_data = {16'b0, mem[word_addr][15:0]};               // LHU
                3'b000: read_data = {{24{mem[word_addr][7]}}, mem[word_addr][7:0]};  // LB
                3'b100: read_data = {24'b0, mem[word_addr][7:0]};                // LBU
                default: read_data = 32'b0;
            endcase
        end else begin
            read_data = 32'b0;
        end
    end

endmodule