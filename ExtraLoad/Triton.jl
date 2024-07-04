Triton_temperatureTA_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT1_get(instr) = split(query(instr, "READ:DEV:T1:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT2_get(instr) = split(query(instr, "READ:DEV:T2:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT3_get(instr) = split(query(instr, "READ:DEV:T3:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT4_get(instr) = split(query(instr, "READ:DEV:T4:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT5_get(instr) = split(query(instr, "READ:DEV:T5:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT6_get(instr) = split(query(instr, "READ:DEV:T6:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT7_get(instr) = split(query(instr, "READ:DEV:T7:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT8_get(instr) = split(query(instr, "READ:DEV:T8:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_temperatureT13_get(instr) = split(query(instr, "READ:DEV:T13:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]

Triton_loopmode_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:MODE:$val"; delay=6)
Triton_loopmode_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:MODE"), "MODE:")[end]

Triton_taloopP_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:P:$val")
Triton_taloopP_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:P"), "P:")[end]

Triton_taloopI_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:I:$val")
Triton_taloopI_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:I"), "I:")[end]

Triton_taloopD_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:D:$val")
Triton_taloopD_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:D"), "D:")[end]

function Triton_taloopPID_set(instr, val)
    spval = lstrip.(rstrip.(split(val, ',')))
    length(spval) == 3 || (@warn "please input P,I,D"; return)
    p, i, d = spval
    query(instr, "SET:DEV:TA:TEMP:LOOP:P:$p:I:$i:D:$d")
end
function Triton_taloopPID_get(instr)
    p = Triton_taloopP_get(instr)
    i = Triton_taloopI_get(instr)
    d = Triton_taloopD_get(instr)
    return "P:$p I:$i D:$d"
end

Triton_looptset_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:TSET:$val")
Triton_looptset_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:TSET"), "TSET:")[end][1:end-1]

Triton_looprange_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:RANGE:$val")
Triton_looprange_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:RANGE"), "RANGE:")[end][1:end-2]

Triton_h2power_set(instr, val) = query(instr, "SET:DEV:H2:HTR:SIG:POWR:$val")
Triton_h2power_get(instr) = split(query(instr, "READ:DEV:H2:HTR:SIG:POWR"), "POWR:")[end][1:end-2]

Triton_taexcitationtype_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:EXCT:TYPE:$val")
Triton_taexcitationtype_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:EXCT:TYPE"), "TYPE:")[end]

function Triton_taexcitationcur_set(instr, val)
    type = Triton_taexcitationtype_get(instr)
    type == "CUR" || (@warn "excitation is type of voltage"; return)
    query(instr, "SET:DEV:TA:TEMP:EXCT:MAG:$val")
end
function Triton_taexcitationcur_get(instr)
    type = Triton_taexcitationtype_get(instr)
    type == "CUR" || (@warn "excitation is type of voltage"; return)
    split(query(instr, "READ:DEV:TA:TEMP:EXCT:MAG"), "MAG:")[end][1:end-1]
end

function Triton_taexcitationvolt_set(instr, val)
    type = Triton_taexcitationtype_get(instr)
    type == "VOLT" || (@warn "excitation is type of current"; return)
    query(instr, "SET:DEV:TA:TEMP:EXCT:MAG:$val")
end
function Triton_taexcitationvolt_get(instr)
    type = Triton_taexcitationtype_get(instr)
    type == "VOLT" || (@warn "excitation is type of current"; return)
    split(query(instr, "READ:DEV:TA:TEMP:EXCT:MAG"), "MAG:")[end][1:end-1]
end

let
    tlm400probeautotsetsw::String = "OFF"
    global function Triton_tlm400probeaautotset_set(instr, val)
        if tlm400probeautotsetsw == "ON"
            sv = parse(Float64, val)
            if sv <= 1
                exctcur, pid, looprange, h2p = if sv < 0.07
                    "1nA", "4,8,0", "0.316", "8000"
                elseif 0.07 <= sv < 0.5
                    "10nA", "2,8,0", "3.16", "0"
                elseif 0.5 <= sv <= 1
                    "31.6nA", "2,8,0", "3.16", "0"
                end
                Triton_loopmode_set(instr, "ON")
                Triton_taexcitationtype_set(instr, "CUR")
                Triton_taexcitationcur_set(instr, exctcur)
                Triton_taloopPID_set(instr, pid)
                Triton_looprange_set(instr, looprange)
                Triton_h2power_set(instr, h2p)
                Triton_looptset_set(instr, val)
            end
        end
    end
    global Triton_tlm400probeaautotset_get(instr) = Triton_temperatureTA_get(instr)

    global function Triton_tlm400probebautotset_set(instr, val)
        if tlm400probeautotsetsw == "ON"
            sv = parse(Float64, val)
            if sv <= 1
                exctcur, pid, looprange, h2p = if sv < 0.07
                    "1nA", "4,8,0", "0.316", "8000"
                elseif 0.07 <= sv < 0.5
                    "10nA", "2,8,0", "3.16", "0"
                elseif 0.5 <= sv <= 1
                    "31.6nA", "2,8,0", "3.16", "0"
                end
                Triton_loopmode_set(instr, "ON")
                Triton_taexcitationtype_set(instr, "CUR")
                Triton_taexcitationcur_set(instr, exctcur)
                Triton_taloopPID_set(instr, pid)
                Triton_looprange_set(instr, looprange)
                Triton_h2power_set(instr, h2p)
                Triton_looptset_set(instr, val)
            end
        end
    end
    global Triton_tlm400probebautotset_get(instr) = Triton_temperatureTA_get(instr)

    global function Triton_tlm400probecautotset_set(instr, val)
        if tlm400probeautotsetsw == "ON"
            sv = parse(Float64, val)
            if sv <= 1
                exctcur, pid, looprange, h2p = if sv < 0.07
                    "1nA", "64,1024,0", "1", "8000"
                elseif 0.07 <= sv < 0.5
                    "10nA", "2,64,0", "3.16", "0"
                elseif 0.5 <= sv <= 1
                    "31.6nA", "2,64,0", "3.16", "0"
                end
                Triton_loopmode_set(instr, "ON")
                Triton_taexcitationtype_set(instr, "CUR")
                Triton_taexcitationcur_set(instr, exctcur)
                Triton_taloopPID_set(instr, pid)
                Triton_looprange_set(instr, looprange)
                Triton_h2power_set(instr, h2p)
                Triton_looptset_set(instr, val)
            end
        end
    end
    global Triton_tlm400probecautotset_get(instr) = Triton_temperatureTA_get(instr)

    global function Triton_tlm400probeautotsetsw_set(instr, val)
        if val == "ON"
            tlm400probeautotsetsw = "ON"
        elseif val == "OFF"
            tlm400probeautotsetsw = "OFF"
            Triton_loopmode_set(instr, "OFF")
            Triton_taexcitationtype_set(instr, "CUR")
            Triton_taexcitationcur_set(instr, "316pA")
            Triton_looprange_set(instr, "0")
            Triton_h2power_set(instr, "8000")
        end
    end
    global Triton_tlm400probeautotsetsw_get(_) = tlm400probeautotsetsw
end