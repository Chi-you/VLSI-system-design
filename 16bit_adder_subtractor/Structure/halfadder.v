module Halfadder(
    carry,
    sum,
    a,
    b
);

input a, b;
output carry, sum;

and (carry, a, b);

xor (sum, a, b);

endmodule