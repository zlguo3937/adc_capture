set lib_name tcbn28hpcplusbwp7t40p140tt0p8v0p8v85c
current_design cpu

# Reset all constraints
reset_design

# ================================================================================================================
# Clock Definition
# 1. Creat clock object and set uncertainty.
# 2. The maximum external clock generator delay to the clock port is 700ps. (HINT: source latency).
# 3. The maximum insertion delay from the clock port to all the register clock pins is 
#    300ps +/- 30ps. (HINT:Treat the 300ps as network latency and the +/-30ps as clock skew).
# 4. The clock period can fluctuate +/- 40ps due to jitter.
# 5. Apply 50ps of "setup margin" to the clock period.
# 6. The worst case rise/fall transition time of any clock pin is 120 ps.
# ================================================================================================================
create_clock -period 3.0 [get_ports clk]
set_clock_latency -source -max 0.7 [get_ports clk]
set_clock_latency -max 0.3 [get_ports clk]
set_clock_uncertainty -setup 0.15 [get_ports clk]
set_clock_transition 0.12 [get_ports clk]


# ================================================================================================================
# Register Setup Time
# Assume a maximum setup time of 0.2ns for any Register Setup Time register in DESIGN.
# ================================================================================================================


# ================================================================================================================
# Input ports (sequential logic)
# Set constraints on input ports
# 1. The maximum delay from ports data through the internal combination input logic is 2.2ns.
# 2. The latest F3 data arrival time at the set port is 1.4ns absolute time. (HINT: Input delav is
#    specified as relative time-relative to the launching clock edge).
# ================================================================================================================
#suppress_message UID-401
#set_driving_cell -max -library $lib_name -lib_cell sdcfq1 [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay 0.1 -max -clock clk [remove_from_collection [all_inputs] [get_ports clk]]
set_input_delay 1.2 -max -clock [get_ports Neg_Flag]


# ================================================================================================================
# Output ports (sequential logic)
# Set constraints on output ports
# 1. The maximum delay of the external combo logic at port out1 is 420ps; F6 has a setup time of 80ps.
# 2. The maximum internal delay to out2 is 810ps.
# 3. The out3 port has a 400ps setup time requirement with respect to its capturing register clock pin.
# ================================================================================================================
set_output_delay 1 -max -clock clk [[all_outputs]
set_load -max [expr [load_of $lib_name/an02d0/A1] * 15] [all_outputs]


# ================================================================================================================
# Combinational Logic
# The maximum delay from Cin1 and Cin2 to Cout is 2.45ns.(HINT: Use appropriate input and output delay constraints
# with respect to clock clk)
# ================================================================================================================
