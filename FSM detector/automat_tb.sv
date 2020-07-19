`timescale 1ns / 1ps

module FSM_tb;      //Declaration of logical signals
    logic clk;         
    logic data; 
    logic reset;
    logic out;              
    
    //Clock parameter
    parameter CLK_PERIOD = 20;
    
    //Design Under Test 
    FSM dut( .clk (clk),
                 .data (data),
                 .reset (reset),
                 .out (out));
    
    //Task which assigns bits to data signal based on vector input
    task get_bits(input [8:0] bits_sequence);
        for(int i = 0; i<8; i++)
        begin
            #CLK_PERIOD data = bits_sequence[i];
        end    
        #(CLK_PERIOD/2) data = 1'b0;            
    endtask
    
    //Task toggling reset 
    task toggle_reset();
        reset <= ~reset;
    endtask 
    
    //Clock declaration
    always #(CLK_PERIOD/2) clk = ~clk;
    
    //Reapeting bits sequences
    always
    begin : bits_streams
        #CLK_PERIOD get_bits(8'b01010101);
        #CLK_PERIOD get_bits(8'b11000011);
        #CLK_PERIOD get_bits(8'b10000001);
    end : bits_streams
    
    //Initial variable values and resets
    initial 
    begin : initvaluse_and_resets
        clk <= 0;
        data <= 0; 
        reset <= 0;
        
        #400 toggle_reset();
        #500 toggle_reset();

        #1000 $finish;
    end : initvaluse_and_resets
            
endmodule