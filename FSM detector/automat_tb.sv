module automat_tb;
  reg clk;                     // Declare an internal TB variable called clk to drive clock to the design
  reg data; 
  wire [1:0] state_out;                  // Declare an internal TB variable called rstn to drive active low reset to design
  wire out;              // Declare a wire to connect to design output

  // Instantiate counter design and connect with Testbench variables
  automat c0 ( .clk (clk),
                 .data (data),
                 .state_out (state_out),
                 .out (out));

  // Generate a clock that should be driven to design
  // This clock will flip its value every 5ns -> time period = 10ns -> freq = 100 MHz
  always #5 clk = ~clk;

  // This initial block forms the stimulus of the testbench
  initial begin
    // 1. Initialize testbench variables to 0 at start of simulation
    clk <= 0;
    data <= 0;
    
    //for(int i=0; i<200; i++)
      //#5 data = $urandom_range(1);
      
      
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
