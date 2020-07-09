module tb_counter;
  reg clk;                     // Declare an internal TB variable called clk to drive clock to the design
  reg ctrl;
  reg rstn;                    // Declare an internal TB variable called rstn to drive active low reset to design
  wire [2:0] out;              // Declare a wire to connect to design output

  // Instantiate counter design and connect with Testbench variables
  counter   c0 ( .clk (clk),
                 .ctrl (ctrl),
                 .rstn (rstn),
                 .out (out));

  // Generate a clock that should be driven to design
  // This clock will flip its value every 5ns -> time period = 10ns -> freq = 100 MHz
  always #5 clk = ~clk;

  // This initial block forms the stimulus of the testbench
  initial begin
    // 1. Initialize testbench variables to 0 at start of simulation
    clk <= 0;
    rstn <= 0;
    ctrl <= 0;

    // 2. Drive rest of the stimulus, reset is asserted in between
    #200   rstn <= 1;

    #40 ctrl <= 1;
    #80 ctrl <= 0;

    #200   rstn <= 0;

    // 3. Finish the stimulus after 400ns
    #1000 $finish;
  end
endmodule








//// Code your testbench here
//// or browse Examples
////testbench

//`timescale 1ns/1ns

//module Counter_4bit_tb;

// logic reset;
// logic CLK;
//  logic [3:0] out;

// Counter_4bit TestCounter (	.CLK(CLK),
//				.reset(reset),
//				.out(out) );

// initial 
//  begin
//   reset <= 0; 
//   CLK <= 0; 
//   #10 reset <= 1;
//   #20 reset <= 0;
//   #200 $finish;
//  end

// always 
//  begin 
//   CLK <= 1; #5;
//   CLK <= 0; #5;
//  end 

//endmodule	