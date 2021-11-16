# set the working dir, where all compiled verilog goes
vlib work

# compile all verilog modules in restoring_divisor.v to working dir
vlog restoring_divisor.v

# load simulation using restoringDivisor as the top level simulation module
vsim restoringDivisor

# log all signals and add some signals to waveform window
log {/*}
add wave {/*}

# log signs from control and datapath modules
log {D0/x}
add wave {D0/x}
log {D0/y}
add wave {D0/y}
log {D0/a}
add wave {D0/a}
log {C0/current_state}
add wave {C0/current_state}

# start =============================================================
force {Clock} 0
force {Resetn} 0
force {Go} 0

# 7/3 = 2R1
force {Divisor} 0011
force {Dividend} 0111
run 10ns

force {Clock} 1
force {Resetn} 0
force {Go} 0
run 10ns

force {Clock} 0
force {Resetn} 1
force {Go} 0
run 10ns

force {Clock} 1
force {Resetn} 1
force {Go} 0
run 10ns

force {Clock} 0
force {Resetn} 1
force {Go} 1
run 10ns

force {Clock} 1
force {Resetn} 1
force {Go} 1
run 10ns

force {Clock} 0
force {Resetn} 1
force {Go} 0
run 10ns

force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns

force {Dividend} 0000
force {Divisor} 1101
force {Go} 1

force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns

# changing the inputs mid-calculation should not interrupt the calculation
force {Dividend} 1010
force {Divisor} 1110
force {Go} 1

force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns

force {Dividend} 1010
force {Divisor} 1110
force {Go} 0

force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns

force {Dividend} 1000
force {Divisor} 0011
force {Go} 0

force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns

# perform calculation for the next dividend and divisor
force {Clock} 1
run 10ns

force {Go} 1
force {Clock} 0
run 10ns

force {Go} 1
force {Clock} 1
run 10ns

force {Go} 0
force {Clock} 0
run 10ns

force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
force {Clock} 1
run 10ns
force {Clock} 0
run 10ns
