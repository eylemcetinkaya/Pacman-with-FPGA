`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/16/2024 10:26:31 PM
// Design Name: 
// Module Name: vga
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
module vga(
    input clk_i_100MHz,
    input reset,
    input [1:0] game_state,
    input [3:0] pacman_x,
    input [3:0] pacman_y,
    input [3:0] ghost1_x,
    input [3:0] ghost1_y,
    input [5:0] puan,
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue,
    output reg Hsync,
    output reg Vsync
);
integer i,j;
    reg  dot_visible[9:0][9:0] ; 
      reg [5:0] puan_next;
    // Clock divider for 25MHz
    reg [1:0] clk_i_div;
    wire clk_i_25MHz;
    


    always @(posedge clk_i_100MHz or posedge reset) begin
        if (reset)
            clk_i_div <= 0;
        else 
            clk_i_div <= clk_i_div + 1;
    end

    assign clk_i_25MHz = clk_i_div[1];

    parameter TITLE = 2'b00, PLAYING = 2'b10, GAME_OVER = 2'b11;

    // VGA 640x480 timing parameters
    parameter H_DISPLAY = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_SYNC_PULSE = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_TOTAL = 800;

    parameter V_DISPLAY = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_SYNC_PULSE = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_TOTAL = 525;

    // Game display parameters
    parameter CELL_SIZE = 20;
    parameter GAME_OFFSET_X = 200;
    parameter GAME_OFFSET_Y = 100;

    // Colors
    parameter [11:0] BLACK = 12'h000;
    parameter [11:0] WHITE = 12'hFFF;
    parameter [11:0] BLUE = 12'h00F;
    parameter [11:0] YELLOW = 12'hFF0;
    parameter [11:0] RED = 12'hF00;
    parameter [11:0] WALL_COLOR = 12'h44F;
    parameter [11:0] DOT_COLOR = 12'hFFF;
    parameter [11:0] COLLISION_COLOR = 12'h0F0; // Green for collision

    // Counters for VGA timing
    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    // Current pixel position
    wire [9:0] x_pos = h_count - (H_SYNC_PULSE + H_BACK_PORCH);
    wire [9:0] y_pos = v_count - (V_SYNC_PULSE + V_BACK_PORCH);

    reg [1:0] map [0:9][0:9];
    parameter WALL = 2'b11, PATH = 2'b00, DOT = 2'b01;
    wire [31:0] board_x = (x_pos - GAME_OFFSET_X) / CELL_SIZE;
    wire [31:0] board_y = (y_pos - GAME_OFFSET_Y) / CELL_SIZE;
    wire [31:0] cell_x = (x_pos - GAME_OFFSET_X) % CELL_SIZE;
    wire [31:0] cell_y = (y_pos - GAME_OFFSET_Y) % CELL_SIZE;
    reg [7:0] number_pattern [0:9][0:15];
    reg [7:0] letter_pattern [0:9][0:15];

        // MAP
 
initial begin
    for (i = 0; i < 10; i = i + 1) begin
        for (j = 0; j < 10; j = j + 1) begin
            map[i][j] = PATH;
        end
    end
    for (i = 1; i < 9; i = i + 1) begin
        for (j = 1; j < 9; j = j + 1) begin
            map[i][j] = DOT;
        end
    end
    for (i = 0; i < 10; i = i + 1) begin
        for (j = 0; j < 10; j = j + 1) begin
            dot_visible[i][j] = 1;
        end
    end
    for (i = 0; i < 10; i = i + 1) begin
        map[0][i] = WALL;  // Top border
        map[9][i] = WALL;  // Bottom border
    end

    // Left and right borders
    for (i = 0; i < 10; i = i + 1) begin
        map[i][0] = WALL;  // Left border
        map[i][9] = WALL;  // Right border
    end

    // Internal maze walls
    map[2][2] = WALL; map[2][3] = WALL; map[2][4] = WALL;
    map[4][2] = WALL; map[4][3] = WALL; map[4][4] = WALL;
    map[6][2] = WALL; map[6][3] = WALL; map[6][4] = WALL;
    map[4][6]= WALL; map[7][7]=WALL;
    // 0
    number_pattern[0][0]  = 8'b00000000;
    number_pattern[0][1]  = 8'b00000000;
    number_pattern[0][2]  = 8'b00111000;
    number_pattern[0][3]  = 8'b01101100;
    number_pattern[0][4]  = 8'b11000110;
    number_pattern[0][5]  = 8'b11000110;
    number_pattern[0][6]  = 8'b11000110;
    number_pattern[0][7]  = 8'b11000110;
    number_pattern[0][8]  = 8'b11000110;
    number_pattern[0][9]  = 8'b11000110;
    number_pattern[0][10] = 8'b01101100;
    number_pattern[0][11] = 8'b00111000;
    number_pattern[0][12] = 8'b00000000;
    number_pattern[0][13] = 8'b00000000;
    number_pattern[0][14] = 8'b00000000;
    number_pattern[0][15] = 8'b00000000;
    //1
    number_pattern[1][0]  = 8'b00000000;
    number_pattern[1][1]  = 8'b00000000;
    number_pattern[1][2]  = 8'b00011000;
    number_pattern[1][3]  = 8'b00111000;
    number_pattern[1][4]  = 8'b01111000;
    number_pattern[1][5]  = 8'b00011000;
    number_pattern[1][6]  = 8'b00011000;
    number_pattern[1][7]  = 8'b00011000;
    number_pattern[1][8]  = 8'b00011000;
    number_pattern[1][9]  = 8'b00011000;
    number_pattern[1][10] = 8'b01111110;
    number_pattern[1][11] = 8'b01111110;
    number_pattern[1][12] = 8'b00000000;
    number_pattern[1][13] = 8'b00000000;
    number_pattern[1][14] = 8'b00000000;
    number_pattern[1][15] = 8'b00000000;

    // Pattern for 2
    number_pattern[2][0]  = 8'b00000000;
    number_pattern[2][1]  = 8'b00000000;
    number_pattern[2][2]  = 8'b11111110;
    number_pattern[2][3]  = 8'b11111110;
    number_pattern[2][4]  = 8'b00000110;
    number_pattern[2][5]  = 8'b00000110;
    number_pattern[2][6]  = 8'b11111110;
    number_pattern[2][7]  = 8'b11111110;
    number_pattern[2][8]  = 8'b11000000;
    number_pattern[2][9]  = 8'b11000000;
    number_pattern[2][10] = 8'b11111110;
    number_pattern[2][11] = 8'b11111110;
    number_pattern[2][12] = 8'b00000000;
    number_pattern[2][13] = 8'b00000000;
    number_pattern[2][14] = 8'b00000000;
    number_pattern[2][15] = 8'b00000000;

    // Pattern for 3
    number_pattern[3][0]  = 8'b00000000;
    number_pattern[3][1]  = 8'b00000000;
    number_pattern[3][2]  = 8'b11111110;
    number_pattern[3][3]  = 8'b11111110;
    number_pattern[3][4]  = 8'b00000110;
    number_pattern[3][5]  = 8'b00000110;
    number_pattern[3][6]  = 8'b00111110;
    number_pattern[3][7]  = 8'b00111110;
    number_pattern[3][8]  = 8'b00000110;
    number_pattern[3][9]  = 8'b00000110;
    number_pattern[3][10] = 8'b11111110;
    number_pattern[3][11] = 8'b11111110;
    number_pattern[3][12] = 8'b00000000;
    number_pattern[3][13] = 8'b00000000;
    number_pattern[3][14] = 8'b00000000;
    number_pattern[3][15] = 8'b00000000;

    // Pattern for 4
    number_pattern[4][0]  = 8'b00000000;
    number_pattern[4][1]  = 8'b00000000;
    number_pattern[4][2]  = 8'b11000110;
    number_pattern[4][3]  = 8'b11000110;
    number_pattern[4][4]  = 8'b11000110;
    number_pattern[4][5]  = 8'b11000110;
    number_pattern[4][6]  = 8'b11111110;
    number_pattern[4][7]  = 8'b11111110;
    number_pattern[4][8]  = 8'b00000110;
    number_pattern[4][9]  = 8'b00000110;
    number_pattern[4][10] = 8'b00000110;
    number_pattern[4][11] = 8'b00000110;
    number_pattern[4][12] = 8'b00000000;
    number_pattern[4][13] = 8'b00000000;
    number_pattern[4][14] = 8'b00000000;
    number_pattern[4][15] = 8'b00000000;

    // Pattern for 5
    number_pattern[5][0]  = 8'b00000000;
    number_pattern[5][1]  = 8'b00000000;
    number_pattern[5][2]  = 8'b11111110;
    number_pattern[5][3]  = 8'b11111110;
    number_pattern[5][4]  = 8'b11000000;
    number_pattern[5][5]  = 8'b11000000;
    number_pattern[5][6]  = 8'b11111110;
    number_pattern[5][7]  = 8'b11111110;
    number_pattern[5][8]  = 8'b00000110;
    number_pattern[5][9]  = 8'b00000110;
    number_pattern[5][10] = 8'b11111110;
    number_pattern[5][11] = 8'b11111110;
    number_pattern[5][12] = 8'b00000000;
    number_pattern[5][13] = 8'b00000000;
    number_pattern[5][14] = 8'b00000000;
    number_pattern[5][15] = 8'b00000000;

    // Pattern for 6
    number_pattern[6][0]  = 8'b00000000;
    number_pattern[6][1]  = 8'b00000000;
    number_pattern[6][2]  = 8'b11111110;
    number_pattern[6][3]  = 8'b11111110;
    number_pattern[6][4]  = 8'b11000000;
    number_pattern[6][5]  = 8'b11000000;
    number_pattern[6][6]  = 8'b11111110;
    number_pattern[6][7]  = 8'b11111110;
    number_pattern[6][8]  = 8'b11000110;
    number_pattern[6][9]  = 8'b11000110;
    number_pattern[6][10] = 8'b11111110;
    number_pattern[6][11] = 8'b11111110;
    number_pattern[6][12] = 8'b00000000;
    number_pattern[6][13] = 8'b00000000;
    number_pattern[6][14] = 8'b00000000;
    number_pattern[6][15] = 8'b00000000;

    // Pattern for 7
    number_pattern[7][0]  = 8'b00000000;
    number_pattern[7][1]  = 8'b00000000;
    number_pattern[7][2]  = 8'b11111110;
    number_pattern[7][3]  = 8'b11111110;
    number_pattern[7][4]  = 8'b00000110;
    number_pattern[7][5]  = 8'b00000110;
    number_pattern[7][6]  = 8'b00000110;
    number_pattern[7][7]  = 8'b00000110;
    number_pattern[7][8]  = 8'b00000110;
    number_pattern[7][9]  = 8'b00000110;
    number_pattern[7][10] = 8'b00000110;
    number_pattern[7][11] = 8'b00000110;
    number_pattern[7][12] = 8'b00000000;
    number_pattern[7][13] = 8'b00000000;
    number_pattern[7][14] = 8'b00000000;
    number_pattern[7][15] = 8'b00000000;

    // Pattern for 8
    number_pattern[8][0]  = 8'b00000000;
    number_pattern[8][1]  = 8'b00000000;
    number_pattern[8][2]  = 8'b11111110;
    number_pattern[8][3]  = 8'b11111110;
    number_pattern[8][4]  = 8'b11000110;
    number_pattern[8][5]  = 8'b11000110;
    number_pattern[8][6]  = 8'b11111110;
    number_pattern[8][7]  = 8'b11111110;
    number_pattern[8][8]  = 8'b11000110;
    number_pattern[8][9]  = 8'b11000110;
    number_pattern[8][10] = 8'b11111110;
    number_pattern[8][11] = 8'b11111110;
    number_pattern[8][12] = 8'b00000000;
    number_pattern[8][13] = 8'b00000000;
    number_pattern[8][14] = 8'b00000000;
    number_pattern[8][15] = 8'b00000000;

    // Pattern for 9
    number_pattern[9][0]  = 8'b00000000;
    number_pattern[9][1]  = 8'b00000000;
    number_pattern[9][2]  = 8'b11111110;
    number_pattern[9][3]  = 8'b11111110;
    number_pattern[9][4]  = 8'b11000110;
    number_pattern[9][5]  = 8'b11000110;
    number_pattern[9][6]  = 8'b11111110;
    number_pattern[9][7]  = 8'b11111110;
    number_pattern[9][8]  = 8'b00000110;
    number_pattern[9][9]  = 8'b00000110;
    number_pattern[9][10] = 8'b11111110;
    number_pattern[9][11] = 8'b11111110;
    number_pattern[9][12] = 8'b00000000;
    number_pattern[9][13] = 8'b00000000;
    number_pattern[9][14] = 8'b00000000;
    number_pattern[9][15] = 8'b00000000;
    
    // Letter A
        letter_pattern[0][0]  = 8'b00000000;
        letter_pattern[0][1]  = 8'b00000000;
        letter_pattern[0][2]  = 8'b00010000;
        letter_pattern[0][3]  = 8'b00111000;
        letter_pattern[0][4]  = 8'b01101100;
        letter_pattern[0][5]  = 8'b11000110;
        letter_pattern[0][6]  = 8'b11000110;
        letter_pattern[0][7]  = 8'b11111110;
        letter_pattern[0][8]  = 8'b11111110;
        letter_pattern[0][9]  = 8'b11000110;
        letter_pattern[0][10] = 8'b11000110;
        letter_pattern[0][11] = 8'b11000110;
        letter_pattern[0][12] = 8'b00000000;
        letter_pattern[0][13] = 8'b00000000;
        letter_pattern[0][14] = 8'b00000000;
        letter_pattern[0][15] = 8'b00000000;
        
        // Letter P
        letter_pattern[1][0]  = 8'b00000000;
        letter_pattern[1][1]  = 8'b00000000;
        letter_pattern[1][2]  = 8'b11111100;
        letter_pattern[1][3]  = 8'b11111110;
        letter_pattern[1][4]  = 8'b11000110;
        letter_pattern[1][5]  = 8'b11000110;
        letter_pattern[1][6]  = 8'b11111110;
        letter_pattern[1][7]  = 8'b11111100;
        letter_pattern[1][8]  = 8'b11000000;
        letter_pattern[1][9]  = 8'b11000000;
        letter_pattern[1][10] = 8'b11000000;
        letter_pattern[1][11] = 8'b11000000;
        letter_pattern[1][12] = 8'b00000000;
        letter_pattern[1][13] = 8'b00000000;
        letter_pattern[1][14] = 8'b00000000;
        letter_pattern[1][15] = 8'b00000000;
        
        // Letter M
        letter_pattern[2][0]  = 8'b00000000;
        letter_pattern[2][1]  = 8'b00000000;
        letter_pattern[2][2]  = 8'b11000110;
        letter_pattern[2][3]  = 8'b11000110;
        letter_pattern[2][4]  = 8'b11101110;
        letter_pattern[2][5]  = 8'b11111110;
        letter_pattern[2][6]  = 8'b11010110;
        letter_pattern[2][7]  = 8'b11000110;
        letter_pattern[2][8]  = 8'b11000110;
        letter_pattern[2][9]  = 8'b11000110;
        letter_pattern[2][10] = 8'b11000110;
        letter_pattern[2][11] = 8'b11000110;
        letter_pattern[2][12] = 8'b00000000;
        letter_pattern[2][13] = 8'b00000000;
        letter_pattern[2][14] = 8'b00000000;
        letter_pattern[2][15] = 8'b00000000;
        
        //C
        letter_pattern[3][0]  = 8'b00000000;
        letter_pattern[3][1]  = 8'b00000000;
        letter_pattern[3][2]  = 8'b01111100;
        letter_pattern[3][3]  = 8'b11111110;
        letter_pattern[3][4]  = 8'b11000000;
        letter_pattern[3][5]  = 8'b11000000;
        letter_pattern[3][6]  = 8'b11000000;
        letter_pattern[3][7]  = 8'b11000000;
        letter_pattern[3][8]  = 8'b11000000;
        letter_pattern[3][9]  = 8'b11000000;
        letter_pattern[3][10] = 8'b11111110;
        letter_pattern[3][11] = 8'b01111100;
        letter_pattern[3][12] = 8'b00000000;
        letter_pattern[3][13] = 8'b00000000;
        letter_pattern[3][14] = 8'b00000000;
        letter_pattern[3][15] = 8'b00000000;
        //N
        letter_pattern[4][0]  = 8'b00000000;
        letter_pattern[4][1]  = 8'b00000000;
        letter_pattern[4][2]  = 8'b11000110;
        letter_pattern[4][3]  = 8'b11000110;
        letter_pattern[4][4]  = 8'b11100110;
        letter_pattern[4][5]  = 8'b11110110;
        letter_pattern[4][6]  = 8'b11111110;
        letter_pattern[4][7]  = 8'b11011110;
        letter_pattern[4][8]  = 8'b11001110;
        letter_pattern[4][9]  = 8'b11000110;
        letter_pattern[4][10] = 8'b11000110;
        letter_pattern[4][11] = 8'b11000110;
        letter_pattern[4][12] = 8'b00000000;
        letter_pattern[4][13] = 8'b00000000;
        letter_pattern[4][14] = 8'b00000000;
        letter_pattern[4][15] = 8'b00000000;
        // o 
        letter_pattern[5][0]  = 8'b00000000;
        letter_pattern[5][1]  = 8'b00000000;
        letter_pattern[5][2]  = 8'b01111100;
        letter_pattern[5][3]  = 8'b11111110;
        letter_pattern[5][4]  = 8'b11000110;
        letter_pattern[5][5]  = 8'b11000110;
        letter_pattern[5][6]  = 8'b11000110;
        letter_pattern[5][7]  = 8'b11000110;
        letter_pattern[5][8]  = 8'b11000110;
        letter_pattern[5][9]  = 8'b11000110;
        letter_pattern[5][10] = 8'b11111110;
        letter_pattern[5][11] = 8'b01111100;
        letter_pattern[5][12] = 8'b00000000;
        letter_pattern[5][13] = 8'b00000000;
        letter_pattern[5][14] = 8'b00000000;
        letter_pattern[5][15] = 8'b00000000;
        //s
        letter_pattern[6][0]  = 8'b00000000;
        letter_pattern[6][1]  = 8'b00000000;
        letter_pattern[6][2]  = 8'b01111100;
        letter_pattern[6][3]  = 8'b11111110;
        letter_pattern[6][4]  = 8'b11000000;
        letter_pattern[6][5]  = 8'b11000000;
        letter_pattern[6][6]  = 8'b11111100;
        letter_pattern[6][7]  = 8'b01111110;
        letter_pattern[6][8]  = 8'b00000110;
        letter_pattern[6][9]  = 8'b00000110;
        letter_pattern[6][10] = 8'b11111110;
        letter_pattern[6][11] = 8'b01111100;
        letter_pattern[6][12] = 8'b00000000;
        letter_pattern[6][13] = 8'b00000000;
        letter_pattern[6][14] = 8'b00000000;
        letter_pattern[6][15] = 8'b00000000;
        //l
        letter_pattern[7][0]  = 8'b00000000;
        letter_pattern[7][1]  = 8'b00000000;
        letter_pattern[7][2]  = 8'b11000000;
        letter_pattern[7][3]  = 8'b11000000;
        letter_pattern[7][4]  = 8'b11000000;
        letter_pattern[7][5]  = 8'b11000000;
        letter_pattern[7][6]  = 8'b11000000;
        letter_pattern[7][7]  = 8'b11000000;
        letter_pattern[7][8]  = 8'b11000000;
        letter_pattern[7][9]  = 8'b11000000;
        letter_pattern[7][10] = 8'b11111110;
        letter_pattern[7][11] = 8'b11111110;
        letter_pattern[7][12] = 8'b00000000;
        letter_pattern[7][13] = 8'b00000000;
        letter_pattern[7][14] = 8'b00000000;
        letter_pattern[7][15] = 8'b00000000;
        //e
        letter_pattern[8][0]  = 8'b00000000;
        letter_pattern[8][1]  = 8'b00000000;
        letter_pattern[8][2]  = 8'b11111110;
        letter_pattern[8][3]  = 8'b11111110;
        letter_pattern[8][4]  = 8'b11000000;
        letter_pattern[8][5]  = 8'b11000000;
        letter_pattern[8][6]  = 8'b11111100;
        letter_pattern[8][7]  = 8'b11111100;
        letter_pattern[8][8]  = 8'b11000000;
        letter_pattern[8][9]  = 8'b11000000;
        letter_pattern[8][10] = 8'b11111110;
        letter_pattern[8][11] = 8'b11111110;
        letter_pattern[8][12] = 8'b00000000;
        letter_pattern[8][13] = 8'b00000000;
        letter_pattern[8][14] = 8'b00000000;
        letter_pattern[8][15] = 8'b00000000;



end

    // Generate sync and counter signals
    always @(posedge clk_i_25MHz or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL-1) begin
                h_count <= 0;
                if (v_count == V_TOTAL-1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end else
                h_count <= h_count + 1;
        end
    end

    // Generate sync pulses
    always @(posedge clk_i_25MHz) begin
        Hsync <= (h_count < H_SYNC_PULSE) ? 0 : 1;
        Vsync <= (v_count < V_SYNC_PULSE) ? 0 : 1;
    end

    // Function to check if a point is within a circle
    function is_in_circle;
        input [9:0] center_x, center_y, x, y, radius;
        begin
            is_in_circle = ((x - center_x) * (x - center_x) + 
                           (y - center_y) * (y - center_y)) <= (radius * radius);
        end
    endfunction
    wire [3:0] tens_digit = (puan / 10);
    wire [3:0] ones_digit = puan % 10;


    //wire [3:0] tens_digit = 5;
    //wire [3:0] ones_digit = 1;


always @(posedge clk_i_25MHz) begin
    if (reset) begin
        // Reset dot visibility
        for (i = 0; i < 10; i = i + 1) begin
            for (j = 0; j < 10; j = j + 1) begin
                dot_visible[i][j] <= 1;
            end
        end
    end
    else if (game_state == PLAYING) begin
        // Update dot visibility when Pacman moves to a new position
        if (map[pacman_y][pacman_x] == DOT) begin
            dot_visible[pacman_y][pacman_x] <= 0;
        end
    end
end
 wire [3:0] rel_y = y_pos - 50;  // 0 to 15
        wire [2:0] rel_x = x_pos - 50; // 0 to 7
    always @(posedge clk_i_25MHz) begin
        {vgaRed, vgaGreen, vgaBlue} <= BLACK;

        if (game_state == TITLE) begin
    
            if (y_pos >= 180 && y_pos < 212) begin  
                // Render "P"
                if (x_pos >= 220 && x_pos < 236) begin
                    if (letter_pattern[1][(y_pos - 180)/2][7 - (x_pos - 220)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= YELLOW;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
                // Render "A"
                else if (x_pos >= 240 && x_pos < 256) begin
                    if (letter_pattern[0][(y_pos - 180)/2][7 - (x_pos - 240)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= YELLOW;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
                // Render "C"
                else if (x_pos >= 260 && x_pos < 276) begin
                    if (letter_pattern[3][(y_pos - 180)/2][7 - (x_pos - 260)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= YELLOW;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
                // Render "M"
                else if (x_pos >= 280 && x_pos < 296) begin
                    if (letter_pattern[2][(y_pos - 180)/2][7 - (x_pos - 280)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= YELLOW;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
                // Render "A"
                else if (x_pos >= 300 && x_pos < 316) begin
                    if (letter_pattern[0][(y_pos - 180)/2][7 - (x_pos - 300)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= YELLOW;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
                // Render "N"
                else if (x_pos >= 320 && x_pos < 336) begin
                    if (letter_pattern[4][(y_pos - 180)/2][7 - (x_pos - 320)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= YELLOW;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
            end
        end



        // Gameplay Rendering
        else if (game_state == PLAYING) begin
            
            if (x_pos >= 66 && x_pos < 66 + 8 &&
                y_pos >= 50 && y_pos < 50 + 16) begin
                 if (number_pattern[ones_digit][rel_y][7 - rel_x]) begin
            {vgaRed, vgaGreen, vgaBlue} <= 12'hFFF;  // White
        end else begin
                {vgaRed, vgaGreen, vgaBlue} <= BLUE;
                end
            end
        else if (x_pos >= 56 && x_pos < 56 + 8 &&
             y_pos >= 50 && y_pos < 50 + 16) begin
         
        if (number_pattern[tens_digit][rel_y][7 - rel_x]) begin
            {vgaRed, vgaGreen, vgaBlue} <= 12'hFFF;  
        end else begin
            {vgaRed, vgaGreen, vgaBlue} <= BLUE;
        end
    end
            
            
            if (x_pos >= GAME_OFFSET_X && x_pos < GAME_OFFSET_X + 10 * CELL_SIZE &&
                y_pos >= GAME_OFFSET_Y && y_pos < GAME_OFFSET_Y + 10 * CELL_SIZE) begin
                // Render collison
                if (board_x == pacman_x && board_y == pacman_y &&
                    board_x == ghost1_x && board_y == ghost1_y) begin
                    {vgaRed, vgaGreen, vgaBlue} <= COLLISION_COLOR;
                end
                // Render Pacman
                else if (board_x == pacman_x && board_y == pacman_y) begin
                  if (is_in_circle(CELL_SIZE / 2, CELL_SIZE / 2, cell_x, cell_y, CELL_SIZE / 3))
                        {vgaRed, vgaGreen, vgaBlue} <= YELLOW;
                end
                // Render Ghost
                else if (board_x == ghost1_x && board_y == ghost1_y) begin
                    if (is_in_circle(CELL_SIZE / 2, CELL_SIZE / 2, cell_x, cell_y, CELL_SIZE / 3))
                        {vgaRed, vgaGreen, vgaBlue} <= RED;
                end
                // Render Map Elements
                else begin
                    case (map[board_y][board_x])
                        WALL: {vgaRed, vgaGreen, vgaBlue} <= WALL_COLOR;
                        DOT: begin
                            if (is_in_circle(CELL_SIZE / 2, CELL_SIZE / 2, cell_x, cell_y, 2) &&  dot_visible[board_y][board_x])
                                {vgaRed, vgaGreen, vgaBlue} <= DOT_COLOR;
                        end
                        default: {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    endcase
                end
            end
        end

        
        else if (game_state == GAME_OVER) begin
         if (y_pos >= 180 && y_pos < 212) begin  
                // L
                if (x_pos >= 220 && x_pos < 236) begin
                    if (letter_pattern[7][(y_pos - 180)/2][7 - (x_pos - 220)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= RED;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
                // O
                else if (x_pos >= 240 && x_pos < 256) begin
                    if (letter_pattern[5][(y_pos - 180)/2][7 - (x_pos - 240)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= RED;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
                // s
                else if (x_pos >= 260 && x_pos < 276) begin
                    if (letter_pattern[6][(y_pos - 180)/2][7 - (x_pos - 260)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= RED;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
                // e
                else if (x_pos >= 280 && x_pos < 296) begin
                    if (letter_pattern[8][(y_pos - 180)/2][7 - (x_pos - 280)/2]) begin
                        {vgaRed, vgaGreen, vgaBlue} <= RED;
                    end else begin
                        {vgaRed, vgaGreen, vgaBlue} <= BLACK;
                    end
                end
               
                end
              
                end
            end
        

            
        
    

endmodule