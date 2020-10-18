// implement 16 bit adder by behavior
module Sub_adder_16bit(sum, overdetect, cout, a, b, mode);

input [15:0] a, b;
input mode; // mode = 1: subtractor, mode = 0: adder
output [15:0] sum;
output cout, overdetect; // overflow detect 

//reg [16:0] result;

assign {cout, sum} = (mode) ? (a+{~b+1'b1}) : (a+b);
// assign overdetect = 
//    /*Positive Number OverFlow*/(((Add_ctrl==1)&&(A[15]==1)&&(B[15]==0)&&(SUM[15]==0)) || ((Add_ctrl==1)&&(A[15]==0)&&(B[15]==1)&&(SUM[15]==1)) 
// || /*Negative Number OverFlow*/ ((Add_ctrl==0)&&(A[15]==0)&&(B[15]==0)&&(SUM[15]==1)) || ((Add_ctrl==0)&&(A[15]==1)&&(B[15]==1)&&(SUM[15]==0)) )? 1:0;





endmodule