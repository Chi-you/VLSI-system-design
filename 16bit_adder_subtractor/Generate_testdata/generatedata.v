module generatedata();
reg [15:0] a;
wire b;

integer i;
initial begin
    //f = $fopen("output.txt", "w");
    for (i = 0; i < 65536; i = i + 1) begin
        #10 a = i;
        $monitor ("%h" , a);
    end
    
end
endmodule