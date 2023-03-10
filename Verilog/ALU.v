module ALU(input [15:0] ina, inb, input [2:0] ALUcontrol, output zero, output [15:0] out);
assign zero = (out==0)? 1:0;

assign out = (ALUcontrol == 3'b000) ? (ina+inb):
             (ALUcontrol == 3'b001) ? (inb-ina):
             (ALUcontrol == 3'b010) ? (ina&inb):
             (ALUcontrol == 3'b011) ? (ina|inb):
             (ALUcontrol == 3'b100) ? (~ina):
             (ALUcontrol == 3'b101) ? (inb):
             15'bz;
endmodule

