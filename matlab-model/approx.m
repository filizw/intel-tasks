#! /usr/bin/octave

clear

N = 128;
n = [0:N-1]';
x = 2*(n/N);

# Taylor Series:
a =    sin((2*x)-(pi/4));  # f(x)/0!
b =  2*cos((2*x)-(pi/4));  # f'(x)/1!
c = -2*sin((2*x)-(pi/4));  # f''(x)/2!

en_plot = 1; # set to 1 to enable plotting

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
for k = 0 : N-1
    i = k+1; # array indexing starts at 1
    printf("%3d  %32.28f  %32.28f  %32.28f\n", k, a(i), b(i), c(i));
endfor
