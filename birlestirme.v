`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2024 01:57:25 PM
// Design Name: 
// Module Name: birlestirme
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
module birlestime(
    input clk_i,            
    input reset,             
    input btnC_i,            
    input btnU_i,            
    input btnD_i,            
    input btnL_i,            
    input btnR_i, 
    input k,           
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Hsync,
    output Vsync
);

    
    wire  [5:0] puan;
    wire  [3:0] boncuk_x;
    wire  [3:0] boncuk_y;
    wire [3:0] pacman_x;    
    wire [3:0] pacman_y;    
    wire [3:0] ghost_x;     
    wire [3:0] ghost_y;     
     wire collision1;
    wire up_debounced, down_debounced, left_debounced, right_debounced;
    wire [1:0] game_state;

   
    debouncer debounce_up (
        .clk_i(clk_i),
        .reset(reset),
        .button_in(btnU_i),
        .button_out(up_debounced)
    );

    debouncer debounce_down (
        .clk_i(clk_i),
        .reset(reset),
        .button_in(btnD_i),
        .button_out(down_debounced)
    );

    debouncer debounce_left (
        .clk_i(clk_i),
        .reset(reset),
        .button_in(btnL_i),
        .button_out(left_debounced)
    );

    debouncer debounce_right (
        .clk_i(clk_i),
        .reset(reset),
        .button_in(btnR_i),
        .button_out(right_debounced)
    );

    
    game_state_controller state_ctrl (
        .clk_i(clk_i),
        .k(k),
        .reset(reset),
        .collision(collision1), 
        .btnC_i(btnC_i),
        .game_state(game_state) 
    );

    pacman_movement pacman (
        .clk_i(clk_i),
        .reset(reset || (game_state != 2'b10)),  
        .btnU_i((game_state == 2'b10) ? up_debounced : 1'b0),
        .btnD_i((game_state == 2'b10) ? down_debounced : 1'b0),
        .btnL_i((game_state == 2'b10) ? left_debounced : 1'b0),
        .btnR_i((game_state == 2'b10) ? right_debounced : 1'b0),
        .pacman_x(pacman_x),
        .pacman_y(pacman_y)
    );

    ghost_module1 ghost (
        .clk_i(clk_i),
        .reset(reset || (game_state != 2'b10)), 
        .pacman_x(pacman_x),
        .pacman_y(pacman_y),
        .collision(collision1),
        .ghost_x(ghost_x),
        .ghost_y(ghost_y)
    );

    boncuk bonc(
    .clk_i(clk_i),
    .reset(reset),
    .pacman_y(pacman_y),
    .pacman_x(pacman_x),
    .puan(puan)
    );
    // VGA module
    vga vga (
        .clk_i_100MHz(clk_i),
        .reset(reset),
        .game_state(game_state),  
        .pacman_x(pacman_x),
        .pacman_y(pacman_y),
        .ghost1_x(ghost_x),
        .ghost1_y(ghost_y),
        .puan(puan),
        .vgaRed(vgaRed),
        .vgaGreen(vgaGreen),
        .vgaBlue(vgaBlue),
        .Hsync(Hsync),
        .Vsync(Vsync)
    );

endmodule

        