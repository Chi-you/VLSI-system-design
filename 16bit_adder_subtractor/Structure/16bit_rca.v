// implement 16 bit adder by structural modeling
`include "./4bit_rca.v"

module Sub_adder_16bit(cout, sum, a , b, mode);
input [15:0] a, b;
input mode; // mode = 0: addition, mode = 1: subtraction
output [15:0] sum;
output cout;

wire [15:0] y;


// do 1's complement
xor x1(y[0], mode, b[0]);
xor x2(y[1], mode, b[1]);
xor x3(y[2], mode, b[2]);
xor x4(y[3], mode, b[3]);

xor x5(y[4], mode, b[4]);
xor x6(y[5], mode, b[5]);
xor x7(y[6], mode, b[6]);
xor x8(y[7], mode, b[7]);

xor x9 (y[8],  mode, b[8]);
xor x10(y[9],  mode, b[9]);
xor x11(y[10], mode, b[10]);
xor x12(y[11], mode, b[11]);

xor x13(y[12], mode, b[12]);
xor x14(y[13], mode, b[13]);
xor x15(y[14], mode, b[14]);
xor x16(y[15], mode, b[15]);

Ripple_carry_4bit R1(
    .a(a[3:0]),
    .b(y[3:0]),
    .cin(mode), 
    .sum(sum[3:0]),
    .cout(c1)
);
Ripple_carry_4bit R2(
    .a(a[7:4]),
    .b(y[7:4]),
    .cin(c1),
    .sum(sum[7:4]),
    .cout(c2)
);
Ripple_carry_4bit R3(
    .a(a[11:8]),
    .b(y[11:8]),
    .cin(c2),
    .sum(sum[11:8]),
    .cout(c3)
);
Ripple_carry_4bit R4(
    .a(a[15:12]),
    .b(y[15:12]),
    .cin(c3),
    .sum(sum[15:12]),
    .cout(cout)
);

endmodule