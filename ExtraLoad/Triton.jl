Triton_temperatureT1_get(instr) = split(query(instr, "READ:DEV:T1:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT2_get(instr) = split(query(instr, "READ:DEV:T2:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT3_get(instr) = split(query(instr, "READ:DEV:T3:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT4_get(instr) = split(query(instr, "READ:DEV:T4:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT5_get(instr) = split(query(instr, "READ:DEV:T5:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT6_get(instr) = split(query(instr, "READ:DEV:T6:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT7_get(instr) = split(query(instr, "READ:DEV:T7:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT8_get(instr) = split(query(instr, "READ:DEV:T8:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT13_get(instr) = split(query(instr, "READ:DEV:T13:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]