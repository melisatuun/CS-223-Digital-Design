`timescale 1ns / 1ps

module trafficLights( input logic clk, input logic reset, input
        logic SA, input logic SB, output logic LA1, output logic LA0, output logic LB1, output logic LB0);
        typedef enum logic [2:0] {S0, S1, S2, S3, S4, S5, S6, S7}
        statetype;
        statetype [2:0] state, nextstate;
        
        //state register
        always_ff @ (posedge clk, posedge reset)
        if (reset)
            state <= 0;
        else
            state <= nextstate;
        //next state logic
        always_comb
           case (state)
               S0: if (SA) nextstate = S0;
        else
        nextstate = S1;
        nextstate = S2;
        nextstate = S3;
        nextstate = S4;
        S1:
        S2:
        S3:
        S4: if (SB) nextstate = S4;
        else S5:
        S6:
        S7:
        default:
        endcase
        nextstate = S5;
        nextstate = S6;
        nextstate = S7;
        nextstate = S0;
        nextstate = S0;

     //output logic
     assign LA1 = (state == S2 | state == S3 | state == S4 | state == S5 | state == S6);
     assign LA0 = (state == S1 | state == S7);
     assign LB1 = (state == S0 | state == S1 | state == S2 | state == S6 | state == S7);
     assign LB0 = (state == S3 | state == S5);
     endmodule
     
`timescale 1ns / 1ps

module clock_divider( input clk, input rst, output logic clk_div);
    localparam constantNumber = 150000000;
    logic [31:0] count;
    always @ (posedge(clk), posedge(rst))
    begin
    
    if (rst == 1'b1)
        count <= 32'b0;
    else if (count == constantNumber - 1)
        count <= 32'b0;
    else
        count <= count + 1;
end
 
always @ (posedge(clk), posedge(rst))
begin
    if (rst == 1'b1)
        clk_div <= 1'b0;
    else if (count == constantNumber - 1)
        clk_div <= ~clk_div;
    else
        clk_div <= clk_div;
end
endmodule

`timescale 1ns / 1ps

module topDesign( input logic clk, input logic reset, input logic
SA, input logic SB, output logic ledA2, output logic ledA1, output logic ledA0, output logic ledB2, output logic ledB1, output logic ledB0);
        logic clk_div;
        logic LA1, LA0, LB1, LB0;
        clock_divider( clk, reset, clk_div);
        trafficLights( clk_div, reset, SA, SB, LA1, LA0, LB1, LB0);
        assign ledA2 = ~LA1 & ~LA0;
 
        assign ledA1 = (~LA1 & ~LA0) | (~LA1 & LA0);
        assign ledA0 = (~LA1 & ~LA0) | (~LA1 & LA0) | (LA1 & ~LA0);
        assign ledB2 = ~LB1 & ~LB0;
        assign ledB1 = (~LB1 & ~LB0) | (~LB1 & LB0);
        assign ledB0 = (~LB1 & ~LB0) | (~LB1 & LB0) | (LB1 & ~LB0);
        endmodule
        
`timescale 1ns / 1ps

module testbench1();
    logic clk, reset;
    logic SA, SB, LA1, LA0, LB1, LB0;
    trafficLights dut(.clk(clk), .reset(reset), .SA(SA), .SB(SB), .LA1(LA1), .LA0(LA0), .LB1(LB1), .LB0(LB0));
    always begin
        clk = 1; #50;
        clk = 0; #50;
    end
    initial begin
        reset <= 1; #20;
        reset <= 0; SA <= 1; #100;
        SA <= 0; #100;
        #100;
        #100;
 
        #100;
        SB <= 1; #100;
        SB <= 0; #100;
        #100;
        #100;
        #100;
    end
    always begin
        clk <= 1; #50;
        clk <= 0; #50;
    end
endmodule
