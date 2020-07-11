`timescale 1ns / 1ps

module FSM_tb;      //Declaration of logical signals
  logic clk;         
  logic data; 
  logic reset;
  logic out;              

    //Design Under Test 
    FSM dut( .clk (clk),
                 .data (data),
                 .reset (reset),
                 .out (out));
    
    //Task generating 101 sequnce
    task get_101();
       #5 data <= 1;
       #5 data <= 0;
       #5 data <= 1;
    endtask 
    
    //Task generating 111 sequnce
    task get_111();
       #5 data <= 1;
       #5 data <= 1;
       #5 data <= 1;
    endtask 
    
    //Task generating 001 sequnce
    task get_001();
       #5 data <= 0;
       #5 data <= 0;
       #5 data <= 1;
    endtask 
    
    //Task generating 010 sequnce
    task get_010();
       #5 data <= 0;
       #5 data <= 1;
       #5 data <= 0;
    endtask 
    
    //Task enabling reset 
    task reset_on(input integer delay);
      #delay reset <= 1;
    endtask 
    
    //Task disabling reset 
    task reset_off(input integer delay);
      #delay reset <= 0;
    endtask
    
    //Clock period declaration
    always #5 clk = ~clk;
    
    //Repeating bits sequnces 
    always
    begin
        get_010();
        get_001();
        get_111();
        get_101(); 
    end
    
    //Initial variable values and resets
    initial 
    begin
        clk <= 0;
        data <= 0; 
        reset <= 0;
      
        reset_on(500);
        reset_off(250);

        #1000 $finish;
    end
            
endmodule
