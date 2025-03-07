`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/28/2024 10:18:24 AM
// Design Name: 
// Module Name: boncuk
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


module boncuk(
    input clk_i,
    input reset,
    input [9:0] pacman_x,
    input [9:0] pacman_y,
    output reg [5:0] puan
); 
    integer i,j;
    reg dot_visible[9:0][9:0]; 
    reg [5:0] puan_next;

    initial begin
        puan = 0;
        for (i = 0; i < 10; i = i + 1) begin
            for (j = 0; j < 10; j = j + 1) begin
                dot_visible[i][j] = 1;
            end
        end
    end

   
    always @* begin
        puan_next = puan;
        
        if(dot_visible[pacman_y][pacman_x]) begin
            puan_next = puan + 1;
                  end
    end

    
    always @(posedge clk_i) begin 
        if(reset) begin
            puan <= 0;
            for (i = 0; i < 10; i = i + 1) begin
                for (j = 0; j < 10; j = j + 1) begin
                    dot_visible[i][j] <= 1;
                end
            end
        end
        else begin
            puan <= puan_next;
        
            if(dot_visible[pacman_y][pacman_x]) begin
                dot_visible[pacman_y][pacman_x] <= 0;
            end
        end 
    end
endmodule