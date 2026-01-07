`timescale 1ns / 100ps

module tb(
    input clk,
    output reg [31:0] A, B,       // 8-bit inputs
    output reg [2:0] opcode,     // 3-bit choice opcode for operation selection
    output reg reset_high,       // reset signal
    input wire [32:0] result      // 33-bit result from DUT
);

    // DPI imports from C++ - for SV to call C++ functions
    import "DPI-C" context function void status_print();
    import "DPI-C" context task send_traffic();//no need of void keyword here as it is a task
    import "DPI-C" context function void receive_result(input int result);
    
    // DPI exports to C++ - for C++ to call SV functions
    export "DPI-C" function status_print_sv;
    export "DPI-C" function callback_sv;
    export "DPI-C" task set_inputs_negedge_sv;
    //export "DPI-C" task get_result_posedge_sv;

    // C++-driven testbench - SV calls C++ entry point which drives the test
    initial begin
        // Initialize inputs
        A = 32'b0; B = 32'b0; opcode = 3'b000; reset_high = 1'b1;
        #100;  // Wait for initial setup
        
        // Call C++ send_traffic() which will drive the test
        send_traffic();
        
        #1000;  // Wait for C++ driven tests to complete
        $finish;
    end

    // Monitor for debugging
    // initial begin
    //     $monitor("Time = %0t | Reset = %b | A = %d | B = %d | opcode = %d | Result = %d", 
    //              $time, reset_high, A, B, opcode, result);
    // end

    initial begin
        $fsdbDumpon;
        $fsdbDumpvars("+all");    
    end

    // DPI export functions for C++ to call
    function void status_print_sv();
        $display("[Inside SV] Calculator DPI call to SV-side is successful.[EOM].");
    endfunction

    function void callback_sv();
        $display("[Inside SV] Callback function invoked from C-side.[EOM].");
        $display("[Inside SV] Test completed successfully!");
        $finish;
    endfunction
    
    // Set inputs on negedge of clock
    task set_inputs_negedge_sv(input int a, input int b, input int op, input int rst);
        @(negedge clk);  // Wait for negedge
        A = a;
        B = b;
        opcode = op[2:0];
        reset_high = rst[0];
        $display("[Inside SV] Time : %0t Inputs set at negedge - A=%d, B=%d, opcode=%d, reset=%d", $time, a, b, op, rst);
        @(posedge clk);  // Wait for posedge
        #1;// small delay to allow result to stabilize
        //result_out = result;
        $display("[Inside SV] Time : %0t Result read at posedge - Result=%d", $time, result);
        // Send result back to C++ via import call
        receive_result(result);
    endtask
endmodule
