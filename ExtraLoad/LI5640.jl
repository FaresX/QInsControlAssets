function LI5640_acvoltagerangeCtrl_set(instr, val)
    v, _ = split(query(instr, "AMPL?"), ',')
    write(instr, "AMPL $v,$val")
end

LI5640_acvoltagerangeCtrl_get(instr) = split(query(instr, "AMPL?"), ',')[2]

function LI5640_acvoltageCtrl_set(instr, val)
    _, vr = split(query(instr, "AMPL?"), ',')
    write(instr, "AMPL $val,$vr")
end

LI5640_acvoltageCtrl_get(instr) = split(query(instr, "AMPL?"), ',')[1]