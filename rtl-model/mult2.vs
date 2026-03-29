`include "quadra.vh"

module mult2
(
    input  c_t  c,
    input  sq_t sq,
    output t2_t t2
);
    // Compute c * sq:
    always_comb t2 = c * sq;

endmodule
