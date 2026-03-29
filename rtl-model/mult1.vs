`include "quadra.vh"

module mult1
(
    input  b_t  b,
    input  x2_t x2,
    output t1_t t1
);
    // Compute b * x2:
    always_comb t1 = b * x2;

endmodule
