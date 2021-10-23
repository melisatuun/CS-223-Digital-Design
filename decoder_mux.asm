`timescale 1ns / 1ps

module BehavioralDecoder2to4( input logic a, b, output logic y0, y1, y2, y3);

    assign y0 = ~a & ~b;
    assign y1 = a & ~b;
    assign y2 = ~a & b;
    assign y3 = a & b;
    endmodule

`timescale 1ns / 1ps

module testbenchDecoder2to4();

    logic a, b;
    logic y0, y1, y2, y3;
    BehavioralDecoder2to4 dut( a, b, y0, y1, y2, y3);
    initial begin
        a = 0; b = 0; #20;
        a = 0; b = 1; #20;
        a = 1; b = 0; #20;
        a = 1; b = 1; #20;
        a = 0; b = 0; #20;
        a = 0; b = 1; #20;
        a = 1; b = 0; #20;
        a = 1; b = 1; #20;
        end
        endmodule

`timescale 1ns / 1ps

module Multiplexer4to1( input logic a, b, c, d, s1, s2, output logic y);

        assign y = a & (~s2 & ~s1) | c & (~s2 & s1) | b & (s2 & ~s1) | d & (s2 & s1);
        endmodule

`timescale 1ns / 1ps

module testbenchMultiplexer4to1();

        logic a, b, c, d, s0, s1;
        logic y;
        Multiplexer4to1 dut( a, b, c, d, s0, s1, y);
        initial begin
        for ( int i = 0; i <= 1; i++ ) begin
        for ( int k = 0; k <= 1; k++ ) begin
            for ( int j = 0; j <= 1; j++ ) begin
                for ( int m = 0; m <= 1; m++ ) begin
                    for ( int n = 0; n <= 1; n++ ) begin
                        for ( int q = 0; q <= 1; q++ ) begin
                            a = i;
                            b = k;
                            c = j;
                            d = m;
                            s0 = n;
                            s1 = q;
                            #10;
                        end 
                        end
                        end
                        end 
                        end
                        end 
                        end
                        endmodule

`timescale 1ns / 1ps

module and2( input logic a, b,output logic y);
            assign y = a & b;
            endmodule
            
module or2( input logic a, b, output logic y);
            assign y = a | b;
            endmodule
            
module not2( input logic a, output logic y);
            assign y = ~a;
            endmodule
            
module MUX8to1( input logic a, b, c, d, e, f, g, h, s0, s1, s2, output logic y);

           logic w0, w1, w2, w3, w4;
    
           Multiplexer4to1 mux1( e, f, g, h, s1, s2, w0);
           Multiplexer4to1 mux2( a, b, c, d, s1, s2, w1);
           and2 a2( w1, s0, w4);
           not2 n1( s0, w2);
           and2 a1( w0, w2, w3);
           or2 o1( w3, w4, y);
           endmodule

`timescale 1ns / 1ps

module testbenchMultiplexer8to1();

           logic a, b, c, d, e, f, g, h, s0, s1, s2;
           logic y;
           MUX8to1 dut( a, b, c, d, e, f, g, h, s0, s1, s2, y);
           initial begin
           for ( int i = 0; i <= 1; i++ ) begin
           begin
           for ( int k = 0; k <= 1; k++ ) begin
              for ( int m = 0; m <= 1; m++ ) begin
                 for ( int j = 0; j <= 1; j++ ) begin
                    for ( int x = 0; x <= 1; x++ ) begin
                       for ( int n = 0; n <= 1; n++ ) begin
                          for ( int t = 0; t <= 1; t++ ) begin
                             for ( int y = 0; y <= 1; y++ )
                                for ( int z = 0; z <= 1; z++ ) begin

                                for ( int q = 0; q <= 1; q++ ) begin
                                for ( int p = 0; p <= 1; p++ ) begin
                                a = i;
                                b = k;
                                c = m;
                                d = j;
                                e = x;
                                f = n;
                                g = t;
                                h = y;
                                s0 = z;
                                s1 = q;
                                s2 = p;
                                #0.2;
                                end end
                                end end
                                end end
                                end end
                                end end
                                end end
                                endmodule

`timescale 1ns / 1ps

module theFunction( input logic e, g, f, h, output logic y);

        logic w0;
        not2 n2( h, w0);
        MUX8to1 mux( 1, h, w0, h, w0, 1, 0, h, e, f, g, y);
        endmodule

