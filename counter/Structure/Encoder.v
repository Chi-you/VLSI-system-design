`timescale 1ns/10ps

module Encoder(a, b, c, o);
input a, b, c;
output [4:0] o;

and (o[4], 0, a);
and (o[3], 0, a);
and (o[2], 0, a);
buf (o[1], b);
buf (o[0], c);



endmodule