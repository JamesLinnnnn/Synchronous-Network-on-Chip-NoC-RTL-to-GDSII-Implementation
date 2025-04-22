###################################################################

# Created by write_sdc on Sat Apr 19 18:46:34 2025

###################################################################
set sdc_version 2.0

set_units -time ns -resistance kOhm -capacitance pF -voltage V -current uA
set_max_capacitance 5 [current_design]
create_clock [get_ports clk]  -period 500  -waveform {0 250}
