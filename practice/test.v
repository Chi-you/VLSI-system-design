`timescale 1ns/10ps
module test(a, clk, b);
input a, clk;
output reg b;

always @(posedge clk) begin
    b <= a;
end

endmodule