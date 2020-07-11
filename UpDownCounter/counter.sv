interface counter_if(input bit clk); //Declaration of counters interface with clock signal as input
    logic [2:0] in, out;             //Declaration of signal in - value loaded into counter if signal load == 1 and an output register
    logic rst, load, is_up;          //Declaration of reset signal, load control signal (if load == 1 value is loaded into counter)
endinterface                         //Declaration of is_up control signal (if is_up == 1 counter counts up)


module counter_with_ifc(counter_if counterif); //Declaration of counter with an interface

initial begin              //Signals initial values
    counterif.rst <= 0;
    counterif.load <= 0;
    counterif.in <= 0;
    counterif.out <= 0;
    counterif.is_up <= 0;
end

    //Modeling sequntional flipflop logic
    always_ff @(posedge counterif.clk or posedge counterif.rst)
        begin
            if(counterif.rst)    //If reset is on outpu equals 0 
                counterif.out <= '0;
            else
                if(counterif.load && counterif.is_up)    //If load control is true and is_up control is true
                    begin
                        if(counterif.out == 2**$bits(counterif.out)-1) //If counter output reaches its maximum 
                            counterif.out <= counterif.in;             //Load value
                        else
                            counterif.out <= counterif.out + 1;        //Otherwise increment output
                        end
                else if(counterif.load && !counterif.is_up)  //If load control is true and is_up control is false
                    begin
                        if(counterif.out == counterif.in)   //If counter output reaches its load value
                            counterif.out <= 2**$bits(counterif.out)-1; //Load maximum value
                        else
                            counterif.out <= counterif.out - 1;     //Otherwise decrement output
                        end
                else if(!counterif.load && counterif.is_up) //If load control is false and is_up control is true
                    counterif.out <= counterif.out + 1;     //Increment output
                else
                    counterif.out <= counterif.out - 1;     //Otherwise decrement output
        end
endmodule

//Top module declaration 
module top;
    bit clk;
    always #5 clk = ~clk;

    counter_if counterif(clk);
    counter_with_ifc a1(counterif);
    counter_tb b1(counterif);
endmodule : top   