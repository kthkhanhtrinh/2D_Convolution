`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2023 08:59:29 PM
// Design Name: 
// Module Name: read_txt2
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


`define IMG_SIZE    7

`define KERNEL_SIZE 3

`define RES_SIZE    5


module read_txt2(
    input wire clk, 
    input wire rst,
    output wire [7:0] result,
    output reg [7:0] feature_Map
    );
    integer i;
    /*variable support for multiplication stage*/
    reg enable_convol;
    
    reg [7:0] resultArray [0: `RES_SIZE * `RES_SIZE - 1]; 
    reg [3:0] imageArray[0: `IMG_SIZE * `IMG_SIZE - 1]; 
    reg [3:0] kernelArray[0: `KERNEL_SIZE * `KERNEL_SIZE - 1];
//    reg [7:0] feature_Map [0: 8]; 

    reg isConvled [0:8];
    
    reg [3:0] a;
    reg [3:0] b;

    wire check;
//    wire [7:0] result;
    
    reg [2:0] row_res;
    reg [2:0] col_res;
    
    reg [2:0] row_map;
    reg [2:0] col_map;
    reg [2:0] Fr_map;
    reg [2:0] Fc_map;
    reg [2:0] result_counter;
    reg [2:0] count_stage1_image;
    /*------------------------*/
    
    /*variable support for adding stage*/
    reg begin_adding;
    
    wire [7:0] tmp_output1;
    wire [7:0] tmp_output2;
    wire [7:0] tmp_output3;
    wire [7:0] tmp_output;
    
    wire done_row1;
    wire done_row2;
    wire done_row3;
    wire en_sum;
    wire done_sum;
    reg stop;
    reg done_kernel;
    /*-----------------------*/
    
    /*-----------------------*/ 
    ConvolutionStage1 c1_image(
        .a(a),
        .b(b),
        .clk(clk),
        .enable(enable_convol),
        .done(check),
        .prod(result)    
    );
    
    /*-----------------------*/    

    /*
    why when we implement the mul then add, the data not over flow
    our input have 4 bits (0 ? 8)dec
    4bits * 4 bits = 6 bits maximun
    6bits + 6bits + 6bits = 8bits max ? handle overflow arithmetic 
    */

        
    /*-----------------------*/    
    always @ (posedge clk) begin
        if (rst) begin
            enable_convol <= 1'b1;
            begin_adding <= 1'b0;
            row_map <= 3'b000;
            col_map <= 3'b000;
            Fr_map <= 3'b000;
            Fc_map <= 3'b000;
            row_res <= 3'b000;
            col_res <= 3'b000;
        end
        else if (!rst && enable_convol) begin
            if(col_map < `KERNEL_SIZE) begin        //here
                a <= imageArray[`IMG_SIZE * row_map + col_map + Fr_map + Fc_map*`IMG_SIZE];
                b <= kernelArray[`KERNEL_SIZE * row_map + col_map];
                #12 resultArray[`KERNEL_SIZE * row_map + col_map] <= result;
                $display("Index result array = %d", `KERNEL_SIZE * row_map + col_map);
                $display("Result =%d", result);
               
            end
            if(resultArray[`KERNEL_SIZE * row_res + col_res] !== 1'bz) begin //here
                col_res <= col_res + 1;
            end
            if( check) begin
                col_map <= col_map + 1;
            end


            if (col_res == `RES_SIZE) begin
                col_res <= 3'b000;
                row_res <= row_res + 1;
            end
            
            if(row_res == `RES_SIZE) begin
                row_res <= 3'b000;
                col_res <= 3'b000;
            end
            
            if(col_map == `KERNEL_SIZE) begin
                col_map <= 3'b000;
                row_map <= row_map + 1;        
            end
            
            if(row_map == `KERNEL_SIZE) begin
//                $display("Disable convol");
                $display("resultArray[3] = %d", resultArray[3]);
                $display("resultArray[4] = %d", resultArray[4]);
                $display("resultArray[5] = %d", resultArray[5]);
                enable_convol <= 1'b0; 
                row_map <= 3'b000;
                col_map <= 3'b000;
                isConvled[Fr_map + Fc_map*`RES_SIZE] <= 1'b1;

                row_res <= 3'b000;
                col_res <= 3'b000;

            end               

        end
        
        if (isConvled[Fr_map + Fc_map*`RES_SIZE]) begin
//            $display("Start adding");
            begin_adding <= 1'b1;
        end
        
        if (done_sum && begin_adding) begin
            $display("Start assign");
            feature_Map/*[Fr_map + Fc_map*`RES_SIZE]*/ = tmp_output;
            $display("**************************");
            $display("feature_Map =%d", feature_Map);
     
            begin_adding = 1'b0;

            for (i = 0; i < 9; i = i + 1)
                resultArray[i] = 1'bx;
                
            Fr_map = Fr_map + 1;
            
            if(Fr_map == `RES_SIZE) begin
                Fr_map = 3'b000;
                Fc_map = Fc_map + 1;
            end
            
            if(Fc_map == `RES_SIZE) begin
                done_kernel = 1'b1;
                enable_convol = 1'b0;
            end 
            enable_convol = 1'b1;

        end
        
        if(done_kernel) begin
            stop = 1'b1;
            $display("DONE KERNEL * IMG");

        end
        
        

    end /*end always*/
    assign en_sum = done_row1 && done_row2 && done_row3;
    initial $readmemb("C:\\Vivaldo\\Project\\image3.txt", imageArray, 0, `IMG_SIZE * `IMG_SIZE - 1);
    initial $readmemb("C:\\Vivaldo\\Project\\kernel1.txt", kernelArray, 0, `KERNEL_SIZE * `KERNEL_SIZE - 1);
    initial 
    for(i = 0; i < 9; i = i + 1) begin
        isConvled[i] <= 0;
    end
    
    /*-----SUB MODULE--------*/ 
    adderStage2 adder1(
        .input1(resultArray[0]),
        .input2(resultArray[1]),
        .input3(resultArray[2]),
        .clk(clk),
        .enable(begin_adding),
        .done(done_row1),
        .output1(tmp_output1)
    );
    
    adderStage2 adder2(
        .input1(resultArray[3]),
        .input2(resultArray[4]),
        .input3(resultArray[5]),
        .clk(clk),
        .enable(begin_adding),
        .done(done_row2),
        .output1(tmp_output2)
    );
    
    adderStage2 adder3(
        .input1(resultArray[6]),
        .input2(resultArray[7]),
        .input3(resultArray[8]),
        .clk(clk),
        .enable(begin_adding),
        .done(done_row3),
        .output1(tmp_output3)
    );
    
    adderStage2 adder4(
        .input1(tmp_output1),
        .input2(tmp_output2),
        .input3(tmp_output3),
        .clk(clk),
        .enable(en_sum),
        .done(done_sum),
        .output1(tmp_output)
    );  
    
endmodule