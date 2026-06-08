// defines.vh
// Global constants for the entire RV32I project. Every module includes this
// file so we never hardcode magic numbers anywhere else.

`ifndef DEFINES_VH         // include guard: only define stuff once
`define DEFINES_VH         // even if multiple files include this header


// ============================================================
// Word width
// ============================================================

`define XLEN        32     // RV32I means every register and address is 32 bits
`define REG_COUNT   32     // 32 general purpose registers (x0 through x31)


// ============================================================
// ALU operation codes
// 4 bits because we have 11 operations, which fits in 4 bits (max 16)
// These drive the case statement inside alu.v
// ============================================================

`define ALU_ADD     4'd0   // addition (used by add, addi, loads, stores, branches)
`define ALU_SUB     4'd1   // subtraction (used by sub)
`define ALU_AND     4'd2   // bitwise AND (and, andi)
`define ALU_OR      4'd3   // bitwise OR (or, ori)
`define ALU_XOR     4'd4   // bitwise XOR (xor, xori)
`define ALU_SLT     4'd5   // set less than, signed (slt, slti)
`define ALU_SLTU    4'd6   // set less than, unsigned (sltu, sltiu)
`define ALU_SLL     4'd7   // shift left logical (sll, slli)
`define ALU_SRL     4'd8   // shift right logical (srl, srli)
`define ALU_SRA     4'd9   // shift right arithmetic, preserves sign (sra, srai)
`define ALU_LUI     4'd10  // pass-through for LUI, just outputs operand B


// ============================================================
// Opcodes (bits 6:0 of every instruction)
// 7 bits wide, copied directly from the RISC-V spec
// These drive the case statement inside control_unit.v
// ============================================================

`define OPC_R       7'b0110011  // R-type: add, sub, and, or, xor, sll, srl, sra, slt, sltu
`define OPC_I_ALU   7'b0010011  // I-type ALU: addi, andi, ori, xori, slti, sltiu, slli, srli, srai
`define OPC_LOAD    7'b0000011  // I-type loads: lb, lh, lw, lbu, lhu
`define OPC_STORE   7'b0100011  // S-type stores: sb, sh, sw
`define OPC_BRANCH  7'b1100011  // B-type branches: beq, bne, blt, bge, bltu, bgeu
`define OPC_JAL     7'b1101111  // J-type: jal
`define OPC_JALR    7'b1100111  // I-type jump: jalr
`define OPC_LUI     7'b0110111  // U-type: lui
`define OPC_AUIPC   7'b0010111  // U-type: auipc


// ============================================================
// Writeback source select (2 bits, drives write_back_mux.v)
// Picks where the data written back to the register file comes from
// ============================================================

`define WB_ALU      2'd0   // most instructions: ALU result goes to rd
`define WB_MEM      2'd1   // loads: memory read data goes to rd
`define WB_PC4      2'd2   // jal and jalr: PC+4 (return address) goes to rd
`define WB_IMM      2'd3   // lui: immediate goes directly to rd


// ============================================================
// Cache parameters (used in Phase 3)
// 2-way set associative, 16 sets, 4 words per block
// ============================================================

`define CACHE_SETS    16   // number of sets in the cache
`define CACHE_WAYS    2    // 2-way set associative
`define BLOCK_SIZE    4    // words per cache line (4 words = 16 bytes)

// Address breakdown for a 32-bit address:
//   [31 .. 8] tag (24 bits)
//   [7 ..  4] index (4 bits, since log2(16 sets) = 4)
//   [3 ..  0] offset (4 bits, since log2(16 bytes per block) = 4)

`define TAG_BITS      24   // upper bits used to identify a unique block
`define INDEX_BITS    4    // bits used to pick which set
`define OFFSET_BITS   4    // bits used to pick a byte within a block


// ============================================================
// Main memory parameters (used in Phase 3)
// ============================================================

`define MEM_LATENCY   10   // cycles to service a cache miss
`define MEM_SIZE      1024 // total words of main memory


`endif                    // close the include guard