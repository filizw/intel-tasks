`include "quadra.vh"

module adder
(
    input  t0_t t0,
    input  t1_t t1,
    input  t2_t t2,
    output s_t  s
);
    s_t t0_aligned, t1_aligned, t2_aligned;

    always_comb begin
        // Align input numbers to (s2.27), take X1 and X2 alignment into consideration:
        t0_aligned = t0 <<< 4;  // (s1.23) to (s2.27)
        t1_aligned = t1 >>> 12; // (s3.39) to (s2.27)
        t2_aligned = t2 >>> 30; // (s2.57) to (s2.27)

        // Compute t0 + t1 + t2:
        s = t0_aligned + t1_aligned + t2_aligned;
    end

endmodule

