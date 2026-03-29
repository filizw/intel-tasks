##
## Convert signed coeffs to hex:
##

load coeffs.txt

k = coeffs(:,1);
a = coeffs(:,2);
b = coeffs(:,3);
c = coeffs(:,4);

K = length(k);

# coeff a:
A_I =  1;
A_F = 23;
A_W = A_I + A_F; # (s1.23)

# coeff b:
B_I =  3;
B_F = 16;
B_W = B_I + B_F; # (s3.16)

# coeff c:
C_I =  2;
C_F = 11;
C_W = C_I + C_F; # (s2.11)

a_q = round(a * (2^A_F));
b_q = round(b * (2^B_F));
c_q = round(c * (2^C_F));

A = zeros(K,1);
B = zeros(K,1);
C = zeros(K,1);

# Print out the coefficients:
for k = 0 : K-1
    i = k+1; # array indexing starts at 1
    if (a_q(i) < 0)
        A(i) = a_q(i) + (2^A_W);
    else
        A(i) = a_q(i);
    end
    if (b_q(i) < 0)
        B(i) = b_q(i) + (2^B_W);
    else
        B(i) = b_q(i);
    end
    if (c_q(i) < 0)
        C(i) = c_q(i) + (2^C_W);
    else
        C(i) = c_q(i);
    end
    printf("%3d  0x%08x  0x%08x  0x%08x\n", k, A(i), B(i), C(i));
endfor
