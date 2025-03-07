`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/14/2024 01:58:27 PM
// Design Name: 
// Module Name: pacman_movement
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


module pacman_movement(
 input clk_i,
    input reset,
    input  btnU_i,       
    input  btnD_i,     
    input  btnL_i,     
    input  btnR_i,    
    output reg [9:0] pacman_x, 
    output reg [9:0] pacman_y 
    );
     reg [25:0] counter_U;
     reg [25:0] counter_next_U; 
     
       reg [25:0] counter_L;
     reg [25:0] counter_next_L; 
     
       reg [25:0] counter_R;
     reg [25:0] counter_next_R; 
       reg [25:0] counter_D;
     reg [25:0] counter_next_D; 
   reg [1:0] map [0:9][0:9];
    localparam ROWS = 10, COLS = 10, WALL = 1, PATH = 0;
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

    
    map[2][2] = WALL; map[2][3] = WALL; map[2][4] = WALL;
    map[4][2] = WALL; map[4][3] = WALL; map[4][4] = WALL;
    map[6][2] = WALL; map[6][3] = WALL; map[6][4] = WALL;
        map[4][6]= WALL; map[7][7]=WALL;
    
end
reg [9:0] next_x;
reg [9:0] next_y;
 always @(*) begin
        counter_next_U =counter_U;
        counter_next_D =counter_D;
        counter_next_L =counter_L;
        counter_next_R =counter_R;

        next_x = pacman_x;
        next_y = pacman_y;
        
        if (btnU_i && map[pacman_y - 1][pacman_x] != WALL)
           // next_y = pacman_y - 1; 
           counter_next_U= counter_U +1;
        else if (btnD_i && map[pacman_y + 1][pacman_x] != WALL)
          // next_y = pacman_y + 1;  
             counter_next_D= counter_D +1;
        else if (btnL_i && map[pacman_y][pacman_x - 1] != WALL)
          // next_x = pacman_x - 1;  
                      counter_next_L= counter_L +1;
        else if (btnR_i && map[pacman_y][pacman_x + 1] != WALL)
           // next_x = pacman_x + 1;  
                     counter_next_R= counter_R +1;
    
        if(counter_U==25'd50000 - 1) begin
            next_y = pacman_y - 1;
         end
        if(counter_D==25'd50000 - 1) begin
            next_y = pacman_y + 1;
         end
        if(counter_L==25'd50000 - 1) begin
            next_x = pacman_x - 1;
         end
        if(counter_R==25'd50000 - 1) begin
            next_x = pacman_x + 1;
         end
    
    end
     always @(posedge clk_i or posedge reset ) begin
        if (reset) begin
            pacman_x <= 5; 
            pacman_y <= 5;
            counter_L<=0;
            counter_U<=0;
            counter_R<=0;
            counter_D<=0;
        end else begin
            pacman_x <= next_x;
            pacman_y <= next_y;
            counter_L<=counter_next_L;
            counter_U<=counter_next_U;
            counter_R<=counter_next_R;
            counter_D<=counter_next_D;

        end
    end
endmodule
