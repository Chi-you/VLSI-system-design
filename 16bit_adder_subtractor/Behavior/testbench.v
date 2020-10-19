`include "./16bit_adder.v"
`timescale 1ns/10ps
`define delay 20 
module testbench();

reg [15:0] A, B;
reg Mode;
wire [15:0] SUM;
wire Cout;

reg [15:0] mem_A [9999:0];
reg [15:0] mem_B [9999:0];
reg mem_ctrl [9999:0];
reg [16:0] expect [9999:0];

reg [16:0] error = 0;

// read the testing data
initial begin
	$readmemh("A.txt", mem_A);
	$readmemh("B.txt", mem_B);
	$readmemh("ctrl.txt", mem_ctrl);
	$readmemh("result.txt", expect);
end


Sub_adder_16bit S1(
    .a(A),
    .b(B),
    .mode(Mode),
    .cout(Cout),
    .sum(SUM)
);

integer i;
initial begin
    for (i =0 ; i <= 9999; i = i + 1 ) begin
        A = mem_A[i] ;
        B = mem_B[i] ;
        Mode = mem_ctrl[i] ;

        #(`delay);
        if (SUM !== expect[i][15:0]) begin
            $display ("ERROR at time=%d(pattern%d): SUM(%h)!= expect(%h)", $time, i+1, SUM, expect[i][15:0]);
            error = error + 1;
        end
		
        if (Cout !== expect[i][16]) begin
            $display ("ERROR at time=%d(pattern%d): C_out(%b)!= expect(%b)", $time,  i+1, Cout, expect[i][16]);
            error = error + 1;
        end

    end

    if(error == 17'b0) begin
        $display("        ***********************************************        ");
        $display("        **                                           **        ");
        $display("        **             Congratulations !!            **        ");
        $display("        **               Test PASS  !!               **        ");
        $display("        **                                           **        ");
        $display("        ***********************************************        ");
    end
    else begin
        $display ("=================================================");
        $display ("There're %d errors in your design", error); 
        $display ("=================================================");
    end

	$finish ;

end

initial begin
    $dumpfile("16bitsub_adder.vcd");
    $dumpvars;
end

endmodule