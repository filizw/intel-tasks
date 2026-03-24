#! /usr/bin/octave

clear
close

load "../c++-model/err.dat"

plot(err, 'b-*')
xlabel("n")
ylabel("err")
title("Approximation Error")
legend('err', 'location', 'northeast')
grid on

max_err = max(err);
printf("max(err) = %8.3e\n", max_err);

pause()


