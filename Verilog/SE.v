module SE12to16(input [11:0] in, output [15:0] out);
    assign out = $signed(in);
endmodule

module SE26to28(input [25:0] in, output [27:0] out);
    assign out = $signed(in);
endmodule

