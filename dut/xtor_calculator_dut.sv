`timescale 1ns/100ps

// Simple calculator module
module dut(
  input            clk,
  input [31:0]      A,
  input [31:0]      B,
  input [2:0]      opcode, // changed to 3 bits
  input            reset_high,  // added reset input
  output reg [32:0] result
);
  logic [32:0] out; // changed to logic and 33 bits
  always_comb 
    begin
      case (opcode)
        3'd1: out = {1'b0, A} + {1'b0, B};
        3'd2: out = {1'b0, A} - {1'b0, B};
        3'd3: out = {1'b0, A} * {1'b0, B};
        3'd4: out = (B != 32'b0) ? {1'b0, A} / {1'b0, B} : 33'd0; // avoid divide by zero
        default: out = 33'd0; // assign to out, not result
      endcase
    end
   always_ff @(posedge clk)
     begin
        if (reset_high)
          result <= 33'd0; // reset result to 0
        else
          result <= out;
     end

endmodule
