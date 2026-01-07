#include <iostream>
#include "xtor_calculator.hh"

static int current_A = 0;
static int current_B = 0;
static int current_op = 0;
static char current_op_symbol = '?';

char xtor_calculator::get_symbol(int op) {
    switch(op) {
        case 1: return '+'; // Addition
        case 2: return '-'; // Subtraction
        case 3: return '*'; // Multiplication
        case 4: return '/'; // Division
        default: return '?'; // Unknown
    }
}

// DPI exports to SystemVerilog
extern "C" void status_print() {
    std::cout << "\n[C++] Status check: DPI call to C-side is successful!" << std::endl;
    status_print_sv();
}

// DPI import - SystemVerilog calls this to send results back
extern "C" void receive_result(int result) {
    std::cout << "[C++ Callback] Received result from SV: " << current_A << " " << current_op_symbol << " " << current_B << " = " << result << std::endl << "####" << std::endl;
}


// Helper function to send traffic for a single test
void xtor_calculator::traffic(int A, int B, int op, int rst) {
    // Store current operation for callback
    current_A = A;
    current_B = B;
    current_op = op;
    current_op_symbol = get_symbol(op);

    std::cout << "[inside C++] Testing: " << A << " " << current_op_symbol << " " << B << std::endl;
    set_inputs_negedge_sv(A, B, op, rst);
    // Note: Result will be sent back via receive_result() callback from SV
}


