/*Pipeline可以增加時脈，也就增加了執行速度，但在本例可以發現，
為了使用pipeline，增加了很多register，對FPGA來說就是增加logic element，
對ASIC來說就是增加面積，也就是增加成本，這也是為什麼IC不可能毫無限制的使用pipeline增加速度，
畢竟速度是靠面積換來的，只能在spec允許下適當的使用pipeline加速。
*/

// implement sigma(a*b+c)
`timescale 1ns/1ns
module Pipeline_unsigned_arithmetic(clk, rst_n, i_a, i_b, i_c, out);
input clk, rst_n;
input [3:0] i_a, i_b, i_c;
output [7:0] out;

reg [3:0] r_a0;
reg [3:0] r_b0;
reg [3:0] r_c0;
reg [3:0] r_c1;

reg [7:0] r_mul;
reg [7:0] r_acc;
reg [7:0] r_answer;

always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        r_a0 <= #1 4'h0;
        r_b0 <= #1 4'h0;
        r_c0 <= #1 4'h0;
        r_c1 <= #1 4'h0;
        r_mul <= #1 8'h00;
        r_acc <= #1 8'h00;
        r_answer <= #1 8'h00;
    end
    else begin
        r_a0 <= #1 i_a;
        r_b0 <= #1 i_b;
        r_c0 <= #1 i_c;
        r_c1 <= #1 r_c0;
        r_mul <= #1 r_a0 * r_b0;
        r_acc <= #1 r_mul + r_c1;
        r_answer <= #1 r_answer + r_acc;
    end

end

assign out = r_answer;
endmodule