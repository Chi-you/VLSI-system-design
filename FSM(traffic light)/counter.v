`timescale 1ns/10ps
module Syncounter(ST, clk, rst_n, t1, t2, t3, counter);

input ST, clk, rst_n; // mode = 0: count 0 -> 30, mode = 1: count 30 -> 0
//input reg [2:0] state;
output t1, t2, t3;
output reg [4:0] counter;
always @(posedge clk or negedge rst_n) begin
    if (rst_n == 0) begin 
        counter <= 5'b0;
    end
    else if(ST) begin    
        counter <= counter + 1'b1;
    end
    else 
        counter <= counter;
end
// define the time of each light
assign t1 = (counter == 5'd30) ? 1 : 0; // green light of road1/road2
assign t2 = (counter == 5'd15) ? 1 : 0; // green light of farmload
assign t3  = (counter == 5'd5) ? 1 : 0; // yellow light of all roads

always @(*) begin
    
end

endmodule