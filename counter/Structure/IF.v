`timescale 1ns/10ps

module IF(a, mode, Y);
input [4:0] a;
input mode;
output [1:0] Y;
wire H, L;
wire [4:0] a_;
// if a == 30 (11110)
not (a_[0], a[0]);
not (a_[1], a[1]);
not (a_[2], a[2]);
not (a_[3], a[3]);
not (a_[4], a[4]);
not (mode_, mode);
and (H, a[4], a[3], a[2], a[1], a_[0], mode_);
and (L, a_[4], a_[3], a_[2], a_[1], a_[0], mode);
or (Y[1], H, L);
nor (Y[0], H, L);

// if a == 0 (00000)
// not (b_[0], a[0]);
// not (b_[1], a[1]);
// not (b_[2], a[2]);
// not (b_[3], a[3]);
// not (b_[4], a[4]);
// and (B, b_[4], b_[3], b_[2], b_[1], b_[0]);
// and (m1, B, mode);


// or (T, A, B); // repeat

endmodule