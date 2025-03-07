`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2024 10:45:55 PM
// Design Name: 
// Module Name: game_state_controller
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
module game_state_controller (
    input clk_i,   
    input reset,
    input collision,          
    input btnC_i,             
    input k,                   
    output reg [1:0] game_state 
);
    reg [31:0] timer; 

    // Game states
    parameter TITLE = 2'b00;    
    parameter PLAYING = 2'b10;   
    parameter GAME_OVER = 2'b11;

   
    parameter TIMER_THRESHOLD = 1_000_000_000/5;

    
    initial begin
        game_state = TITLE;
        timer = 0;
    end

    always @(posedge clk_i or posedge reset) begin
        if (reset) begin
            game_state <= TITLE; 
            timer <= 0;          
        end else begin
            case (game_state)
                TITLE: begin
                    if (btnC_i) begin
                        game_state <= PLAYING;
                        timer <= 0;          
                    end
                end

                PLAYING: begin
                    if (collision) begin
                        timer <= timer + 1; 
                        if (timer >= TIMER_THRESHOLD - 1) begin
                            game_state <= GAME_OVER; 
                            timer <= 0; 
                        end
                    end else begin
                        timer <= 0; 
                    end
                end

                GAME_OVER: begin
                    if (k) begin
                        game_state <= TITLE; 
                        timer <= 0;         
                    end
                end

                default: begin
                    game_state <= TITLE; 
                    timer <= 0;          
                end
            endcase
        end
    end
endmodule

