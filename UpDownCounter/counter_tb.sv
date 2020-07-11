`timescale 1ns / 1ps

//Testbench declaration
module counter_tb(counter_if counterif);
    
    //Task enabling reset declaration
    task reset_on(input integer delay);
      #delay counterif.rst <= 1;
    endtask 
    
    //Task disabling reset declaration
    task reset_off(input integer delay);
      #delay counterif.rst <= 0;
    endtask 
    
    //Task enabling counting up declaration
    task apply_up(input integer delay);
      #delay  counterif.is_up <= 1;
    endtask
    
    //Task disabling counting up declaration
    task apply_down(input integer delay);
      #delay  counterif.is_up <= 0;
    endtask
    
    //Task enabling loading value declaration
    task apply_load(input integer delay, input integer load_value);
      #delay  counterif.load <= 1;
        counterif.in <= load_value;
    endtask
    
    //Task disabling loading value declaration
    task apply_load_off(input integer delay);
      #delay  counterif.load <= 0;
        //counterif.in <= 0;
    endtask
    
    
    //Simple simulation
    initial begin
    
    reset_on(5);
    reset_off(0);
    
    apply_load(200,2);
    apply_up(50);
    apply_load(125,5);
    apply_down(50);
    apply_load_off(250);
    
    #1000 $finish;
  end
endmodule
