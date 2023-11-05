`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 11:27:21 AM
// Design Name: 
// Module Name: maxPooling
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


module maxPooling(
    input clk,
    input enable,
    input [3:0] input1,
    input [3:0] input2,
    input [3:0] input3,
    input [3:0] input4,
    output reg signed [3:0] output1,
    output reg done        
    );
    reg [7:0] initialMax = 8'b10000000;
    always @ (posedge clk) begin
        $display("--------------------------");
        $display("Input1: %d\n", input1);
        $display("Input2: %d\n", input2);
        $display("Input3: %d\n", input3);
        $display("Input4: %d\n", input4);
        if(enable) begin
            if($signed(initialMax) < $signed(input1)) begin
                if($signed(input2) < $signed(input1)) begin
                    if($signed(input3) < $signed(input1)) begin
                        if($signed(input4) < $signed(input1)) begin
                            output1 <= input1;
                            done <= 1;
                        end
                        else begin
                            output1 <= input4;
                            done <= 1;
                        end
                    end
                    else begin
                        if($signed(input3) < $signed(input4)) begin
                            output1 <= input4;
                            done <= 1;
                        end
                        else begin
                            output1 <= input3;
                            done <= 1;
                        end
                    end
                end
                else begin
                    if($signed(input3) < $signed(input2)) begin
                        if($signed(input4) < $signed(input2)) begin
                            output1 <= input2;
                            done <= 1;
                        end
                        else begin
                            output1 <= input4;
                            done <= 1;
                        end
                    end
                    else begin
                        if($signed(input3) < $signed(input4)) begin
                            output1 <= input4;
                            done <= 1;
                        end
                        else begin
                            output1 <= input3;
                            done <= 1;
                        end
                    end
                end
            end
            else begin
                output1 <= initialMax;
                done <= 1;
            end
        end
        else begin
            output1 <= 0;
            done <= 0;
        end
//        $display("output: %d\n", output1);
    end
endmodule
