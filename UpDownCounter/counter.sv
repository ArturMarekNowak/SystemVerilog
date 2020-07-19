interface counter_if #(BIT_WIDTH, CLK_PERIOD); //Declaration of counters interface with clock signal as input and parameters
    logic [BIT_WIDTH-1:0] in, out;             //Declaration of signal in - value loaded into counter if met conditions, and signal output 
    logic [1:0] load_value_and_if_is_up;       //Declaration of vector which controls counting up or down and with loading value or without
    logic clk, rst;                            //Declaration of reset signal and clock signal                    
endinterface                         


module counter_with_ifc #(BIT_WIDTH, CLK_PERIOD) (counter_if counterif); //Declaration of counter with an interface
    
    //Signals initial values
    initial 
    begin : starting_state             
        counterif.rst <= 0;
        counterif.load_value_and_if_is_up = 2'b00;
        counterif.in <= 0;
        counterif.out <= 0;

    end : starting_state  
    
    //Modeling sequntional flipflop logic
    always_ff @(posedge counterif.clk)
        begin : is_reset
        
            if(counterif.rst)    //If reset is on then the output equals 0 
                counterif.out <= '0;
            else
            begin : configuration_of_machine
                case (counterif.load_value_and_if_is_up)
                    
                    2'b00: counterif.out <= counterif.out - 1; //If vector eqauls 00 then counter counts down without load
                       
                    2'b01: counterif.out <= counterif.out + 1; //If vector eqauls 01 then counter counts up without load
                    
                    //If vector eqauls 10 then counter counts down with load   
                    2'b10: if(counterif.out == counterif.in)   //If counter output reaches its load value
                                counterif.out <= 2**BIT_WIDTH-1; //Load maximum value
                           else
                                counterif.out <= counterif.out - 1;     //Otherwise decrement output
                    
                    //If vector eqauls 11 then counter counts up with load   
                    2'b11: if(counterif.out == 2**BIT_WIDTH-1) //If counter output reaches its maximum 
                               counterif.out <= counterif.in;             //Load value
                           else
                               counterif.out <= counterif.out + 1;        //Otherwise increment output
                    
                    default: counterif.out <= counterif.out - 1;          //Counter counts down without load by default
                
                endcase
            end : configuration_of_machine
        end : is_reset
endmodule

//Top module declaration 
module top;
    
    //Parameters declaration
    parameter BIT_WIDTH = 4, CLK_PERIOD = 20;

    counter_if #(.BIT_WIDTH(BIT_WIDTH), .CLK_PERIOD(CLK_PERIOD)) counterif();
    
    counter_with_ifc #(.BIT_WIDTH(BIT_WIDTH), .CLK_PERIOD(CLK_PERIOD)) counter_design (counterif);
    counter_tb #(.BIT_WIDTH(BIT_WIDTH), .CLK_PERIOD(CLK_PERIOD)) tb (counterif);

endmodule : top   