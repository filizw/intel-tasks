//
// Quadratic polynomial:  f(x) = a + b*x2 + c*(x2^2)
//

`include "quadra.vh"

module quadra
(
    input  ck_t clk,
    input  rs_t rst_b,
    input  x_t  x,
    output y_t  y
);

    x1_t x1;
    x2_t x2, x2_reg;

    a_t a, a_reg;
    b_t b, b_reg;
    c_t c, c_reg;

    sq_t sq, sq_reg;

    t0_t t0, t0_reg;
    t1_t t1, t1_reg;
    t2_t t2, t2_reg;

    s_t s;
    y_t y_reg;

    // Split x into x1 and x2:
    always_comb {x1, x2} = x;

    // Pipeline stage 1 (LUT and squarer):
    lut lut_0 (
        .x1(x1),
        .a(a),
        .b(b),
        .c(c)
    );

    square square_0 (
        .x2(x2),
        .sq(sq)
    );

    always_ff @(posedge clk)
    if (!rst_b) begin
        a_reg  <= '0;
        b_reg  <= '0;
        c_reg  <= '0;
        x2_reg <= '0;
        sq_reg <= '0;
    end else begin
        a_reg  <= a;
        b_reg  <= b;
        c_reg  <= c;
        x2_reg <= x2;
        sq_reg <= sq;
    end

    always_comb t0 = a_reg;

    // Pipeline stage 2 (multiplier):
    mult1 mult1_0 (
        .b(b_reg),
        .x2(x2_reg),
        .t1(t1)
    );

    mult2 mult2_0 (
        .c(c_reg),
        .sq(sq_reg),
        .t2(t2)
    );

    always_ff @(posedge clk)
    if (!rst_b) begin
        t0_reg <= '0;
        t1_reg <= '0;
        t2_reg <= '0;
    end else begin
        t0_reg <= t0;
        t1_reg <= t1;
        t2_reg <= t2;
    end

    // Pipeline stage 3 (adder):
    adder adder_0 (
        .t0(t0_reg),
        .t1(t1_reg),
        .t2(t2_reg),
        .s(s)
    );


    logic lsb, guard, round, sticky, round_up;

    // Calculate round_up bit to perform round to the nearest even:
    always_comb begin
        lsb    = s[4];
        guard  = s[3];
        round  = s[2];
        sticky = |s[1:0];

        round_up = guard & (round | sticky | lsb);
    end

    always_ff @(posedge clk)
    if (!rst_b) begin
        y_reg <= '0;
    end else begin
        // Convert from (s2.27) to (s.2.23) and apply rounding:
        y_reg <= (s >>> 4) + round_up;
    end

    always_comb y = y_reg;

endmodule
