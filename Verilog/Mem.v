module Memory(input clk, MemRead, MemWrite, input [11:0] address,input[15:0] WriteData, output reg [15:0] ReadData);
reg[15:0] mem[0:4096];

initial $readmemb("inst.mem",mem,0); 
initial $readmemb("DataMem.mem",mem,100); 

always @(posedge clk) begin
    if (MemWrite) mem[address]=WriteData;
    end
assign      ReadData= (MemRead)?mem[address]:16'b0;
endmodule
