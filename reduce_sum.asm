`timescale 1ns / 1ps

module reduceSumTopDesign (input logic clk, input logic reset, input logic [3:0] writeAddress, input logic [7:0] writeData, 
                        input logic writeEnable,
                        input logic calculateSum,
                        input logic displayNext,
                        input logic displayPrev,
                        output logic [15:0] totalSum,
                        output logic [6:0] seg,
                        output logic dp,
                        output logic [3:0] an);
                        
          logic [7:0] readData1, readData2;
          logic [3:0] readAddress1, readAddress2;
          logic [15:0] totSum;
          logic pulse1, pulse2, pulse3, pulse4, pulse5;
          initial begin
            readData1 = 0;
            readAddress1 = 0;
            readData2 = 0;
            readAddress2 = 0;
          end
          debounce db1 (clk, writeEnable, pulse1);
          debounce db2 (clk, calculateSum, pulse2);
          debounce db3 (clk, displayNext, pulse3);
          debounce db4 (clk, displayPrev, pulse4);
          debounce db5 (clk, reset, pulse5);
          always_ff @ (posedge clk)
 
            if (pulse3) begin
                if (readAddress1 < 16)
                    readAddress1 <= readAddress1 + 1;
                else
                    readAddress1 <= 4'b0000;
                end
                else if (pulse4) begin
                    if (readAddress1 > 0)
                      readAddress1 <= readAddress1 - 1;
                    else
                      readAddress1 <= 15;
                    end
                    else
                        readAddress1 <= readAddress1;
          memory dut (clk, writeAddress, writeData,
                        pulse1, readAddress1,
                        readAddress2, readData1,
                        readData2);
          reduceSum r (clk, pulse5, pulse2, readData1,
                        readAddress2, totSum);
          SevSeg_4digit s (clk, readAddress1, 17,
                                readData1[7:4],
                                readData1[3:0], seg,
                                dp, an);
          assign totalSum = totSum;
endmodule

`timescale 1ns / 1ps
 
module memory (input logic clk, input logic [3:0] writeAddress, input logic [7:0] writeData, logic writeEnable, input logic [3:0] readAddress1,
                input logic [3:0] readAddress2,
                output logic [7:0] readData1,
                output logic [7:0] readData2);
                logic [7:0] mem[15:0];
                
        always_ff @ (posedge clk)
            if (writeEnable)
                mem[writeAddress] <= writeData;
        assign readData1 = mem[readAddress1];
        assign readData2 = mem[readAddress2];
endmodule

`timescale 1ns / 1ps

module reduceSum (input logic clk, input logic reset, input logic calculateSum, input logic [7:0] readData2, output logic [3:0] readAddress2, 
        output logic [15:0] sum);
        typedef enum logic [1:0] {S0,S1,S2} statetype;
        statetype [1:0] state, nextstate;
        logic [4:0] cnt;
        logic [4:0] nextCnt;
        logic [15:0] curSum;
        logic [15:0] nextSum;
        always_ff @ (posedge clk)
            if (reset) begin
                state <= S0;
                cnt <= 0;
                curSum <= 0;
            end
            else begin
                state <= nextstate;
                cnt <= nextCnt;
                curSum <= nextSum;
            end
        always_comb
        case (state)
            S0: begin
            if (calculateSum)
                nextstate = S1;
            else
                nextstate = S0;
                nextCnt = cnt;
                nextSum = curSum;
            end
            S1: begin
            nextCnt = 0;
            nextSum = 0;
            nextstate = S2;
            end
            S2: begin
                if (cnt <= 15) begin
                    nextSum = curSum + readData2;
                    nextstate = S2;
                end 
                else
                    nextCnt = cnt + 1;
                end
                default: nextstate = S0;
            endcase
        assign sum = curSum;
        assign readAddress2 = cnt;
endmodule
nextstate = S0;

`timescale 1ns / 1ps

module SevSeg_4digit (input clk, input [3:0] in3, in2, in1, in0, output [6:0]seg, logic dp, output [3:0] an);
    localparam N = 18;
    logic [N-1:0] count = {N{1'b0}}; //initial value
    always@ (posedge clk)
           count <= count + 1;
    logic [4:0]digit_val; // 7-bit register to hold the current data on output
    logic [3:0]digit_en;  //register for the 4 bit enable
    always@ (*)
    begin
        digit_en = 4'b1111; //default
        digit_val = in0; //default
    case(count[N-1:N-2]) //using only the 2 MSB's of the counter

    2'b00 :  //select first 7Seg.
    begin
     digit_val = {1'b0, in0};
     digit_en = 4'b1110;
    end
   2'b01:  //select second 7Seg.
    begin
     digit_val = {1'b0, in1};
     digit_en = 4'b1101;
    end
   2'b10:  //select third 7Seg.
    begin
     digit_val = {1'b1, in2};
     digit_en = 4'b1011;
    end
   2'b11:  //select forth 7Seg.
    begin
     digit_val = {1'b0, in3};
     digit_en = 4'b0111;
    end
    endcase 
    end
    
//Convert digit number to LED vector. LEDs are active low.
logic [6:0] sseg_LEDs;
always @(*)
 begin
  sseg_LEDs = 7'b1111111; //default
  case( digit_val)
   5'd0 : sseg_LEDs = 7'b1000000; //to display 0
   5'd1 : sseg_LEDs = 7'b1111001; //to display 1
   5'd2 : sseg_LEDs = 7'b0100100; //to display 2
   5'd3 : sseg_LEDs = 7'b0110000; //to display 3
   5'd4 : sseg_LEDs = 7'b0011001; //to display 4
   5'd5 : sseg_LEDs = 7'b0010010; //to display 5
   5'd6 : sseg_LEDs = 7'b0000010; //to display 6
   5'd7 : sseg_LEDs = 7'b1111000; //to display 7
   5'd8 : sseg_LEDs = 7'b0000000; //to display 8
   5'd9 : sseg_LEDs = 7'b0010000; //to display 9
   5'd10: sseg_LEDs = 7'b0001000; //to display a
   5'd11: sseg_LEDs = 7'b0000011; //to display b
   5'd12: sseg_LEDs = 7'b1000110; //to display c
   5'd13: sseg_LEDs = 7'b0100001; //to display d
   5'd14: sseg_LEDs = 7'b0000110; //to display e
   5'd15: sseg_LEDs = 7'b0001110; //to display f
   5'd16: sseg_LEDs = 7'b0110111; //to display "="
        default : sseg_LEDs = 7'b0111111; //dash
    endcase
    end
    assign an = digit_en;
 
    assign seg = sseg_LEDs;
    assign dp = 1'b1; //turn dp off
endmodule

`timescale 1ns / 1ps

module debounce ( input logic clk, input logic button, output logic pulse);
    logic [24:0] timer;
    typedef enum logic [1:0]{S0,S1,S2,S3} states;
    states state, nextState;
    logic gotInput;
    always_ff@(posedge clk)
    begin
        state <= nextState;
        if (gotInput)
            timer <= 25000000;
        else
            timer <= timer - 1;
    end
    always_comb
    case(state)

            S0: if(button)
            begin //startTimer
                nextState = S1;
                gotInput = 1;
            end
            else begin
            nextState = S0; gotInput = 0;
            end
            S1: begin
            nextState = S2; gotInput = 0;
            end
            S2: begin
            nextState = S3; gotInput = 0;
            end
            S3: begin
                if (timer == 0)
                    nextState = S0;
                else
                nextState = S3; gotInput = 0;
                end
            default: begin
                nextState = S0; gotInput = 0;
            end 
            endcase
        assign pulse = (state == S1);
endmodule

`timescale 1ns / 1ps

module testBench2();
        logic clk;
        logic calculateSum;
        logic [3:0] readAddress2;
        logic [7:0] readData2;
        logic [15:0] sum;
        logic reset;
        logic [7:0] data[15:0];
        reduceSum reduceSum (clk, reset, calculateSum, readData2, readAddress2, sum);
        assign readData2 = data[readAddress2];
        always begin
           clk <= 1; #5;
       clk <= 0; #5;
    end
    initial begin
           for (int i = 0; i < 16; i++) begin
               data[i] = 1;
        end
        calculateSum = 1;
    reset = 0;
    #120;
    calculateSum = 0;
    end
    endmodule
    
`timescale 1ns / 1ps

module testBench1();
    logic clk;
    logic [3:0] writeAddress;
    logic [7:0] writeData;
    logic writeEnable;
    logic [3:0] readAddress1;
    logic [3:0] readAddress2;
    logic [7:0] readData1;
    logic [7:0] readData2;
    memory dut ( clk, writeAddress, writeData, writeEnable, readAddress1, readAddress2, readData1, readData2);
    always begin
        clk = 1; #5;
        clk = 0; #5;
    end
    initial begin
        writeEnable = 1;
        writeAddress = 4'b0000; writeData = 8'b00010001;
        readAddress1 = 4'b0000; readAddress2 = 4'b0000;
        #10;
        writeAddress = 4'b0001; writeData = 8'b00010011;
            readAddress1 = 4'b0000; readAddress2 = 4'b0001;
        #10;
        writeAddress = 4'b0010; writeData = 8'b00010111;
        readAddress1 = 4'b0001; readAddress2 = 4'b0010;
        #10;
        writeAddress = 4'b0011; writeData = 8'b01110001;
        readAddress1 = 4'b0001; readAddress2 = 4'b0011;
        #10;
        writeAddress = 4'b0100; writeData = 8'b00011101;
        readAddress1 = 4'b0010; readAddress2 = 4'b0100;
        #10;
        writeAddress = 4'b0101; writeData = 8'b11110001;
        readAddress1 = 4'b0011; readAddress2 = 4'b0101;
        #10;
        writeAddress = 4'b0110; writeData = 8'b00010011;
        readAddress1 = 4'b0101; readAddress2 = 4'b0110;
        #10;
        writeAddress = 4'b0111; writeData = 8'b01110001;
        readAddress1 = 4'b0110; readAddress2 = 4'b0111;
 
        #10;
        writeAddress = 4'b1000; writeData = 8'b00000001;
        readAddress1 = 4'b0111; readAddress2 = 4'b1000;
        #10;
        writeAddress = 4'b1001; writeData = 8'b00000011;
        readAddress1 = 4'b1000; readAddress2 = 4'b1001;
        #10;
        writeAddress = 4'b1010; writeData = 8'b10010001;
        readAddress1 = 4'b1001; readAddress2 = 4'b1010;
        #10;
        writeAddress = 4'b1011; writeData = 8'b11010001;
        readAddress1 = 4'b1010; readAddress2 = 4'b1011;
        #10;
        writeAddress = 4'b1100; writeData = 8'b00011111;
        readAddress1 = 4'b1011; readAddress2 = 4'b1100;
        #10;
        writeAddress = 4'b1101; writeData = 8'b00011001;
        readAddress1 = 4'b1011; readAddress2 = 4'b1101;
        #10;
        writeAddress = 4'b1110; writeData = 8'b00110001;
        readAddress1 = 4'b1101; readAddress2 = 4'b1110;
        #10;
        writeAddress = 4'b1111; writeData = 8'b00110011;
        readAddress1 = 4'b1111; readAddress2 = 4'b1111;
        #10;
        end
        endmodule
 
