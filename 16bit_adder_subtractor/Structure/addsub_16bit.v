// implement 16 bit adder by structural modeling
`include "./Addsub_4bit.v"

module Sub_adder_16bit(cout, sum, a , b, mode);
input [15:0] a, b;
input mode; // mode = 0: addition, mode = 1: subtraction
output [15:0] sum;
output cout;

wire [15:0] y;



Addsub_4bit R1(
    .a(a[3:0]),
    .b(y[3:0]),
    .mode(mode), 
    .sum(sum[3:0]),
    .cout(c1)
);
Addsub_4bit R2(
    .a(a[7:4]),
    .b(y[7:4]),
    .mode(c1),
    .sum(sum[7:4]),
    .cout(c2)
);
Addsub_4bit R3(
    .a(a[11:8]),
    .b(y[11:8]),
    .mode(c2),
    .sum(sum[11:8]),
    .cout(c3)
);
Addsub_4bit R4(
    .a(a[15:12]),
    .b(y[15:12]),
    .mode(c3),
    .sum(sum[15:12]),
    .cout(cout)
);

endmodule