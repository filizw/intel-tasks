#! /usr/bin/octave

clear

M = 128;
n = [0:M-1]';
x = 2*(n/M);

f = @(x) sin((2*x)-(pi/4)); # function to approximate

q = 6; # max error = 2^(-q)

N = 3; # number of polynomial terms
Nth_diff = -8*cos(2*x - pi/4); # Nth (third) derivative of f(x)
[~, max_Nth_diff] = max(abs(Nth_diff)); # max value of Nth derivative of f(x) over the interval [0, 2]

# compute m bits required to store the coefficients
m = ceil((q - 2*N + 3 + log2(max_Nth_diff)) - log2(factorial(N)) / N); # this also equals 7
#m = 7; # default value

# update M based on m to obtain 2^m coefficients:
M = 2^m;
n = [0:M-1]';
x = 2*(n/M);

# compute the coefficients using formulas derived from chebyshev polynomial approximation:
y0 = f(x + (sqrt(3)/2 + 1) * 2^(-m-1));
y1 = f(x + 2^(-m-1));
y2 = f(x + (1 - sqrt(3)/2) * 2^(-m-1));

a = (1/3)*y0*(2 - sqrt(3)) - (1/3)*y1 + (1/3)*y2*(sqrt(3) + 2);
b = (1/6)*y0*(sqrt(3) - 4)*2^(m+2) + (1/3)*y1*2^(m+4) - (1/6)*y2*(sqrt(3) + 4)*2^(m+2);
c = (1/3)*(y0 - 2*y1 + y2)*2^(2*m+3);

en_plot = 0; # set to 1 to enable plotting

# Plot the coefficients:
if (en_plot)
    close
    plot (x, a, 'b-*', x, b, 'r-*', x, c, 'g-*')
    xlabel("x")
    ylabel("coeff")
    title("Approximation coefficients for f(x) = sin((2*x)-(pi/4))")
    legend('a', 'b', 'c', 'location', 'northeast')
    axis ([0, 2, -2.2, 2.2])
    grid on
    pause()
endif

coeffs = [n a b c];
format long

# Print out the coefficients:
printf("%3s  %32s  %32s  %32s\n", "# k", "a", "b", "c");
for k = 0 : M-1
    i = k+1; # array indexing starts at 1
    printf("%3d  %32.28f  %32.28f  %32.28f\n", k, a(i), b(i), c(i));
endfor

