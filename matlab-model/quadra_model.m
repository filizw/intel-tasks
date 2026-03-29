# short script to model quadra behavior in matlab
# used to better understand the system and for debugging C++/RTL models

x_dbl  = hex2dec('0ffffff') / (2^23);
x1_dbl = hex2dec('07f') / (2^6);
x2_dbl = hex2dec('01ffff') / (2^23);

a_dbl = -0.0417470274103773492102575915;
b_dbl = -1.9983021488127477027774148155;
c_dbl = 0.0991023879466107759927950838;

sq_dbl = x2_dbl^2;

t0_dbl = a_dbl;
t1_dbl = b_dbl * x2_dbl;
t2_dbl = c_dbl * sq_dbl;

s_dbl = t0_dbl + t1_dbl + t2_dbl;

x  = int64(x_dbl);
x1 = int64(x1_dbl);
x2 = int64(x2_dbl * (2^23));

a = int64(round((a_dbl) * (2^23)));
b = int64(round((b_dbl) * (2^16)));
c = int64(round((c_dbl) * (2^11)));

x2_real = bitshift(x2, -6);

sq = int64(x2^2);

t0 = int64(a);
t1 = int64(b * x2);
t2 = int64(c * sq);

t0_aligned = bitshift(t0, 4);
t1_aligned = bitshift(t1, -12);
t2_aligned = bitshift(t2, -30);

y0 = t0_aligned + t1_aligned + t2_aligned;
y = round(bitshift(y0, -4));
y_dbl = double(y) / (2^23);

output_precision(16);

printf("x       =  0x%x     %f\n", x, double(x) / (2^23));
printf("x1      =  0x%x     %f\n", x1, double(x1) / (2^6));
printf("x2      =  0x%x     %f\n", x2, double(x2) / (2^23));
printf("a       =  0x%x     %f\n", a, double(a) / (2^23));
printf("b       =  0x%x\n", b);
printf("c       =  0x%x\n", c);
printf("sq      =  0x%x     %f\n", sq, double(sq) / (2^46));
printf("t0      =  0x%x\n", t0);
printf("t1      =  0x%x     %f\n", t1, double(t1) / (2^39));
printf("t2      =  0x%x     %f\n", t2, double(t2) / (2^57));
printf("t0_aligned  =  0x%x     %f\n", t0_aligned, double(t0_aligned) / (2^45));
printf("t1_aligned  =  0x%x     %f\n", t1_aligned, double(t1_aligned) / (2^45));
printf("t2_aligned  =  0x%x     %f\n", t2_aligned, double(t2_aligned) / (2^45));
printf("y0      =  0x%x\n", y0);
printf("y       =  0x%x\n", y);
printf("x_dbl   =  %f\n", x_dbl);
printf("y_dbl   =  %f\n", y_dbl);
printf("s_dbl   =  %f\n", s_dbl);
printf("y_real  =  %f\n", sin(2*x_dbl - pi/4));
