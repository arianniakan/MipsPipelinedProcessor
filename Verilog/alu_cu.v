module alu_cu (input [2:0] alu_op, input [6:0] func, output reg [2:0] ALUcontrol);
  
  always @(alu_op, func)
  begin
    ALUcontrol = 3'b101;
    if (alu_op == 3'b000)        // add
            ALUcontrol = 3'b000;
    else if (alu_op == 3'b001)   // sub
            ALUcontrol = 3'b001;
    else if (alu_op == 3'b010)   // and
            ALUcontrol = 3'b010;
    else if (alu_op == 3'b011)   // or
            ALUcontrol = 3'b011;
    else if (alu_op == 3'b111)    // R-type
      begin
        case (func)
          7'b0000001: ALUcontrol = 3'b000;  // add
          7'b0000010: ALUcontrol = 3'b001;  // sub
          7'b0000100: ALUcontrol = 3'b010;  // and
          7'b0001000: ALUcontrol = 3'b011;  // or
          7'b0010000: ALUcontrol = 3'b100;  // not
          7'b0100000: ALUcontrol = 3'b101;  // nop
        default:   ALUcontrol = 3'b101;
        endcase
      end
        
  end
  
endmodule
