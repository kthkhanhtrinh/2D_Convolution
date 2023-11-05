`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 12:10:27 PM
// Design Name: 
// Module Name: CNN_maxPool_tb
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


module CNN_maxPool_tb;
    reg clk;
    reg rst;
    reg [3:0] imageArray[0:48];
    reg [3:0] maxPoolArray[0:3];
    wire [3:0] out;
    
    CNN_maxPool uut(
        .clk(clk),
        .rst(rst),
        .out(out)
    );
    always #5 clk = ~clk;	
    initial 
    begin
        clk = 0;
        rst = 1;
        #10
        rst = 0;
        $readmemb("C:\\Vivaldo\\Project\\image3.txt", imageArray, 0, 48);
        
        #140 
        $stop;
    end
endmodule
