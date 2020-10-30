/* 
// FSM (traffic light) 
// 2020/10/29 finished
// author: Chi-you Li
*/
`timescale 1ns/10ps
module Traffic_light(R1G, R1Y, R1R, R2G, R2Y, R2R, FG, FY, FR, clk, rst_n, c);

input clk, rst_n, c;
output R1G, R1Y, R1R, R2G, R2Y, R2R, FG, FY, FR;
wire tg1, tg2, ty; // the signal of the
//reg ST_o, ST; // start timer(counter)
reg [2:0] state, next_state;
reg [4:0] counter, counter_; // counter: counter up, counter_: count down

parameter S0 = 3'b000,
          S1 = 3'b001,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100,
          S5 = 3'b101;
// output logic (combinational)
// R1: road 1, R2: road 2, F: farmroad
// G: green light, Y: yellow light, R: red light
assign R1G = (state == S0);
assign R1Y = (state == S1);
assign R1R = (state == S2) || (state == S3) || (state == S4) || (state == S5);
assign R2G = (state == S2);
assign R2Y = (state == S3);
assign R2R = (state == S0) || (state == S1) || (state == S4) || (state == S5);
assign FG  = (state == S4);
assign FY  = (state == S5);
assign FR  = (state == S0) || (state == S1) || (state == S2) || (state == S3);

// define the time of each light
assign tg1 = (counter == 5'd30) ? 1 : 0; // green light of road1/road2
assign tg2 = (counter == 5'd15) ? 1 : 0; // green light of farmload
assign ty  = (counter == 5'd5)  ? 1 : 0; // yellow light of all roads


always@(posedge clk or negedge rst_n) begin // state register (sequential) + counter
    if(!rst_n) begin
        state <= S0;
        //ST_o <= 0;
        counter <= 5'd0;
        counter_ <= 5'd31;
    end 
    else begin
        state <= next_state;
        //ST_o <= ST;    
        if(tg1 && (state == S0 || state == S2)) begin
            counter <= 5'd1;
            counter_ <= 5'd31;
        end
        else if(tg2 && state == S4) begin
            counter <= 5'd1;
            counter_ <= 5'd16;
        end
        else if(ty && (state == S1 || state == S3 || state == S5)) begin
            counter <= 5'd1;
            counter_ <= 5'd6;
        end
        else begin
            counter <= counter + 5'd1;
            counter_ <= counter_ - 5'd1;
        end
    end // end else
end // end always


always@(*) begin // next state logic (combinational)
    case(state)
        S0: begin
            if(tg1) begin
                next_state = S1;
                //ST = 1;
            end
            else begin
                next_state = S0;
                //ST = 0;
            end
        end
        S1: begin
            if(ty & !c) begin
                next_state = S2;
                //ST = 1;
            end
            else if(ty & c) begin
                next_state = S4;
                //ST = 1;
            end
            else begin
                next_state = S1;
                //ST = 0;
            end
        end
        S2: begin
            if(tg1) begin
                next_state = S3;
                //ST = 1;
            end
            else begin
                next_state = S2;
                //ST = 0;
            end
        end
        S3: begin
            if(ty & !c) begin
                next_state = S0;
                //ST = 1;
            end
            else if(ty & c) begin
                next_state = S4;
                //ST = 1;
            end
            else begin
                next_state = S3;
                //ST = 0;
            end
        end
        S4: begin
            if(tg2 | !c) begin
                next_state = S5;
                //ST = 1;
            end
            else begin
                next_state = S4;
                //ST = 0;
            end
        end
        S5: begin
            if(ty) begin
                next_state = S0;
                //ST = 1;
            end
            else begin
                next_state = S5;
                //ST = 0;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end // end always

endmodule