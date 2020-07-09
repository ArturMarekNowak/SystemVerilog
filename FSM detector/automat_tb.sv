module automat_tb;
  reg clk;                     
  reg data; 
  wire [1:0] state_out;                 
  wire out;             

  
  automat c0 ( .clk (clk),
                 .data (data),
                 .state_out (state_out),
                 .out (out));

  
  always #5 clk = ~clk;

  
  initial begin
    
    clk <= 0;
    data <= 0;
  
      
    #5 data = 1; 
    #5 data = 0; 
    #5 data = 0; 
    #5 data = 1; 
    #5 data = 0; 
    #5 data = 1; 
    #5 data = 0; 
    #5 data = 1; 
    #5 data = 0; 
    #5 data = 1; 
    #5 data = 0; 
    #5 data = 0; 
     

    #100 $finish;
  end
endmodule
