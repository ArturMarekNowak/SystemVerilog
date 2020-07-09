module detector (  input clk,               
                  input data,              
                  output reg [1:0] state_out,
                  output reg out);    


typedef enum {A, B, C, D} automat;
automat previous_state, next_state;

initial begin

  out <= 0;
  previous_state = A;
  state_out = 2'b00;
  
end
  

always @ (posedge clk or negedge clk) begin
    
    case (next_state)
        
        A: begin
            state_out = 2'b00;
            if (data == 1)
            begin
                next_state = B;
                previous_state = A;  
            end
          end  
           
        B: begin
            state_out = 2'b01;
            if (data == 0)
               begin
                 next_state=C;
                 previous_state=B;
               end
            
           end
           
        C: begin
            state_out = 2'b10;
            if (data == 1)
               begin
                 next_state=D;
                 previous_state=C;
               end
            else
               begin
                 next_state=A;
                 previous_state=C; 
               end
           end
           
        D: begin
            state_out = 2'b11;
            out <= ~out;
            if (data == 1)
               begin
                 next_state=B;
                 previous_state=D;
               end
            else
               begin
                 next_state=C;
                 previous_state=D; 
               end
           end
    endcase
end

endmodule
