module datapath(input logic clk, reset,
input logic [1:0] ResultSrc,
input logic PCSrc, ALUSrc,
input logic RegWrite,
input logic [2:0] ImmSrc,//modificado a 3 bits
input logic [2:0] ALUControl,
output logic Zero,
output logic [31:0] PC,
input logic [31:0] Instr,
output logic [31:0] ALUResult, WriteData,
input logic [31:0] ReadData);
logic [31:0] PCNext, PCPlus4, PCTarget, xPCTarget;
logic [31:0] ImmExt;
logic [31:0] SrcA, SrcB;
logic [31:0] Result;
// next PC logic
flopr #(32) pcreg(clk, reset, PCNext, PC);
mux2 #(32) pcmux(PCPlus4, PCTarget, PCSrc, PCNext);
mux2 #(32) pcmuxjalr(xPCTarget,ALUResult,ALUSrc,
PCTarget);

adder pcadd4(PC, 32'd4, PCPlus4);

//modificación para agregar a jalr
adder pcaddbranch(PC, ImmExt, xPCTarget);


// register file logic
regfile rf(clk, RegWrite, Instr[19:15], Instr[24:20],
Instr[11:7], Result, SrcA, WriteData);
// se modifica mux3 agregando d3=Instr[31:12] para lui
mux3 #(32) resultmux(ALUResult, ReadData, PCPlus4,
{Instr[31:12],12'b0},ResultSrc, Result);

extend ext(Instr[31:7], ImmSrc, ImmExt);

// ALU logic
mux2 #(32) srcbmux(WriteData, ImmExt, ALUSrc, SrcB);
alu alu(SrcA, SrcB, ALUControl, ALUResult, Zero);

endmodule




module flopr #(parameter WIDTH = 8)
(input logic clk, reset,
input logic [WIDTH-1:0] d,
output logic [WIDTH-1:0] q);
always_ff @(posedge clk, negedge reset)
if (!reset) q <= 0;
else q <= d;
endmodule

module adder(input [31:0] a, b,
output [31:0] y);
assign y = a + b;
endmodule

module extend(input logic [31:7] instr,
input logic [2:0] immsrc,
output logic [31:0] immext);
always_comb
case(immsrc)
// I−type
3'b000: immext = {{20{instr[31]}}, instr[31:20]};
// S−type (stores)
3'b001: immext = {{20{instr[31]}}, instr[31:25],
instr[11:7]};
// B−type (branches)
3'b010: immext = {{20{instr[31]}}, instr[7],
instr[30:25], instr[11:8], 1'b0};
// J−type (jal)
3'b011: immext = {{12{instr[31]}}, instr[19:12],
instr[20], instr[30:21], 1'b0};
3'b100: immext = {instr[31:12],12'b0};

default: immext = 32'bx; // undefined
endcase
endmodule

module flopenr #(parameter WIDTH = 8)
(input logic clk, reset, en,
input logic [WIDTH-1:0] d,
output logic [WIDTH-1:0] q);
always_ff @(posedge clk, negedge reset)
if (!reset) q <= 0;
else if (en) q <= d;
endmodule

module mux2 #(parameter WIDTH = 8)
(input logic [WIDTH-1:0] d0, d1,
input logic s,
output logic [WIDTH-1:0] y);
assign y = s ? d1 : d0;
endmodule
//se modificó agregando el d3 
module mux3 #(parameter WIDTH = 8)
(input logic [WIDTH-1:0] d0, d1, d2,d3,
input logic [1:0] s,
output logic [WIDTH-1:0] y);
//assign y = s[1] ?d2 : (s[0] ? d1 : d0);
assign y = s[1] ?(s[0]?d3:d2) : (s[0] ? d1 : d0);
endmodule

//regfile rf(clk, RegWrite, Instr[19:15], Instr[24:20],Instr[11:7], Result, SrcA, WriteData);
module regfile(input logic clk,
input logic we3,
input logic [4:0] a1, a2, a3,
input logic [31:0] wd3,
output logic [31:0] rd1, rd2);

logic [31:0] rf[31:0];
// three ported register file
// read two ports combinationally (A1/RD1, A2/RD2)
// write third port on rising edge of clock (A3/WD3/WE3)
// register 0 hardwired to 0
always_ff @(posedge clk)
if (we3) rf[a3] <= wd3;
assign rd1 =(a1!=0)?rf[a1]:0;
assign rd2 =(a2!=0)?rf[a2]:0;
endmodule

module alu(input logic [31:0] A, B,input logic [2:0] F,
output logic [31:0] Y, output Zero);
logic [31:0] S, Bout;
assign Bout = F[0] ? ~B : B;
assign S = A + Bout + F[0];
always_comb
case (F[2:1])
3'b00: Y <= S;
3'b01: Y <=F[0]?(A|B):(A&B);
3'b10: Y <= S[31];
3'b11: Y <= 0;
endcase
assign Zero = (Y == 32'b0);
endmodule

