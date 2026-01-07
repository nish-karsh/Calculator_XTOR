module top;
    // Signals
    wire [31:0] A, B;       // 32-bit inputs
    wire [2:0] opcode;     // 3-bit choice opcode for operation selection
    reg clk;               // clock signal
    wire reset_high;       // reset signal
    wire [32:0] result;     // 33-bit result

    // Clock generation
    initial clk = 1'b0;
    always #10 clk = ~clk;

    // Instantiate the calculator module (DUT)
    dut uut (
        .clk(clk),
        .A(A),
        .B(B),
        .opcode(opcode),
        .reset_high(reset_high),
        .result(result)
    );
    
    // Instantiate the testbench
    tb uut_tb (
        .clk(clk),
        .A(A),
        .B(B),
        .opcode(opcode),
        .reset_high(reset_high),
        .result(result)
    );

endmodule  