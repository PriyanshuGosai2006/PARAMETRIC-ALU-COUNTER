# Define a 100 MHz clock (10.000 ns period) on the top-level 'clk' port
create_clock -period 10.000 -name sys_clk_pin -waveform {0.000 5.000} [get_ports clk]
