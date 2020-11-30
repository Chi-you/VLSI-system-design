/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Expert(TM) in wire load mode
// Version   : Q-2019.12
// Date      : Thu Nov  5 19:17:44 2020
/////////////////////////////////////////////////////////////
`timescale 1ns/10ps

module Traffic_light ( R1G, R1Y, R1R, R2G, R2Y, R2R, FG, FY, FR, clk, rst_n, c
 );
  input clk, rst_n, c;
  output R1G, R1Y, R1R, R2G, R2Y, R2R, FG, FY, FR;
  wire   N20, N21, N22, N23, N25, N26, N27, N28, N29, n6, n7, n8, n9, n10, n11,
         n12, n13, n14, n15, n16, n17, n18, n19, n20, n27, n28, n29, n30;
  wire   [2:0] state;
  wire   [4:0] counter;
  wire   [2:0] next_state;
  wire   [4:2] \add_57/carry ;

  DFFRHQX1 \counter_reg[4]  ( .D(N29), .CK(clk), .RN(rst_n), .Q(counter[4]) );
  DFFRHQX1 \counter_reg[3]  ( .D(N28), .CK(clk), .RN(rst_n), .Q(counter[3]) );
  DFFRHQX1 \state_reg[1]  ( .D(next_state[1]), .CK(clk), .RN(rst_n), .Q(
        state[1]) );
  DFFRHQX1 \counter_reg[1]  ( .D(N26), .CK(clk), .RN(rst_n), .Q(counter[1]) );
  DFFRHQX1 \counter_reg[2]  ( .D(N27), .CK(clk), .RN(rst_n), .Q(counter[2]) );
  DFFRHQX1 \state_reg[2]  ( .D(next_state[2]), .CK(clk), .RN(rst_n), .Q(
        state[2]) );
  DFFRHQX1 \counter_reg[0]  ( .D(N25), .CK(clk), .RN(rst_n), .Q(counter[0]) );
  DFFRHQX1 \state_reg[0]  ( .D(next_state[0]), .CK(clk), .RN(rst_n), .Q(
        state[0]) );
  NAND2X1 U38 ( .A(R2R), .B(FR), .Y(n8) );
  NOR2BX1 U39 ( .AN(N23), .B(n16), .Y(N28) );
  NOR2BX1 U40 ( .AN(N22), .B(n16), .Y(N27) );
  NOR2BX1 U41 ( .AN(N21), .B(n16), .Y(N26) );
  NOR2X1 U42 ( .A(n29), .B(n7), .Y(FY) );
  NOR2X1 U43 ( .A(n29), .B(n9), .Y(R2Y) );
  NOR2X1 U44 ( .A(n29), .B(n8), .Y(R1Y) );
  NAND2X1 U45 ( .A(n7), .B(n9), .Y(R1R) );
  INVX1 U46 ( .A(n6), .Y(n30) );
  NAND3X1 U47 ( .A(n17), .B(n12), .C(n11), .Y(n16) );
  NAND3BX1 U48 ( .AN(n15), .B(state[0]), .C(n14), .Y(n17) );
  NOR3X1 U49 ( .A(counter[3]), .B(counter[4]), .C(counter[1]), .Y(n10) );
  NAND4X1 U50 ( .A(counter[3]), .B(counter[1]), .C(counter[4]), .D(n18), .Y(
        n11) );
  NOR4BX1 U51 ( .AN(counter[2]), .B(state[2]), .C(state[0]), .D(counter[0]), 
        .Y(n18) );
  INVX1 U52 ( .A(state[0]), .Y(n29) );
  NAND2X1 U53 ( .A(state[2]), .B(R2R), .Y(n7) );
  NAND2X1 U54 ( .A(state[1]), .B(FR), .Y(n9) );
  INVX1 U55 ( .A(state[2]), .Y(FR) );
  NAND3X1 U56 ( .A(counter[2]), .B(counter[0]), .C(n10), .Y(n15) );
  NOR2X1 U57 ( .A(n7), .B(state[0]), .Y(FG) );
  INVX1 U58 ( .A(state[1]), .Y(R2R) );
  OAI2BB1X1 U59 ( .A0N(n19), .A1N(c), .B0(FG), .Y(n12) );
  NAND3BX1 U60 ( .AN(n20), .B(counter[1]), .C(counter[3]), .Y(n19) );
  NAND3BX1 U61 ( .AN(counter[4]), .B(counter[0]), .C(counter[2]), .Y(n20) );
  ADDHXL U62 ( .A(counter[1]), .B(counter[0]), .CO(\add_57/carry [2]), .S(N21)
         );
  ADDHXL U63 ( .A(counter[2]), .B(\add_57/carry [2]), .CO(\add_57/carry [3]), 
        .S(N22) );
  NOR2X1 U64 ( .A(n27), .B(n16), .Y(N29) );
  XNOR2X1 U65 ( .A(\add_57/carry [4]), .B(counter[4]), .Y(n27) );
  NOR2X1 U66 ( .A(state[0]), .B(n9), .Y(R2G) );
  NOR2X1 U67 ( .A(state[0]), .B(n8), .Y(R1G) );
  ADDHXL U68 ( .A(counter[3]), .B(\add_57/carry [3]), .CO(\add_57/carry [4]), 
        .S(N23) );
  OR2X2 U69 ( .A(N20), .B(n16), .Y(N25) );
  INVX1 U70 ( .A(counter[0]), .Y(N20) );
  NAND4X1 U71 ( .A(state[0]), .B(n10), .C(counter[2]), .D(counter[0]), .Y(n6)
         );
  OAI32X1 U72 ( .A0(n28), .A1(state[2]), .A2(n6), .B0(n30), .B1(n7), .Y(
        next_state[2]) );
  INVX1 U73 ( .A(c), .Y(n28) );
  OAI32X1 U74 ( .A0(n8), .A1(c), .A2(n6), .B0(n30), .B1(n9), .Y(next_state[1])
         );
  NAND2X1 U75 ( .A(state[2]), .B(state[1]), .Y(n14) );
  NAND3X1 U76 ( .A(n11), .B(n12), .C(n13), .Y(next_state[0]) );
  NAND3X1 U77 ( .A(n14), .B(n15), .C(state[0]), .Y(n13) );
endmodule

