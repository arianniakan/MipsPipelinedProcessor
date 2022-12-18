module DataPath(input clk, rst, PCWriteCond, PCWrite, MemSel, IRwrite,input[1:0] WriteSrc,PCsrc,input Regwrite, input[1:0] ALUsrcA, input ALUsrcB, WriteSel, input MemRead, MemWrite, input[2:0] ALUcontrol, output[3:0] opc, output [8:0] func);

reg  [11:0] PC=16'b0;
wire [11:0] nPC;
reg [15:0] instruction;
wire zero;
always @(posedge clk) begin
    if(rst) PC<=16'b0;
    else if(PCWrite|(PCWriteCond&zero)) PC<=nPC;
end

wire [11:0] address;
wire [15:0] WriteData, ReadData;
Memory mem(clk, MemRead, MemWrite, address, WriteData, ReadData);
assign address = MemSel?instruction[11:0]:PC;
always @(posedge clk) begin
    if(rst) PC<=12'b0;
    else if(IRwrite) instruction<=ReadData;
    end
wire [15:0] MDR;
REG  #16 mdrREG (clk,ReadData,MDR,rst);
wire [2:0] WriteAddress;
wire [15:0] WriteDataRegister;
wire [15:0] ALUout;
wire [15:0] R0, Ri,ReadDataReg,Read0;
assign WriteAddress = WriteSel ? instruction[11:9]:3'b0;
assign WriteDataRegister = WriteSrc == 2'd0 ? ALUout:
                           WriteSrc == 2'd1 ? MDR:
                           WriteSrc == 2'd2 ? R0:
                           WriteSrc == 2'd3 ? Ri:
                           16'bz;
                           
RegisterFile RF (clk, rst, Regwrite, instruction[11:9], WriteAddress, WriteDataRegister, ReadDataReg, Read0);
REG  #16 Read0Reg (clk,Read0,R0,rst);
REG  #16 RiReg (clk,ReadDataReg,Ri,rst);
wire [15:0] ina, inb, ALUoutw;
wire [15:0] seI;
ALU alu (ina, inb, ALUcontrol, zero, ALUoutw);
assign ina = ALUsrcA == 2'd0 ? Ri:
             ALUsrcA == 2'd1 ? seI:
             ALUsrcA == 2'd2 ? {4'b0000,PC}:
             16'bz;
assign inb = ALUsrcB ? 16'b1:R0;
REG #16 ALUoutReg (clk, ALUoutw, ALUout,rst);
assign nPC = PCsrc == 2'd0 ? ALUoutw[11:0]:
             PCsrc == 2'd1 ? {PC[11:9],instruction[8:0]}:
             PCsrc == 2'd2 ? instruction[11:0]:
             12'bz;

SE12to16 se (instruction[11:0],seI);
assign WriteData = R0;

assign opc = instruction[15:12];
assign func = instruction[8:0];
endmodule