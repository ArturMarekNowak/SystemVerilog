`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2020 13:15:40
// Design Name: 
// Module Name: barrelshifter
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


module barrelshifter(
        input clk, 
        input reset,
        input is_shift_right,
        input reg[3:0] shift_value,
        input logic [1:32] data,
        output logic [1:32] shifted_data
    );
    
initial begin
  
  shifted_data <= 0;
  
end
    
   always @ (posedge clk or negedge clk) begin

      if (reset)
        shifted_data <= 0;
      else    
        if (is_shift_right)
            begin
                shifted_data <= data>>shift_value;
                shift_value = 0; 
            end
        else 
            begin
                shifted_data <= data<<shift_value;
                shift_value = 0; 
            end
      end 
    
endmodule
