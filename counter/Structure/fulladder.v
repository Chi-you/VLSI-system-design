`include "./halfadder.v"
module Fulladder(
    cout,
    sum,
    a,
    b,
    cin
);

input a, b, cin;
output cout, sum;

Halfadder H1(.a(a), .b(b), .carry(c1), .sum(s1));
Halfadder H2(.a(cin), .b(s1), .carry(c2), .sum(sum));
or (cout, c1, c2);


endmodule