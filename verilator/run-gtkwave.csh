#! /bin/csh -f

set  vcd_file = "dump.vcd"
set gtkw_file = "waves.gtkw"

if (!(-f ${vcd_file})) then
   echo "Could not find VCD file ${vcd_file} -- exiting!"
   exit -1;
endif

gtkwave --save=${gtkw_file} ${vcd_file} &
