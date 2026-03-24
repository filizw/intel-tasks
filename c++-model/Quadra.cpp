//
// Quadra.cpp -- bit-accurate C++ model of the Quadratic Approximation Unit (QAU)
//

// Approximation of f(x) = sin((2*x)-(pi/4)) for x in [0, 2)

#include <iostream>
#include <iomanip>
#include <bitset>
#include <cmath>

#include "Quadra.hpp"

#include "CoeffTable.hpp"

using namespace std;

y_fxd_t approxDouble (const x_fxd_t & x_fxd)
{
    using namespace std;

    const int PREC  = 28;
    const int WIDTH = PREC + 3;

    if constexpr (DBG_OUT) {
        cout << "x_fxd  = "
             << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << x_fxd.to_double() << endl;
    }

    // Break up into LUT index and delta:
     x_int_t  x_int = x_fxd.slc<X_W>     (0); // u24 -> [23: 0]
    x1_int_t x1_int = x_int.slc<X1_W> (X2_W); // u7  -> [23:17]
    x2_int_t x2_int = x_int.slc<X2_W>    (0); // u17 -> [16: 0]

    if constexpr (DBG_OUT) {
        cout << "x1_int =  0x"
             << hex << fixed << setw(2) << setfill('0') << right
             << x1_int.to_int() << endl;
        cout << "x2_int =  0x"
             << hex << fixed << setw(5) << setfill('0') << right
             << x2_int.to_int() << endl;
    }

    x1_fxd_t x1_fxd = 0; x1_fxd.set_slc(0, x1_int); // u1.6
    x2_fxd_t x2_fxd = 0; x2_fxd.set_slc(0, x2_int); // u(-6).23

    if constexpr (DBG_OUT) {
        cout << "x1_fxd = "
             << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << x1_fxd.to_double() << endl;
        cout << "x2_fxd = "
             << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << x2_fxd.to_double() << endl;
    }

    double x2_dbl = x2_fxd.to_double();

    if constexpr (DBG_OUT) {
        cout << "x2_dbl = "
             << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << x2_dbl << endl;
    }

    // Table index:
    x1_int_t index = x1_int;

    if constexpr (DBG_OUT) {
        cout << "index  =  "
             << dec << fixed << setw(3) << setfill(' ') << left
             << index.to_int() << endl;
    }

    // Double coefficients:
    double a_dbl = CoeffTable[index][1];
    double b_dbl = CoeffTable[index][2];
    double c_dbl = CoeffTable[index][3];

    if constexpr (DBG_OUT) {
        cout << "a_dbl  = "   << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  a_dbl << endl;
        cout << "b_dbl  = "   << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  b_dbl << endl;
        cout << "c_dbl  = "   << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  c_dbl << endl;
    }

    // Calculate quadratic polynomial:
    double b_x2   =  b_dbl * x2_dbl; //  b * x2
    double x2sq   = x2_dbl * x2_dbl; // x2 * x2
    double c_x2sq =  c_dbl * x2sq;   //  c * x2^2

    if constexpr (DBG_OUT) {
        cout << "b_x2   = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             <<  b_x2 << endl;
        cout << "x2sq   = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             <<  x2sq << endl;
        cout << "c_x2sq = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             <<  c_x2sq << endl;
    }

    double t0 = a_dbl;
    double t1 = b_x2;
    double t2 = c_x2sq;

    if constexpr (DBG_OUT) {
        cout << "t0     = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             << t0 << endl;
        cout << "t1     = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             << t1 << endl;
        cout << "t2     = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             << t2 << endl;
    }

    // 3-way addition:
    double sum = t0 + t1 + t2;

    if constexpr (DBG_OUT) {
        cout << "sum    = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << sum << endl;
    }
    
    // Round:
    y_rnd_t y_rnd = sum;

    // Output:
    y_fxd_t y_fxd = y_rnd;

    if constexpr (DBG_OUT) {
        cout << "y_fxd  = "
             << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << y_fxd.to_double() << endl;
    }

    return y_fxd;
}

y_fxd_t approxFixed (const x_fxd_t & x_fxd)
{
    using namespace std;

    const int PREC  = 28;
    const int WIDTH = PREC + 3;

    if constexpr (DBG_OUT) {
        cout << "x_fxd  = "
             << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << x_fxd.to_double() << endl;
    }

    // Break up into LUT index and delta:
     x_int_t  x_int = x_fxd.slc<X_W>     (0); // u24 -> [23: 0]
    x1_int_t x1_int = x_int.slc<X1_W> (X2_W); // u7  -> [23:17]
    x2_int_t x2_int = x_int.slc<X2_W>    (0); // u17 -> [16: 0]

    if constexpr (DBG_OUT) {
        cout << "x1_int =  0x"
             << hex << fixed << setw(2) << setfill('0') << right
             << x1_int.to_int() << endl;
        cout << "x2_int =  0x"
             << hex << fixed << setw(5) << setfill('0') << right
             << x2_int.to_int() << endl;
    }

    x1_fxd_t x1_fxd = 0; x1_fxd.set_slc(0, x1_int); // u1.6
    x2_fxd_t x2_fxd = 0; x2_fxd.set_slc(0, x2_int); // u(-6).23

    if constexpr (DBG_OUT) {
        cout << "x1_fxd = "
             << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << x1_fxd.to_double() << endl;
        cout << "x2_fxd = "
             << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << x2_fxd.to_double() << endl;
    }

    // Square:
    sq_fxd_t sq_fxd = x2_fxd * x2_fxd; // x2 * x2

    if constexpr (DBG_OUT) {
        cout << "sq_fxd = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             <<  sq_fxd.to_double() << endl;
    }

    // Table index:
    x1_int_t index = x1_int;

    if constexpr (DBG_OUT) {
        cout << "index  =  "
             << dec << fixed << setw(3) << setfill(' ') << left
             << index.to_int() << endl;
    }

    // Double coefficients:
    double a_dbl = CoeffTable[index][1];
    double b_dbl = CoeffTable[index][2];
    double c_dbl = CoeffTable[index][3];

    // Double to fixed-point:
    a_fxd_t a_fxd = a_dbl;
    b_fxd_t b_fxd = b_dbl;
    c_fxd_t c_fxd = c_dbl;

    if constexpr (DBG_OUT) {
        cout << "a_dbl  = "   << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  a_dbl << endl;
        cout << "a_fxd  = "   << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  a_fxd.to_double() << endl;
        cout << "b_dbl  = "   << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  b_dbl << endl;
        cout << "b_fxd  = "   << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  b_fxd.to_double() << endl;
        cout << "c_dbl  = "   << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  c_dbl << endl;
        cout << "c_fxd  = "   << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  c_fxd.to_double() << endl;
    }

    // Calculate quadratic polynomial:
    t0_fxd_t t0_fxd =  a_fxd;          //  a
    t1_fxd_t t1_fxd =  b_fxd * x2_fxd; //  b * x2
    t2_fxd_t t2_fxd =  c_fxd * sq_fxd; //  c * x2^2

    if constexpr (DBG_OUT) {
        cout << "t0_fxd = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             << t0_fxd.to_double() << endl;
        cout << "t1_fxd = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             << t1_fxd.to_double() << endl;
        cout << "t2_fxd = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << right
             << t2_fxd.to_double() << endl;
    }

    // 3-way addition:
    s_fxd_t s_fxd = t0_fxd + t1_fxd + t2_fxd;

    if constexpr (DBG_OUT) {
        cout << "s_fxd  = " << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << s_fxd.to_double() << endl;
    }
    
    // Round:
    y_rnd_t y_rnd = s_fxd;

    // Output:
    y_fxd_t y_fxd = y_rnd;

    if constexpr (DBG_OUT) {
        cout << "y_fxd  = "
             << dec << fixed << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             << y_fxd.to_double() << endl;
    }

    return y_fxd;
}
