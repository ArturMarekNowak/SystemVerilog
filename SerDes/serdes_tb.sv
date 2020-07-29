`timescale 1ns / 1ps

//Module declaration
module serdes_tb;
logic pin_in, clk600, clk600_90, clk300;
logic pin_out, str;
logic [2:0] ptime;

//Declaration of clock parameters
parameter CLK_600_PERIOD = 1.67;
parameter CLK_300_PERIOD = 2*CLK_600_PERIOD;
parameter CLK_40_HALF_PERIOD = 12.5; //Declared half of period since division of parameter returned 12 not 12.5

//Declaration of time bit width parameters
parameter BIT_TIME_WIDTH_1 = 0.4;
parameter BIT_TIME_WIDTH_2 = 5;
parameter BIT_TIME_WIDTH_3 = 15;

//Declaration of multiplacation factor of bit width
parameter BIT_TIME_WIDTH_FACTOR_0 = 0.5; //Bit width equals 0.209 ns
parameter BIT_TIME_WIDTH_FACTOR_1 = 1; //Bit width equals 0.418 ns
parameter BIT_TIME_WIDTH_FACTOR_2 = 10; //Bit width equals 4.175 ns
parameter BIT_TIME_WIDTH_FACTOR_3 = 30; //Bit width equals 8.350 ns

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
    
    
    
    //Task generating desired number of bits with width which is multiplicity of 0.418ns
    task generating_bits(input integer number_of_bits, input real bit_length);
    
        //First bit in first area
        #(6.5*CLK_600_PERIOD+CLK_600_PERIOD/8) pin_in = 1;
        #(1*bit_length*CLK_600_PERIOD/4) pin_in = 0;
        
        //Further bits in second, third, ..., seventh, zeroth, first, ... areas
        for(int i = 1; i < number_of_bits; i++)
        begin : loop_of_bits
            #(10*CLK_600_PERIOD+2*(CLK_600_PERIOD/8)-1*bit_length*CLK_600_PERIOD/4) pin_in = 1;
            #(1*bit_length*CLK_600_PERIOD/4) pin_in = 0;
        end : loop_of_bits
        
    endtask
    
    
    //Task generating 40MHz clock signal on pin_in with shift 
    task generating_40MHz_clock(input integer shift);

        forever
        begin : clk_on_pin_in
            #(CLK_40_HALF_PERIOD+(shift*CLK_600_PERIOD/8)) pin_in = 1;
            #(CLK_40_HALF_PERIOD+(shift*CLK_600_PERIOD/8)) pin_in = 0;
        end : clk_on_pin_in
        
    endtask
    
    //Asynchronous toggle of pin_in
    task toggle_pin_in(input real time_value, input real time_of_bit);
        #time_value pin_in = 1;
        #time_of_bit pin_in = 0;
    endtask
    
    //Time
    task measure_time();
        @(ptime);
        if(ptime == 0)
            $display("impuls mogl nadejsc w przedziale: %f do %f ns", $realtime - 2*CLK_600_PERIOD, $realtime - 2*CLK_600_PERIOD - (CLK_300_PERIOD/8));   
        else 
            $display("impuls mogl nadejsc w przedziale: %f do %f ns", $realtime - 2*CLK_600_PERIOD - abs(abs((ptime-1)%8)-8) * (CLK_300_PERIOD/8), $realtime - 2*CLK_600_PERIOD - abs(abs((ptime)%8)-8) * (CLK_300_PERIOD/8));   
    endtask 
    
    //Calcuation of absoulute value
    function real abs(input real in); 
        if(in>= 0.0) return in;
        else return -in;
    endfunction
    
    always
    begin : time_measure
        measure_time();
    end : time_measure
     
    initial 
    begin : simulation
        
        //Declaration of variables
        int file;
        real txt, txt1;
        
        //Initial state of pin_in
        pin_in = 0;
        
        //Reading from file
        file = $fopen("D:/file.txt", "r"); //Opening file
        while (!$feof(file)) begin 
            $fscanf(file, "%f %f", txt, txt1); //Reading line
            //$display("%f, %f", txt, txt1); //Displaying
            toggle_pin_in(txt, txt1); //Toggling pin_in base on files lines
        end
        $fclose(file);
        
        
//        //Generating continuos clock of 40MHz on pin_in  
//        generating_40MHz_clock(0);
               
//        //Generating 15 bits of length 0.418ns
//        generating_bits(18,BIT_TIME_WIDTH_FACTOR_1);

//        //Spacing 
//        #(10*CLK_600_PERIOD) pin_in = 0;
        
//        //Generating 15 bits of length 4.175ns
//        generating_bits(18,BIT_TIME_WIDTH_FACTOR_2);
        
//        //Spacing 
//        #(10*CLK_600_PERIOD) pin_in = 0;
        
//        //Generating 15 bits of length 8.350 ns
//        generating_bits(18,BIT_TIME_WIDTH_FACTOR_3);

         
        #1000 $finish;
    end : simulation
    
endmodule