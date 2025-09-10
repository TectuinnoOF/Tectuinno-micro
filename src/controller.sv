module controller(input logic [6:0] op,
input logic [2:0] funct3,
input logic funct7b5,
input logic Zero,
output logic [1:0] ResultSrc,
output logic MemWrite,
output logic PCSrc, ALUSrc,
output logic RegWrite, Jump,
output logic [2:0] ImmSrc,
output logic [2:0] ALUControl);

logic [1:0] ALUOp;
logic Branch;

maindec md(op, ResultSrc, MemWrite, Branch,ALUSrc, RegWrite, Jump, ImmSrc, ALUOp);

aludec ad(op[5], funct3, funct7b5, ALUOp, ALUControl);

assign PCSrc = Branch & Zero | Jump;

endmodule

module maindec(input logic [6:0] op,
output logic [1:0] ResultSrc,
output logic MemWrite,
output logic Branch, ALUSrc,
output logic RegWrite, Jump,
output logic [2:0] ImmSrc,//modifiqué a 3 bits
output logic [1:0] ALUOp);
logic [11:0] controls;
assign {RegWrite, ImmSrc, ALUSrc, MemWrite,
ResultSrc, Branch, ALUOp, Jump} = controls;
always_comb
case(op)
// RegWrite_ImmSrc_ALUSrc_MemWrite_ResultSrc_Branch_ALUOp_Jump
7'b0000011: controls = 12'b1_000_1_0_01_0_00_0; // lw
7'b0100011: controls = 12'b0_001_1_1_00_0_00_0; // sw
7'b0110011: controls = 12'b1_0xx_0_0_00_0_10_0; // R–type
7'b1100011: controls = 12'b0_010_0_0_00_1_01_0; // beq
7'b0010011: controls = 12'b1_000_1_0_00_0_10_0; // I–type ALU
7'b1101111: controls = 12'b1_011_0_0_10_0_00_1; // jal
7'b1100111: controls = 12'b0_000_1_0_10_0_00_1; // jalr ??
7'b0110111: controls = 12'b1_100_0_0_11_0_00_0; // lui
default: controls = 11'bx_xxx_x_x_xx_x_xx_x; // ???
endcase
endmodule

module aludec(input logic opb5,
input logic [2:0] funct3,
input logic funct7b5,
input logic [1:0] ALUOp,
output logic [2:0] ALUControl);
logic RtypeSub;
assign RtypeSub = funct7b5 & opb5; // TRUE for R–type subtract
always_comb
case(ALUOp)
2'b00: ALUControl = 3'b000; // addition
2'b01: ALUControl = 3'b001; // subtraction
default: case(funct3) // R–type or I–type ALU
3'b000: if (RtypeSub)ALUControl = 3'b001; // sub
             else   ALUControl = 3'b000; // add, addi
3'b010: ALUControl = 3'b101; // slt, slti
3'b110: ALUControl = 3'b011; // or, ori
3'b111: ALUControl = 3'b010; // and, andi
default: ALUControl = 3'bxxx; // ???
endcase
endcase
endmodule