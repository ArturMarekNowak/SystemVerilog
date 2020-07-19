`timescale 1ns / 1ps

//Testbench declaration with parameters
module counter_tb #(BIT_WIDTH, CLK_PERIOD)(counter_if counterif);
    
    //Task toggling reset
    task toggle_reset();
        counterif.rst = ~counterif.rst;
    endtask   
    
    //Task changing cnfiguration of counter 
    task toggle_load(input integer value, input integer a, input integer b);
        counterif.load_value_and_if_is_up[0] = a;
        counterif.load_value_and_if_is_up[1] = b;
        if(counterif.load_value_and_if_is_up[1])
            counterif.in = value;
    endtask
    
    
    //Clock
    always 
    begin : clock
        counterif.clk <= 0; #(CLK_PERIOD/2.0);
        counterif.clk <= 1; #(CLK_PERIOD/2.0);
    end : clock

    //Simple simulation
    initial 
    begin : simulation
    
    #100 
    toggle_load(3,1,1);
    
    #100 
    toggle_load(4,1,0);
    
    #100 
    toggle_load(2,0,1);
    
    #100 
    toggle_load(5,1,0);
    
    #100
    toggle_reset();
    
    #100
    toggle_reset();
    
    #1000 $finish;
    end : simulation
endmodule
