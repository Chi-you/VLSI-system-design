`timescale 1ns/10ps
module Syncounter(mode, clk, rst, counter);

input mode, clk, rst; // mode = 1: count 0 -> 30, mode = 0: count 30 -> 0
output reg [4:0] counter;
always @(posedge clk or posedge rst) begin
    if (rst) begin
        counter <= 0;
    end
    else begin    
        if (mode && counter == 5'd30)
            counter <= 5'b0;
        else if (!mode && counter == 0)
            counter <= 5'd30;
        else if (mode)
            counter <= counter + 1'b1;
        else 
            counter <= counter - 1'b1;
    end
end

endmodule