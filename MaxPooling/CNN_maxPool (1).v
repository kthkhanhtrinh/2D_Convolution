`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 11:46:34 AM
// Design Name: 
// Module Name: CNN_maxPool
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

`define IMAGEROW	7
`define IMAGECOL	7
`define KERNELROW	3
`define KERNELCOL	3
`define CONVROW		3
`define CONVCOL		3
`define strides     2
//`define MAXROW 		121
//`define MAXCOL		121
module CNN_maxPool(
    input clk, 
    input rst,
    output [3:0] out
    );
    reg [3:0] imageArray [0:48]; 
    reg [3:0] kernelArray [0:8]; 
    reg [3:0] maxPoolArray [0:8];
    
    initial $readmemb("C:\\Vivaldo\\Project\\image3.txt", imageArray, 0, 48);
    //kernel 3x3 ? 9 inputs img
    wire [3:0] input1_image;    
    wire [3:0] input2_image;    
    wire [3:0] input3_image;
    wire [3:0] input4_image;
    
    wire [3:0] output_image;
    
    reg enable_max_pool;
    reg done_max_pool;
    wire done;
    reg [2:0] rowCount_image;
    reg [3:0] result_counter;
    reg [5:0] count_image;
    
    integer fd;
    
    initial begin
        fd = $fopen("C:\\Vivaldo\\Project\\result.txt", "w");
    end
    
    maxPooling c1_image(
        .clk(clk),
        .enable(enable_max_pool),
        .input1(input1_image),
        .input2(input2_image),
        .input3(input3_image),
        .input4(input4_image),
        .output1(output_image),
        .done(done)
    );
    
    /*------------------------------- -*/
    always @ (posedge clk) begin
        if(rst) begin
            done_max_pool <= 1'b0;
            rowCount_image <= 3'b001;
            result_counter <= 0;
            enable_max_pool <= 1'b0;
            count_image <= 0;
        end
        else begin
            enable_max_pool <= 1'b1;
            if(enable_max_pool) begin
//                $display("row count: %d\n", rowCount_image);
                if(rowCount_image < `IMAGEROW) begin
//                    $display("count: %d\n", count_image);
                    if(count_image < (rowCount_image*`IMAGECOL - 1 - `strides)) begin
                        count_image <= count_image + `strides; 
                        rowCount_image <= rowCount_image;
//                        $display("++++++++++++++++++++++");
                    end
                    else begin
//                        $display("----------------------------");
                        rowCount_image <= rowCount_image + `strides;
                        count_image <= rowCount_image*`IMAGECOL + `IMAGECOL;
//                        $display("row count: %d\n", rowCount_image);
//                        $display("count: %d\n", count_image);
//                        $display("----------------------------");
                    end                    
                end
                else begin
                    count_image <= count_image;
                    rowCount_image <= rowCount_image;
                end
            end
            else begin
                count_image <= 0;
                rowCount_image <= 3'b001;
            end
            if(done) begin
                maxPoolArray[result_counter] <= output_image;
                result_counter <= result_counter + 1;
                done_max_pool <= 1'b1;
//                $display("Success output\n");
//                $display("output1: %d\n", maxPoolArray[0]);
//                $display("output2: %d\n", maxPoolArray[1]);
//                $display("output3: %d\n", maxPoolArray[2]);
//                $display("output4: %d\n", maxPoolArray[3]);
//                $display("output: %d\n", output_image);
                $fwrite(fd, "%d\n", output_image);
                if(result_counter == 8) begin
                    $fclose(fd);
                end
            end
        end
        $display("--------------------------");
        $display("Count image: %d\n", count_image);
        $display("Input1: %d\n", imageArray[count_image + 0]);
        $display("Input2: %d\n", imageArray[count_image + 1]);
        $display("Input3: %d\n", imageArray[count_image + `IMAGEROW]);
        $display("Input4: %d\n", imageArray[count_image + `IMAGEROW + 1]);
        $display("--------------------------");
        
    end
    
    assign input1_image = (enable_max_pool && (rowCount_image < `IMAGEROW))?
                imageArray[count_image + 0][3:0]:4'b0000;
    assign input2_image = (enable_max_pool && (rowCount_image < `IMAGEROW))?
                imageArray[count_image + 1][3:0]:4'b0000;
    assign input3_image = (enable_max_pool && (rowCount_image < `IMAGEROW))?
                imageArray[count_image + `IMAGEROW][3:0]:4'b0000;
    assign input4_image = (enable_max_pool && (rowCount_image < `IMAGEROW))?
                imageArray[count_image + `IMAGEROW + 1][3:0]:4'b0000;
    
    assign out = (result_counter > 0)?maxPoolArray[result_counter-1]:4'b0000; 
endmodule
