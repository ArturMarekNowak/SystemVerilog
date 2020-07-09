`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2020 13:15:59
// Design Name: 
// Module Name: barrelshifter_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module barrelshifter_tb;
    reg clk;
    reg reset;
    reg is_shift_right;
    reg shift_value;
    reg data;
    wire [1:32] shifted_data;

 barrelshifter c0 (
        .clk (clk), 
        .reset (reset),
        .is_shift_right (is_shift_right),
        .shift_value (shift_value),
        .data (data),
        .shifted_data (shifted_data)
    );
    
always #5 clk = ~clk;

initial 
begin

    data = 32'b1100000;
    
    #50 shift_value = 4'b1;
    #10 is_shift_right = 1;
    #10 shift_value = 1; 
    #10 is_shift_right = 0;
    

    #50 shift_value = 3;
    #10 is_shift_right = 1;
    #10 shift_value = 3; 
    #10 is_shift_right = 0;
    
    #50 reset = 1;
    #10 shift_value = 3;
    #10 is_shift_right = 1;
    #10 shift_value = 3; 
    #10 is_shift_right = 0;
    
    #50 reset = 0;
    #10 shift_value = 10;
    #10 is_shift_right = 1;
    #10 shift_value = 10; 
    #10 is_shift_right = 0;
    
    #50 shift_value = 10;
    #10 is_shift_right = 1;
    #10 shift_value = 15; 
    #10 is_shift_right = 0;
    
    #1000 $finish; 
    
end

endmodule
