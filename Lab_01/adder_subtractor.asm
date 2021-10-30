`timescale 1ns / 1ps

module fullAdder2Bit( input logic a0, a1, b0, b1, cin, output logic s0, s1, cout); 
              logic cmid;
              fullAdder1Bit melis( a0, b0, cin, s0, cmid);
              fullAdder1Bit melis2( a1, b1, cmid, s1, cout);
              endmodule

`timescale 1ns / 1ps

module xor2( input logic a, b, output logic y);
              assign y = a ^ b;
              endmodule
                
module and2( input logic a, b, output logic y);
              assign y = a & b;
              endmodule
                
module or2( input logic a, b, output logic y);
              assign y = a | b;
              endmodule
                
module fullSubtractor( input logic a, b, bin, output logic s, cout);
              logic x1, x2, a1, a2;
              xor2 xx1( a, b, x1);
              xor2 xx2( x1, bin, s);
              and2 aa1( ~a, b, a1);
              and2 aa2( ~x1, bin, a2);
              or2 oo1( a1, a2, cout);
              endmodule
              
`timescale 1ns / 1ps

 module OneBitFullAdder( input logic a, b, cin, output logic s, cout);
              assign s = ( a ^ b ) ^ cin;
              assign cout = ( a & b ) | ( ( a ^ b ) & cin );
              endmodule
              
`timescale 1ns / 1ps

module fullAdder1Bit( input logic a, b, cin, output logic s, cout);
          logic x1, x2, a1, a2;
          xor2 xx1( a, b, x1);
          xor2 xx2( x1, cin, s);
          and2 aa1( a, b, a1);
          and2 aa2( x1, cin, a2);
          or2 oo1( a1, a2, cout);
          endmodule


module testbench2BitAdder();
          logic a0 = 0, a1 = 0, b0 = 0, b1 = 1, cin;
          logic s0, s1, cout;
          fullAdder2Bit dut( a0, a1, b0, b1, cin, s0, s1, cout);
          initial begin
          a1 = 0; a0 = 0; b1 = 0; b0 = 0; cin = 0; #20;
          cin = 1; #20;
          b1 = 1; b0 = 0; cin = 0; #20;
          cin = 1; #20;
          b0 = 1; cin = 0; #20;
          cin = 1; #20;
          a0 = 1; b1 = 0; b0 = 0; cin = 0; #20;
          cin = 1; #20;
          b0 = 1; cin = 0; #20;
          cin = 1; #20;
          b1 = 1; b0 = 0; cin = 0; #20;
          cin = 1; #20;
          b0 = 1; cin = 0; #20;
          cin = 1; #20;
          a1 = 1; a0 = 0; b1 = 0; b0 = 0; cin = 0; #20;
          cin = 1; #20;
          b0 = 1; cin = 0; #20;
          cin = 1; #20;
          b1 = 1; b0 = 0; cin = 0; #20;
          cin = 1; #20;
          b1 = 1; b0 = 0; cin = 0; #20;
          cin = 1; #20;
          b0 = 1; cin = 0; #20;
          cin = 1; #20;
          a0 = 1; b1 = 0; b0 = 0; cin = 0; #20;
          cin = 1; #20;
          b0 = 1; cin = 0; #20;
          cin = 1; #20;
          b1 = 1; b0 = 0; cin = 0; #20;
          cin = 1; #20;
          b0 = 1; cin = 0; #20;
          cin = 1; #20;
          end
          endmodule
          
`timescale 1ns / 1ps

module fullAdder2Bit( input logic a0, a1, b0, b1, cin, output logic s0, s1, cout);
          logic cmid;
          fullAdder1Bit first( a0, b0, cin, s0, cmid);
          fullAdder1Bit second( a1, b1, cmid, s1, cout);
          endmodule
          
`timescale 1ns / 1ps

module fullAdder1Bit( input logic a, b, cin, output logic s, cout);
          logic x1, x2, a1, a2;
          xor2 xx1( a, b, x1);
          xor2 xx2( x1, cin, s);
          and2 aa1( a, b, a1);
          and2 aa2( x1, cin, a2);
          or2 oo1( a1, a2, cout);
          endmodule
          
module testbench2();
          logic a, b, c;
          logic s, cout;
          fullAdder1Bit dut( a, b, c, s, cout);
          initial begin
          a = 0; b = 0; c = 0; #20;
          a = 0; b = 0; c = 1; #20;
          a = 0; b = 1; c = 0; #20;
          a = 0; b = 1; c = 1; #20;
          a = 1; b = 0; c = 0; #20;
          a = 1; b = 0; c = 1; #20;
          a = 1; b = 1; c = 0; #20;
          a = 1; b = 1; c = 1; #20;
          end
          endmodule
          
 module testbench3();
          logic a, b, c;
          logic s, cout;
          fullSubtractor dut( a, b, c, s, cout);
          initial begin
          a = 0; b = 0; c = 0; #10;
          a = 0; b = 0; c = 1; #10;
          a = 0; b = 1; c = 0; #10;
          a = 0; b = 1; c = 1; #10;
          a = 1; b = 0; c = 0; #10;
          a = 1; b = 0; c = 1; #10;
          a = 1; b = 1; c = 0; #10;
          a = 1; b = 1; c = 1; #10;
          end
          endmodule
          
module testbenchFullAdder();
          logic a, b, c;
          logic sum, cout;
          OneBitFullAdder dut( a, b, c, sum, cout);
          initial begin
          a = 0; b = 0; c = 0; #20;
          a = 0; b = 0; c = 1; #20;
          a = 0; b = 1; c = 0; #20;
          a = 0; b = 1; c = 1; #20;
          a = 1; b = 0; c = 0; #20;
          a = 1; b = 0; c = 1; #20;
          a = 1; b = 1; c = 0; #20;
          a = 1; b = 1; c = 1; #20;
          end
          endmodule
