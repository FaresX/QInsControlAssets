MercuryiTC_temperature_get(instr) = split(query(instr, "READ:DEV:MB1.T1:TEMP:SIG:TEMP"), "SIG:TEMP:")[end][1:end-1]

MercuryiTC_settemp_set(instr, val) = query(instr, "SET:DEV:MB1.T1:TEMP:LOOP:TSET:$val")
MercuryiTC_settemp_get(instr) = split(query(instr, "READ:DEV:MB1.T1:TEMP:LOOP:TSET"), "TSET:")[end][1:end-1]

MercuryiTC_setheater_set(instr, val) = query(instr, "SET:DEV:MB1.T1:TEMP:LOOP:HSET:$val")
MercuryiTC_setheater_get(instr) = split(query(instr, "READ:DEV:MB1.T1:TEMP:LOOP:HSET"), "HSET:")[end]

MercuryiTC_setsweepmode_set(instr, val) = query(instr, "SET:DEV:MB1.T1:TEMP:LOOP:SWMD:$val")
MercuryiTC_setsweepmode_get(instr) = split(query(instr, "READ:DEV:MB1.T1:TEMP:LOOP:SWMD"), "SWMD:")[end]

MercuryiTC_enablepid_set(instr, val) = query(instr, "SET:DEV:MB1.T1:TEMP:LOOP:ENAB:$val")
MercuryiTC_enablepid_get(instr) = split(query(instr, "READ:DEV:MB1.T1:TEMP:LOOP:ENAB"), "ENAB:")[end]

MercuryiTC_setflow_set(instr, val) = query(instr, "SET:DEV:MB1.T1:TEMP:LOOP:FSET:$val")
MercuryiTC_setflow_get(instr) = split(query(instr, "READ:DEV:MB1.T1:TEMP:LOOP:FSET"), "FSET:")[end]

MercuryiTC_setflowctl_set(instr, val) = query(instr, "SET:DEV:MB1.T1:TEMP:LOOP:FAUT:$val")
MercuryiTC_setflowctl_get(instr) = split(query(instr, "READ:DEV:MB1.T1:TEMP:LOOP:FAUT"), "FAUT:")[end]