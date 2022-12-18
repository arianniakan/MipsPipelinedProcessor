module ControllUnit  (input clk, rst, output reg PCWriteCond, PCWrite, MemSel, IRwrite,output reg[1:0] WriteSrc,PCsrc,output reg Regwrite, output reg[1:0] ALUsrcA, output reg ALUsrcB, WriteSel,
output reg MemRead, MemWrite, output [2:0] ALUcontrol, input[3:0] opc, input[8:0] func);
                    
reg[2:0] ALUop;

    parameter [3:0] IF = 4'd0, ID = 4'd1, addi = 4'd2, subi = 4'd3, andi=4'd4, ori = 4'd5, MemRef=4'd6, Store = 4'd7, 
    Load = 4'd8, J = 4'd9, beq = 4'd10, RT = 4'd11, MoveTo=4'd12, MoveFrom = 4'd13, Ary = 4'd14, WB = 4'd15;    
    alu_cu ALU_CU(ALUop, func[8:2], ALUcontrol);
    reg [3:0] ps, ns;
    always @(opc, ps, func) begin
      case(ps)
          IF : ns = ID;
          ID : ns = (opc[3:2] == 2'b10)? RT:
                    (opc[3:2] == 2'b01)? beq:
                    (opc[3:1] == 3'b001)? J:
                    (opc == 4'b1100)? addi:
                    (opc == 4'b1101)? subi:
                    (opc == 4'b1110)? andi:
                    (opc == 4'b1111)? ori:
                    (opc[3:1] == 3'b000)? MemRef:
                    IF;
          addi : ns = WB;
          subi : ns = WB;
          andi : ns = WB;
          ori : ns = WB;
          WB : ns = IF;
          MemRef : ns=opc[0]? Store:Load;
          Load : ns=IF;
          Store : ns=IF;
          J : ns=IF;
          beq : ns=IF;
          RT : ns = func[0]?MoveTo:
                    func[1]?MoveFrom:
                    Ary;
          MoveFrom : ns = IF;
          MoveTo : ns = IF;
          Ary : ns = IF;
        default: ns=IF;
      endcase
    end
    
    always @(ps) begin
      {PCWriteCond, PCWrite, MemSel, IRwrite, WriteSrc, PCsrc, Regwrite, ALUsrcA, ALUsrcB, WriteSel,MemRead, MemWrite} = 15'b0;
      ALUop = 3'b101;
      case(ps) 
      IF : begin MemRead = 1'b1;IRwrite=1'b1;ALUsrcA=2'd2;ALUsrcB=1'b1;ALUop=3'b000; PCWrite = 1'b1; end
      addi :begin ALUsrcA=2'd1; ALUop = 3'b000; end
      subi :begin ALUsrcA=2'd1; ALUop = 3'b001; end
      andi : begin ALUsrcA=2'd1; ALUop = 3'b010; end
      ori : begin ALUsrcA=2'd1; ALUop = 3'b011; end
      MemRef : begin MemSel=1'b1; MemRead=1'b1; end
      WB : Regwrite = 1'b1;
      Load : begin WriteSrc=2'd1; Regwrite = 1'b1; end
      Store : begin MemSel=1'b1; MemWrite = 1'b1; end
      J : begin PCsrc=2'd2; PCWrite = 1'b1; end
      beq : begin PCsrc = 2'b01;ALUop = 3'b001; PCWriteCond = 1'b1; end
      RT :  ALUop = 3'b111; 
      MoveFrom : begin  WriteSrc=2'd3; Regwrite = 1'b1; end
      MoveTo : begin WriteSel = 1'b1; WriteSrc=2'd2; Regwrite = 1'b1; end
      Ary : begin Regwrite = 1'b1; end
        default :  begin      {PCWriteCond, PCWrite, MemSel, IRwrite, WriteSrc, PCsrc, Regwrite, ALUsrcA, ALUsrcB, WriteSel,MemRead, MemWrite} = 15'b0;ALUop = 3'b101;end
      endcase
    end
    always @(posedge clk, rst) begin
       if(rst) ps<=IF;
      else ps<=ns;
     end
     
    

  
endmodule