#! /bin/csh -f

rm -rf run-verilator.log

set TOP_DIR = ${HOME}/prj/coding-exercise2s
set ACT_DIR = ${TOP_DIR}/libs/ac_types/include
set CPP_DIR = ${TOP_DIR}/c++-model
set RTL_DIR = ${TOP_DIR}/rtl-model

echo "--------------------------------------------------------------------------------"
echo "Compiling with 'verilator' ..."
echo "--------------------------------------------------------------------------------"

set top_module = "quadra_top"

verilator \
    --cc \
    -CFLAGS "-std=c++17 -I${ACT_DIR} -I${CPP_DIR}" \
    ${CPP_DIR}/Quadra.cpp \
    sim_main.cpp \
    --exe \
    --build \
    --timing \
#   uncomment next line to enable VCD tracing: \
    --trace \
    -j 0 \
    -Wall \
#   -Wno-VARHIDDEN \
    -Wno-UNUSEDSIGNAL \
#   -Wno-UNDRIVEN \
#   -Wno-PINCONNECTEMPTY \
#   -Wno-GENUNNAMED \
#   -Wno-UNUSEDGENVAR \
    -Wno-UNUSEDPARAM \
    -Wno-WIDTHTRUNC \
    -Wno-WIDTHEXPAND \
#   -Wno-COMBDLY \
#   -Wno-REALCVT \
    \
    --error-limit 20 \
    --timescale 1ps/1ps \
    --timescale-override 1ps/1ps \
    --top-module ${top_module} \
    --clk screuclk \
    \
    +define+NOFLOPDELAY=1 \
    \
    +incdir+${RTL_DIR} \
    +incdir+${CPP_DIR} \
    \
    +1800-2009ext+vs \
    ${RTL_DIR}/quadra_top.vs \
    ${RTL_DIR}/square.vs \
    ${RTL_DIR}/lut.vs \
    ${RTL_DIR}/quadra.vs

echo "--------------------------------------------------------------------------------"
echo "... done with 'verilator'."
echo "--------------------------------------------------------------------------------"
