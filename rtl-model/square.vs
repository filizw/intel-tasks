`include "quadra.vh"

module square
(
    input  x2_t x2,
    output sq_t sq
);
    // Compute x2^2:
    // Align the result to the T2 format
    always_comb sq = (x2 * x2) >>> 12;

endmodule    
