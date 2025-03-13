Proteox_drimixs_get(instr) = split(query(instr, "oi.decs.temperature_control.DRI_MIX_CL.DRI_MIX_S.temperature"), ',')[5]

Proteox_drimixclheater_set(instr, val) = query(instr, "oi.decs.temperature_control.DRI_MIX_CL.setpoint $val")
Proteox_drimixclheater_get(instr) = rstrip(join(split(query(instr, "oi.decs.temperature_control.DRI_MIX_CL.setpoint"), ',')[[5, 7]], ','), ')')

function Proteox_claimcontrol_set(instr, val)
    if val == "1"
        query(instr, "oi.decs.sessionmanager.claim_system_control")
    elseif val == "0"
        query(instr, "oi.decs.sessionmanager.relinquish_system_control")
    end
end
Proteox_claimcontrol_get(instr) = query(instr, "oi.decs.sessionmanager.system_controller")