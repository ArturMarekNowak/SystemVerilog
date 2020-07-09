module counter (  input clk,               
                  input ctrl,
                  input rstn,              
                  output reg[2:0] out);    

  initial begin
  
  out <= 0;
  
  end
  
  
  always @ (posedge clk or negedge clk) begin

      if (rstn)
        out <= 0;
      else    
        if (ctrl)
            out <= out - 1;
        else 
           out <= out + 1;
      end
 
endmodule


