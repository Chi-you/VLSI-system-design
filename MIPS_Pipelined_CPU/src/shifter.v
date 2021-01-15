//  2021/1/13 11:35
//  sd = fuction[1] = code[1]
//  sp = fuction[0] = code[0]
//  sn = code[10:6]
module shifter(dout, din, sd, /*sp,*/ sn);

        output  [31:0]  dout;
        input   [31:0]  din;
        input           sd;     // Direction [0]Left [1]Right
        //input           sp;     // Property [0]Logical [1]Arithmetic
        input   [4:0]   sn;     // Offset Number

   	//-------------------------------------------------------------
	//	Internal wires
        //-------------------------------------------------------------
        
	wire	[31:0]	sl1, sl2, sl3, sl4, sl5;
	wire	[31:0]	sr1, sr2, sr3, sr4, sr5;

	wire	[31:0]	sl_result;	//Shift Left Result	
	wire	[31:0]	sr_result;	//Shift Right Result

	wire		sr_value;
	
	reg	[31:0]	dout;	
	
   	//-------------------------------------------------------------
	//	Shift Left
        //-------------------------------------------------------------

	//Level 1 (16bits)
	assign	sl1 = (sn[4]==1'b1) 
	               ? {din[15:0], 16'b0}
	               : din ;
	                          
	//Level 2 (8bits)
	assign	sl2 = (sn[3]==1'b1) 
	               ? {sl1[23:0], 8'b0}
	               : sl1 ;

	//Level 3 (4bits)
	assign	sl3 = (sn[2]==1'b1) 
	               ? {sl2[27:0], 4'b0}
	               : sl2 ;
	
	//Level 4 (2bits)
	assign	sl4 = (sn[1]==1'b1) 
	               ? {sl3[29:0], 2'b0}
	               : sl3 ;	               

	//Level 5 (1bits)
	assign	sl5 = (sn[0]==1'b1) 
	               ? {sl4[30:0], 1'b0}
	               : sl4 ;

	assign	sl_result = sl5;
	               	               

	
   	//-------------------------------------------------------------
	//	Shift Right
        //-------------------------------------------------------------
	assign	sr_value = 1'b0 ;
	//Level 1 (16bits)
	assign	sr1 = (sn[4]==1'b0) 
			? din
			: (sr_value) 
			? {16'b1111_1111_1111_1111, din[31:16]}
			: {16'b0000_0000_0000_0000, din[31:16]} ;
	                          
	//Level 2 (8bits)
	assign	sr2 = (sn[3]==1'b0) 
			? sr1
			: (sr_value) 
			? {8'b1111_1111, sr1[31:8]}
			: {8'b0000_0000, sr1[31:8]} ;

	//Level 3 (4bits)
	assign	sr3 = (sn[2]==1'b0) 
			? sr2
			: (sr_value) 
			? {4'b1111, sr2[31:4]}
			: {4'b0000, sr2[31:4]} ;
	               
	//Level 4 (2bits)
	assign	sr4 = (sn[1]==1'b0) 
			? sr3
			: (sr_value) 
			? {2'b11, sr3[31:2]}
			: {2'b00, sr3[31:2]} ;	               

	//Level 5 (1bits)
	assign	sr5 = (sn[0]==1'b0) 
			? sr4
			: (sr_value) 
			? {1'b1, sr4[31:1]}
			: {1'b0, sr4[31:1]} ;	 
	               
	assign	sr_result = sr5;
	
   	//-------------------------------------------------------------
	//	Output Mux for "dout"
        //-------------------------------------------------------------	               
	always@(sd or sl_result or sr_result)
	begin
	    if(sd==1'b0) 		//shift left
	    	dout = sl_result ;
	    else 			//shift right
	    	dout = sr_result ;
	end	               
	               
endmodule
