//
// Quadra.hpp
//

#ifndef __QUADRA_HPP
#define __QUADRA_HPP

#ifndef DBG_OUT
#define DBG_OUT 0
#endif

#ifndef DBG_TST
#define DBG_TST 0
#endif

#include <ac_int.h>
#include <ac_fixed.h>
#include <ac_float.h>

// --------------------------------------------------------------------------------
const double ERR_TOL = 2.150e-6; // approximation error must be below this value
// --------------------------------------------------------------------------------

const double PI_OVER_4 = M_PI / 4.0;

// rounding modes:
const ac_q_mode rdz = AC_RND_ZERO; // round ties towards zero to avoid rounding up at range edges (eg. 1.999.. to 2.000..)
const ac_q_mode rne = AC_RND_CONV; // round ties towards nearest even
const ac_q_mode trn = AC_TRN;      // truncate

// data valid:
typedef bool dv_t;

// --------------------------------------------------------------------------------
// I/O precision
// --------------------------------------------------------------------------------

// Input x in [0,2] -> u1.23
const int X_I =  1;          // integer part
const int X_F = 23;          // fractional part
const int X_W = X_I + X_F;   // bit width

typedef ac_int  <X_W,      false>                x_int_t;
typedef ac_fixed<X_W, X_I, false, trn, AC_WRAP>  x_fxd_t; // u1.23

// x1: x[23:17] -> u1.6
const int X1_I =  1;          // integer part
const int X1_F =  6;          // fractional part
const int X1_W = X1_I + X1_F; // bit width

typedef ac_int  <X1_W,       false>               x1_int_t;
typedef ac_fixed<X1_W, X1_I, false, trn, AC_WRAP> x1_fxd_t; // u1.6

// x2: x[16:0] -> u0.17
const int X2_I =  0;          // integer part
const int X2_J = X2_I - X1_F; // (this is key for proper alignment)
const int X2_F =  X_W - X1_W; // fractional part
const int X2_W = X2_I + X2_F; // bit width

typedef ac_int  <X2_W,       false>               x2_int_t;
typedef ac_fixed<X2_W, X2_J, false, trn, AC_WRAP> x2_fxd_t; // u0.17

// Coefficients:
// a:
const int A_I =  4;  // <optimize>
const int A_F = 28;  // <optimize>
const int A_W = A_I + A_F;

typedef ac_int  < A_W,       true>               a_int_t;
typedef ac_fixed< A_W,  A_I, true, rdz, AC_WRAP> a_fxd_t;

// b:
const int B_I =  4;  // <optimize>
const int B_F = 28;  // <optimize>
const int B_W = B_I + B_F;

typedef ac_int  < B_W,       true>               b_int_t;
typedef ac_fixed< B_W,  B_I, true, rdz, AC_WRAP> b_fxd_t;

// c:
const int C_I =  4;  // <optimize>
const int C_F = 28;  // <optimize>
const int C_W = C_I + C_F;

typedef ac_int  < C_W,       true>               c_int_t;
typedef ac_fixed< C_W,  C_I, true, rdz, AC_WRAP> c_fxd_t;

// Output y in [-2,2) -> u2.23
const int Y_I =  2;        // integer part
const int Y_F = 23;        // fractional part
const int Y_W = Y_I + Y_F; // bit width

typedef ac_int  <Y_W,      true>               y_int_t;
typedef ac_fixed<Y_W, Y_I, true, rne, AC_WRAP> y_rnd_t; // (round)
typedef ac_fixed<Y_W, Y_I, true, trn, AC_WRAP> y_fxd_t; // (truncate)

// --------------------------------------------------------------------------------
// Internal precision:
// --------------------------------------------------------------------------------

// extra working fractional bits to be rounded off at the end
const int R_F = 4;

const int S_I = Y_I;
const int S_F = Y_F + R_F;  // (4 extra fractional bits to be rounded)
const int S_W = S_I + S_F;

typedef ac_fixed< S_W,  S_I, true, trn, AC_WRAP> s_fxd_t; // s = t0 + t1 + t2

// Polynomial calculation:

const int SQ_I = X2_I + X2_I;
#ifdef FULL_PRECISION
const int SQ_F = X2_F + X2_F;
#else
const int SQ_F = 24;
#endif
const int SQ_W = SQ_I + SQ_F;

typedef ac_fixed<SQ_W, SQ_I, false, trn, AC_WRAP> sq_fxd_t; // sq = x2 * x2

const int T0_I =  A_I;
#ifdef FULL_PRECISION
const int T0_F =  A_F;
#else
const int T0_F =  S_F;
#endif
const int T0_W = T0_I + T0_F;

typedef ac_fixed<T0_W, T0_I,  true, trn, AC_WRAP> t0_fxd_t; // t0 = a

const int T1_I =  B_I + X2_I;
#ifdef FULL_PRECISION
const int T1_F =  B_F + X2_F;
#else
const int T1_F =  S_F;
#endif
const int T1_W = T1_I + T1_F;

typedef ac_fixed<T1_W, T1_I,  true, trn, AC_WRAP> t1_fxd_t; // t1 = b * x2

const int T2_I =  C_I + SQ_I;
#ifdef FULL_PRECISION
const int T2_F =  C_F + SQ_F;
#else
const int T2_F =  S_F;
#endif
const int T2_W = T2_I + T2_F;

typedef ac_fixed<T2_W, T2_I,  true, trn, AC_WRAP> t2_fxd_t; // t2 = c * x2^2
                                      
// Top function prototype:
y_fxd_t approxDouble(const x_fxd_t & x_fxd);
y_fxd_t approxFixed (const x_fxd_t & x_fxd);

#endif
