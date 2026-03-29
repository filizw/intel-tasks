// quadra.vh

`ifndef QUADRA_VH
`define QUADRA_VH

typedef logic ck_t; // clock
typedef logic rs_t; // reset
typedef logic dv_t; // data valid

// --------------------------------------------------------------------------------
// I/O precision
// --------------------------------------------------------------------------------

// x in [0,2) -> u1.23
localparam int  X_I =  1;          //         =  1
localparam int  X_F = 23;          //         = 23
localparam int  X_W = X_I + X_F;   //  1 + 23 = 24 (u1.23)

typedef logic [X_W-1:0] x_t;

// y [-2,2) -> s2.23
localparam int  Y_I =  2;          //         =  2
localparam int  Y_F = 23;          //         = 23
localparam int  Y_W = Y_I + Y_F;   //  2 + 23 = 25 (s2.23)

typedef logic signed [Y_W-1:0] y_t;

// --------------------------------------------------------------------------------
// Internal precision:
// --------------------------------------------------------------------------------

// <challenge!>

// X split into X1 and X2:

localparam int X1_I = 1;                //        = 1
localparam int X1_F = 6;                //        = 6
localparam int X1_W = X1_I + X1_F;      //  1 + 6 = 7 (u1.6)

typedef logic [X1_W-1:0] x1_t;

localparam int X2_I = 0;                //         =  0
localparam int X2_F = X_W - X1_W;       //  24 - 7 = 17
localparam int X2_W = X2_I + X2_F;      //  0 + 17 = 17 (u0.17)

typedef logic [X2_W-1:0] x2_t;

// Coefficients:

localparam int A_I = 1;                 //         =  1
localparam int A_F = 23;                //         = 23
localparam int A_W = A_I + A_F;         //  1 + 23 = 24 (s1.23)

typedef logic signed [A_W-1:0] a_t;

localparam int B_I = 3;                 //         =  3
localparam int B_F = 16;                //         = 16
localparam int B_W = B_I + B_F;         //  3 + 16 = 19 (s3.16)

typedef logic signed [B_W-1:0] b_t;

localparam int C_I = 2;                 //         =  2
localparam int C_F = 11;                //         = 11
localparam int C_W = C_I + C_F;         //  2 + 11 = 13 (s2.11)

typedef logic signed [C_W-1:0] c_t;

// Intermediate results:

// SQ = X2^2:
localparam int SQ_I = 0;                //         =  0
localparam int SQ_F = X2_F*2;           //  17 * 2 = 34
localparam int SQ_W = SQ_I + SQ_F;      //  0 + 34 = 34 (u0.34)

typedef logic [SQ_W-1:0] sq_t;

// T0 = A:
localparam int T0_I = A_I;              //         =  1
localparam int T0_F = A_F;              //         = 23
localparam int T0_W = T0_I + T0_F;      //  1 + 23 = 24 (s1.23)

typedef logic signed [T0_W-1:0] t0_t;

// T1 = B * X2:
localparam int T1_I = B_I + X2_I;       //   3 + 0 =  3
localparam int T1_F = B_F + X2_F;       // 16 + 17 = 33
localparam int T1_W = T1_I + T1_F;      //  3 + 33 = 36 (s3.33)

typedef logic signed [T1_W-1:0] t1_t;

// T2 = C * SQ:
localparam int T2_I = C_I + SQ_I;       //   2 + 0 =  2
localparam int T2_F = C_F + SQ_F;       // 11 + 34 = 45
localparam int T2_W = T2_I + T2_F;      //  2 + 45 = 47 (s2.45)

typedef logic signed [T2_W-1:0] t2_t;

// Extra bits for rounding the final result:
localparam int R_F = 4;

// S = T0 + T1 + T2:
localparam int S_I = Y_I;               //         =  2
localparam int S_F = Y_F + R_F;         //  23 + 4 = 27
localparam int S_W = S_I + S_F;         //  2 + 27 = 29 (s2.27)

typedef logic signed [S_W-1:0] s_t;

`endif
