module MIPS(input clk, rst);

wire PCWriteCond, PCWrite, MemSel, IRwrite,Regwrite, ALUsrcB, WriteSel,MemRead, MemWrite;
wire [1:0] WriteSrc,PCsrc, ALUsrcA;
wire [2:0] ALUcontrol;
wire [3:0] opc;
wire [8:0] func;
DataPath dp (clk, rst, PCWriteCond, PCWrite, MemSel, IRwrite, WriteSrc, PCsrc, Regwrite, ALUsrcA, ALUsrcB, WriteSel,
 MemRead, MemWrite, ALUcontrol, opc, func);

ControllUnit cu (clk, rst, PCWriteCond, PCWrite, MemSel, IRwrite, WriteSrc, PCsrc, Regwrite, ALUsrcA, ALUsrcB, WriteSel,
MemRead, MemWrite, ALUcontrol, opc, func);

endmodule