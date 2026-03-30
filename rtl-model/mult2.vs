`include "quadra.vh"

module mult2
(
    input  c_t  c,
    input  sq_t sq,
    output t2_t t2
);
    // Compute c * sq:
    // Extend SQ and convert it to the same format as C
    always_comb t2 = c * $signed({1'b0, sq});

endmodule
