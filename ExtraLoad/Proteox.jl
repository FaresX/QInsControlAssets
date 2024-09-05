Proteox_drimixs_get(instr) = split(query(instr, "oi.decs.temperature_control.DRI_MIX_CL.DRI_MIX_S.temperature"), ',')[5]

Proteox_drimixclheater_set(instr, val) = query(instr, "oi.decs.temperature_control.DRI_MIX_CL.setpoint $val")
Proteox_drimixclheater_get(instr) = rstrip(join(split(query(instr, "oi.decs.temperature_control.DRI_MIX_CL.setpoint"), ',')[[5, 7]], ','), ')')