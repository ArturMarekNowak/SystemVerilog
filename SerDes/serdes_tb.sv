`timescale 1ns / 1ps

//Module declaration
module serdes_tb;
logic pin_in, clk600, clk600_90, clk300;
logic pin_out, str;
logic [2:0] ptime;

//Declaration of parameters
parameter CLK_600_PERIOD = 1.67;
parameter CLK_300_PERIOD = 2*CLK_600_PERIOD;
parameter BIT_TIME_WIDTH_1 = 0.4;
parameter BIT_TIME_WIDTH_2 = 5;
parameter BIT_TIME_WIDTH_3 = 15;

//Connections
pin_capt dut(    .pin_in (pin_in),
                 .pin_out (pin_out),
                 .clk600 (clk600),
                 .clk600_90 (clk600_90),
                 .clk300 (clk300),
                 .str (str),
                 .ptime (ptime)
);
              
    //Generating clock signal of frequency 600MHz                     
    initial 
    begin : clock_600MHz
    
        clk600 = 0;
        forever #(CLK_600_PERIOD/2) clk600 = ~clk600 ;
        
    end : clock_600MHz
    
    //Generating clock signal of frequency 600MHz phase shifted                    
    initial 
    begin : clock_600MHz_phase_shifted
    
        clk600_90 = 1;
        #(CLK_600_PERIOD/4) clk600_90 = 0;
        forever #(CLK_600_PERIOD/2) clk600_90 = ~clk600_90 ;
        
    end : clock_600MHz_phase_shifted
    
    //Generating clock signal of frequency 300MHz                     
    initial 
    begin : clock_300MHz
    
        clk300 = 0;
        #(CLK_600_PERIOD/2) clk300 = 1;
        forever #(CLK_300_PERIOD/2) clk300 = ~clk300 ;
        
    end : clock_300MHz
     
     
    //Task generating random bits on input based on chosen bit width
    task random_bits();
      pin_in = 0;
      forever #BIT_TIME_WIDTH_1 pin_in = $urandom_range(0, 1);
    endtask 
    
    //Task toggling input with duty cycle 50% based on chosen bit width
    task ones_and_zeros();
      forever #BIT_TIME_WIDTH_1 pin_in = ~pin_in;
    endtask 
    
    
    task generating_bits(input integer number_of_bits, input integer bit_length);
    
        #(6.5*CLK_600_PERIOD+CLK_600_PERIOD/8) pin_in = 1;
        #(1*bit_length*CLK_600_PERIOD/4) pin_in = 0;
        
        
        for(int i = 1; i < number_of_bits; i++)
        begin : loop
            #(10*CLK_600_PERIOD+2*(CLK_600_PERIOD/8)-1*bit_length*CLK_600_PERIOD/4) pin_in = 1;
            #(1*bit_length*CLK_600_PERIOD/4) pin_in = 0;
        end
        
    endtask
     
    initial 
    begin : simulation
        
        pin_in = 0;
        
        //random_bits();
//        #(7.5*CLK_600_PERIOD-0.9) pin_in = 1;
//        #(3*CLK_600_PERIOD/4) pin_in = 0;
        
//        #(2*CLK_600_PERIOD-0.9) pin_in = 1;
//        #(1*CLK_600_PERIOD/4) pin_in = 0;
        
//        #(1*CLK_600_PERIOD-0.9) pin_in = 1;
//        #(1*CLK_600_PERIOD/4) pin_in = 0;
        
        generating_bits(30,20);
        
        
        #1000 $finish;
    end : simulation
    
endmodule