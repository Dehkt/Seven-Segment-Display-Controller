`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2024 07:10:51 AM
// Design Name: 
// Module Name: BCD_SevenSeg
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

module BCD_SevenSeg(
    input [3:0] A,
    output [6:0] D
    );
    
    assign D[0] = (~A[3] & ~A[2] & ~A[1] & A[0]) |
                  (~A[3] & A[2] & ~A[1] & ~A[0]) |
                  (A[3] & A[2] & ~A[1] & A[0]) |
                  (A[3] & ~A[2] & A[1] & A[0]);

    assign D[1] = (~A[3] & A[2] & ~A[1] & A[0]) |
                  (A[3] & A[2] & ~A[0]) |
                  (A[2] & A[1] & ~A[0]) |
                  (A[3] & A[1] & A[0]);

    assign D[2] = (~A[3] & ~A[2] & A[1] & ~A[0]) |
                  (A[3] & A[2] & A[1]) |
                  (A[3] & A[2] & ~A[1] & ~A[0]);

    assign D[3] = (~A[3] & A[2] & ~A[1] & ~A[0]) |
                  (~A[3] & ~A[2] & ~A[1] & A[0]) |
                  (A[2] & A[1] & A[0]) |
                  (A[3] & ~A[2] & A[1] & A[0]);

    assign D[4] = (~A[3] & A[0]) |
                  (~A[3] & A[2] & ~A[1]) |
                  (~A[2] & ~A[1] & A[0]);

    assign D[5] = (A[3] & A[2] & ~A[1] & A[0]) |
                  (~A[3] & ~A[2] & A[1]) |
                  (~A[3] & ~A[2] & A[0]) |
                  (~A[3] & A[1] & A[0]);

    assign D[6] = (~A[3] & ~A[2] & ~A[1]) |
                  (~A[3] & A[2] & A[1] & A[0]) |
                  (A[3] & A[2] & ~A[1] & ~A[0]);
endmodule


module top (
    input clk,
    input [15:0] sw,      // 16 total switches
    output reg [6:0] seg, // 7 segments per display
    output reg [3:0] an   // enable signal for each display
);
    wire [6:0] disp1, disp2, disp3, disp4;
    reg [1:0] mux_sel;
    reg [16:0] refresh_counter;
    reg clk_div;
    
    BCD_SevenSeg seg1 (.A(sw[3:0]),   .D(disp1));
    BCD_SevenSeg seg2 (.A(sw[7:4]),   .D(disp2));
    BCD_SevenSeg seg3 (.A(sw[11:8]),  .D(disp3));
    BCD_SevenSeg seg4 (.A(sw[15:12]), .D(disp4));


    // Clock Divider to create a slower clock (e.g., 1 kHz from 100 MHz)
    always @(posedge clk) begin
        if (refresh_counter == 99_999) begin
            clk_div <= ~clk_div; // Toggle the clock signal every 100,000 cycles
            refresh_counter <= 0; // Reset counter
        end else begin
            refresh_counter <= refresh_counter + 1; // Increment counter
        end
    end

    // Multiplexing logic based on the divided clock signal
    always @(posedge clk_div) begin
        mux_sel <= mux_sel + 1;  // Increment the multiplexing selection every clock pulse
    end

    // Select which display to activate based on the select signal of multiplexer
    always @(*) begin
        case (mux_sel)
            2'b00: begin
                an = 4'b1110;
                seg = disp1;
            end
            2'b01: begin
                an = 4'b1101; 
                seg = disp2;
            end
            2'b10: begin
                an = 4'b1011;
                seg = disp3;
            end
            2'b11: begin
                an = 4'b0111;
                seg = disp4;
            end
        endcase
    end
endmodule

