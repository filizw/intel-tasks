`include "quadra.vh"

module mult1
(
    input  b_t  b,
    input  x2_t x2,
    output t1_t t1
);
    // Compute b * x2:
    // Extend X2 and convert it to the same format as B
    always_comb t1 = (b * $signed({1'b0, x2})) >>> 6;

endmodule
