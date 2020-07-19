module FSM (  input logic clk,       //Declaration of logical input - clock signal
              input logic data,      //Declaration of logical input - data signal - bits passed one by one into sequence detector   
              input logic reset,     //Declaration of logical input - reset signal
              output logic out);     //Declaration of logical output - out singal - confirmation of detection of correct sequnce (101)

    //Definition of machine's states
    typedef enum logic [1:0] {NONE_CORRECT, ONE_CORRECT, TWO_CORRECT, THREE_CORRECT} State;
    
    //Declaration of variables holding current state of machine and next state of machine
    State current_state, next_state;
    

    //Modeling sequntional flipflop logic
    always_ff @(posedge clk or negedge reset) 
    begin : reset_and_states_behaviour
    
        if(!reset) current_state <= NONE_CORRECT;  //If reset active hold default state
        else current_state <= next_state;         //If reset inactive continue assigning to current state the next state
    
    end : reset_and_states_behaviour
    
    //Combinaional logic
    always_comb 
    begin : states    
    
        //Moving through states according to machine diagram
        case (current_state)
            
            NONE_CORRECT: if(data) next_state = ONE_CORRECT;
                          else next_state = NONE_CORRECT;
               
            ONE_CORRECT: if(!data) next_state = TWO_CORRECT;
                         else next_state = ONE_CORRECT;
               
            TWO_CORRECT: if(data) next_state = THREE_CORRECT;
                         else next_state = NONE_CORRECT;
               
            THREE_CORRECT: if(data) next_state = ONE_CORRECT; 
                           else next_state = TWO_CORRECT;
            
            default: next_state = NONE_CORRECT;
            
        endcase       
     end : states
        

    //Assign output if all three bits are matching the sequnce we are looking for
    assign out = (current_state == THREE_CORRECT);
    
endmodule
