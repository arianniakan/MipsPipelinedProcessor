module RegisterFile(input clk, rst, Regwrite, input[2:0]read, WriteReg, input [15:0] WriteData, output[15:0] ReadData, Read0);
reg [15:0] Registers[0:7];
assign ReadData = Registers[read];
assign Read0 = Registers[0];
integer i;
always @(posedge clk) begin
    if (rst) 
        for (i=0;i<8;i=i+1)
            Registers[i]<=16'b0;
    else if (Regwrite)
                Registers[WriteReg]<=WriteData;

end

endmodule
