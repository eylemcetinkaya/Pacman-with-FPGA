`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2024 11:03:29 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input clk_i,
    input reset,
    input button_in,
    output reg button_out
);
    reg [19:0] counter;  
    reg button_ff1, button_ff2;

    always @(posedge clk_i) begin
        if (reset) begin
            button_ff1 <= 0;
            button_ff2 <= 0;
        end else begin
            button_ff1 <= button_in;
            button_ff2 <= button_ff1;
        end
    end

    always @(posedge clk_i) begin
        if (reset) begin
            counter <= 0;
            button_out <= 0;
        end else begin
            if (button_ff2 != button_out && counter == 0) begin
                counter <= 20'd50000  - 1;  
                button_out <= button_ff2;
            end else if (counter != 0) begin
                counter <= counter - 1;
            end
        end
    end
endmodule

