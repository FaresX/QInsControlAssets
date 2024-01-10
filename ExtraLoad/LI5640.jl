function LI5640_acvoltagerangeCtrl_set(instr, val)
    v, vr = split(query(instr, "AMPL?"), ',')
    write(instr, "AMPL $v,$val")
end

LI5640_acvoltagerangeCtrl_get(instr) = split(query(instr, "AMPL?"), ',')[2]

function LI5640_acvoltageCtrl_set(instr, val)
    v, vr = split(query(instr, "AMPL?"), ',')
    write(instr, "AMPL $val,$vr")
end

LI5640_acvoltageCtrl_get(instr) = split(query(instr, "AMPL?"), ',')[1]

LI5640_dataout1Ctrl_get(instr) = split(query(instr, "DOUT?"), ',')[1]

LI5640_dataout2Ctrl_get(instr) = split(query(instr, "DOUT?"), ',')[2]