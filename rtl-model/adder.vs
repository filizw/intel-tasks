`include "quadra.vh"

module adder
(
    input  t0_t t0,
    input  t1_t t1,
    input  t2_t t2,
    output s_t  s
);
    // Compute t0 + t1 + t2:
    always_comb begin
        // First align all numbers to the number with the longest fractional part, which is T2
        // Then perform addition and align the result to the (s2.27) format
        s = ((t0 <<< (T2_F - T0_F)) + (t1 <<< (T2_F - T1_F)) + t2) >>> (T2_F - S_F);
    end

endmodule

