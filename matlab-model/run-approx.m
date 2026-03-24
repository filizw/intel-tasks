#! /bin/csh -f

if (-f coeffs.txt) then
    rm coeffs.txt
endif

octave approx.m |& tee coeffs.txt

# optionally, use optimized coeffs:
#ctave approx_opt.m |& tee coeffs.txt

octave print_coeffs.m |& tee hex_coeffs.txt



