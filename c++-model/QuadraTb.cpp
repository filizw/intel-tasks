//
// QuadraTb.cpp -- test bench for the Quadratic Approximation Unit (QAU) Model
//

#include <cstdint>
#include <algorithm>    // std::max
#include <vector>
#include <iostream>
#include <iomanip>
#include <bitset>

#include "Quadra.hpp"

bool testFunction (const double & x_dbl)
{
    using namespace std;

    const int PREC  = 28;
    const int WIDTH = PREC + 3;

    // Input:
    x_fxd_t x_fxd = x_dbl;

    if constexpr (DBG_TST) {
        cout << "x_dbl  = " << dec << fixed      << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  x_dbl     << endl;
    }

    // Approximation:
#ifdef DOUBLE_OVERRIDE
    y_fxd_t y_fxd = approxDouble (x_fxd); // use this to override fixed point with doubles
#else
    y_fxd_t y_fxd = approxFixed  (x_fxd); // fixed-point data path
#endif

    // Ouput:
    double y_dbl = y_fxd.to_double();

    // Reference (CPU):
    double y_ref = sin((2.0 * x_dbl) - PI_OVER_4);

    // Error:
    double y_err = abs(y_dbl - y_ref);

    if constexpr (DBG_TST) {
        cout << "y_dbl  = " << dec << fixed      << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  y_dbl     << endl;
        cout << "y_ref  = " << dec << fixed      << setw(WIDTH) << setprecision(PREC) << setfill(' ') << right
             <<  y_ref << endl;
        cout << "y_err  = " << dec << scientific << setw(9)     << setprecision(2)    << setfill(' ') << right
             <<  y_err << endl << endl;
    }

    // Pass/fail:
    bool in_spec = (y_err < ERR_TOL);

    return in_spec;
}

bool testFunction (void)
{
    using namespace std;

    // Test params:
    uint32_t m_start = 0x000000; // 0.0
    uint32_t m_stop  = 0xffffff; // 1.999...
    uint32_t m_step  = 0x000101; // sparse test
//  uint32_t m_step  = 0x000001; // exhaustive test

    // Initialize test status:
    bool ok_sts = true;

    // Main simulation loop:
    for (uint32_t m = m_start; m <= m_stop; m += m_step)
    {
        double x_dbl = double(m) / double(0x00800000);
        //             ---------------------
        bool in_spec = testFunction (x_dbl);
        //             ---------------------

        ok_sts &= in_spec;
    }

    return ok_sts;
}

int main (int argc, char *argv[])
{
    bool ok_sts = true;

    ok_sts &= testFunction();

    int ret_sts = (ok_sts) ? 0 : -1;

    return ret_sts;
}
