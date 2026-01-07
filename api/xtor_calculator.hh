#pragma once
#include <svdpi.h>

//DPI functions can't be declared inside a class
// DPI function declarations - imports from SystemVerilog
extern "C" void status_print_sv();
extern "C" void callback_sv();
extern "C" void set_inputs_negedge_sv(int a, int b, int op, int rst);

extern "C" void receive_result(int result);
// DPI function declarations - exports to SystemVerilog
extern "C" void status_print();
extern "C" void send_traffic();

class xtor_calculator {
    public:
    // Helper function declarations
    char get_symbol(int op);

    public:
    // Helper function declarations
    void traffic(int A, int B, int op, int rst);
    
};
