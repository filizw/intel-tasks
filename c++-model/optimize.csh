#!/bin/csh -f

# Script to iteratively optimize the bit widths of the coefficients A, B and C

# Initial bit widths:
set A_base = 28
set B_base = 28
set C_base = 28

# Best bit widths obtained by algorithm:
set A_best = $A_base
set B_best = $B_base
set C_best = $C_base

# Variables to hold current bit widths during optimization:
set A = $A_base
set B = $B_base
set C = $C_base

# Step sizes for bit widths:
set dA_base = 5
set dB_base = 5
set dC_base = 5

# Initial step sizes:
set dA = $dA_base
set dB = $dB_base
set dC = $dC_base

# Maximum number of iterations:
set MAX_ITER = 20

# Path to testbench executable:
set run_tb = ./QuadraTb


# INITIAL TEST
make clean >& /dev/null
make DEFS="-DDV_A=$A -DDV_B=$B -DDV_C=$C" >& /dev/null

$run_tb
set ok = $status

if ( $ok != 0 ) then
    echo "ERROR: Initial configuration does NOT meet constraint"
    exit 1
endif

echo "Initial OK: A=$A B=$B C=$C"

# Number of orders which coefficents are optimized in (different orders may lead to different results):
set orders = (1 2 3 4 5 6)

# Variable to hold the best result obtained by algorithm:
set best_result = 0


# Iterate through each order:
foreach order ( $orders )
    # Set initial values at the start of each outer iteration:
    set A = $A_base
    set B = $B_base
    set C = $C_base

    set dA = $dA_base
    set dB = $dB_base
    set dC = $dC_base

    # Choose order:
    if ( $order == 1 ) then
        set coeffs = (A B C)
    else if ( $order == 2 ) then
        set coeffs = (A C B)
    else if ( $order == 3 ) then
        set coeffs = (B A C)
    else if ( $order == 4 ) then
        set coeffs = (B C A)
    else if ( $order == 5 ) then
        set coeffs = (C A B)
    else
        set coeffs = (C B A)
    endif

    # Reset result:
    @ result = 0

    # Iterate through each coefficient in the chosen order:
    foreach coeff ($coeffs)
        set A_trial = $A
        set B_trial = $B
        set C_trial = $C

        # Reset number of iterations for each coefficient:
        @ iter = 0

        # Choose coefficient:
        if ( $coeff == "A" ) then
            # Optimize A:
            while ($iter < $MAX_ITER && $dA != 0)
                @ A_trial = $A - $dA

                make clean >& /dev/null
                make DEFS="-DDV_A=$A_trial -DDV_B=$B_trial -DDV_C=$C_trial" >& /dev/null

                $run_tb
                set ok = $status

                if ( $ok == 0 ) then
                    # Perserve step size for next iteration
                    set A = $A_trial
                    echo "OK: A=$A B=$B C=$C"
                else
                    # Decease step size for next iteration
                    @ dA--
                endif
                
                @ iter++
            end
        else if ( $coeff == "B" ) then
            # Optimize B:
            while ($iter < $MAX_ITER && $dB != 0)
                @ B_trial = $B - $dB

                make clean >& /dev/null
                make DEFS="-DDV_A=$A_trial -DDV_B=$B_trial -DDV_C=$C_trial" >& /dev/null

                $run_tb
                set ok = $status

                if ( $ok == 0 ) then
                    # Perserve step size for next iteration
                    set B = $B_trial
                    echo "OK: A=$A B=$B C=$C"
                else
                    # Decease step size for next iteration
                    @ dB--
                endif

                @ iter++
            end
        else
            while ($iter < $MAX_ITER && $dC != 0)
                # Optimize C:
                @ C_trial = $C - $dC

                make clean >& /dev/null
                make DEFS="-DDV_A=$A_trial -DDV_B=$B_trial -DDV_C=$C_trial" >& /dev/null

                $run_tb
                set ok = $status

                if ( $ok == 0 ) then
                    # Perserve step size for next iteration
                    set C = $C_trial
                    echo "OK: A=$A B=$B C=$C"
                else
                    # Decease step size for next iteration
                    @ dC--
                endif

                @ iter++
            end
        endif
    end

    # Calculate the result:
    @ result = $A_base + $B_base + $C_base - $A - $B - $C

    echo "=============================="
    echo "RESULT: A=$A B=$B C=$C"
    echo "=============================="

    # Check if the result is better than the best result obtained so far:
    if ( $result > $best_result ) then
        set best_result = $result
        set A_best = $A
        set B_best = $B
        set C_best = $C
    endif
end


# Display final result:
echo "=============================="
echo "FINAL RESULT: A=$A_best B=$B_best C=$C_best"
echo "=============================="
