`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/15/2024 07:44:56 PM
// Design Name: 
// Module Name: ghost_module1
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
module ghost_module1(
    input  clk_i,            
    input  reset,      
    input  [9:0] pacman_x,  
    input  [9:0] pacman_y,  
    output reg [3:0] ghost_x,
    output reg [3:0] ghost_y, 
    output reg collision    
); 
reg move_flag;
 parameter TITLE = 2'b00;    
  parameter PLAYING = 2'b10;   
     parameter GAME_OVER = 2'b11;
reg collision_next;
    
    localparam SPAWN_X = 3;
    localparam SPAWN_Y = 3;
    localparam ROWS = 10, COLS = 10, WALL = 1, PATH = 0;
    localparam MOVE_DELAY = 90000000; 

    
reg [1:0] map [0:9][0:9];
reg [28:0] move_timer;
integer i,j;
initial begin
    
    for (i = 0; i < 10; i = i + 1) begin
        for (j = 0; j < 10; j = j + 1) begin
            map[i][j] = PATH;
        end
    end

  
    for (i = 0; i < 10; i = i + 1) begin
        map[0][i] = WALL;  
        map[9][i] = WALL;  
    end

 
    for (i = 0; i < 10; i = i + 1) begin
        map[i][0] = WALL; 
        map[i][9] = WALL; 
    end

    // Internal maze walls
    map[2][2] = WALL; map[2][3] = WALL; map[2][4] = WALL;
    map[4][2] = WALL; map[4][3] = WALL; map[4][4] = WALL;
    map[6][2] = WALL; map[6][3] = WALL; map[6][4] = WALL;
        map[4][6]= WALL; map[7][7]=WALL;

    
    
end

    
    always @* begin
        collision_next = (ghost_x == pacman_x) && (ghost_y == pacman_y);
    end

  
 reg [9:0] prev_x, prev_y;
 reg position_changed;
    
    always @(posedge clk_i or posedge reset) begin
        if (reset) begin
            ghost_x <= SPAWN_X;
            ghost_y <= SPAWN_Y;
            move_timer <= 0;
             move_flag <= 0;
            collision <= 0;
            position_changed <= 0;
        end else begin
            collision <= collision_next;
            position_changed <= 0; 
            
            if (move_timer < MOVE_DELAY) begin
                move_timer <= move_timer + 1;
                move_flag <= 0;
            end else begin
                move_timer <= 0;
                   move_flag <= 1;
                
             
                prev_x = ghost_x;
                prev_y = ghost_y;
                
                
                if (ghost_x < pacman_x && map[ghost_y][ghost_x + 1] != WALL) begin
                    ghost_x <= ghost_x + 1;
                end else if (ghost_x > pacman_x && map[ghost_y][ghost_x - 1] != WALL) begin
                    ghost_x <= ghost_x - 1;
                end else if (ghost_y < pacman_y && map[ghost_y + 1][ghost_x] != WALL) begin
                    ghost_y <= ghost_y + 1;
                end else if (ghost_y > pacman_y && map[ghost_y - 1][ghost_x] != WALL) begin
                    ghost_y <= ghost_y - 1;
                end
                
                position_changed <= (prev_x != ghost_x) || (prev_y != ghost_y);
            end
        end
    end
endmodule