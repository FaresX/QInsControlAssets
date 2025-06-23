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

Triton_h2power_set(instr, val) = query(instr, "SET:DEV:H2:HTR:SIG:POWR:$val")
Triton_h2power_get(instr) = split(query(instr, "READ:DEV:H2:HTR:SIG:POWR"), "POWR:")[end][1:end-2]

### TA
Triton_taloopmode_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:MODE:$val"; delay=6)
Triton_taloopmode_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:MODE"), "MODE:")[end]

Triton_taloopP_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:P:$val")
Triton_taloopP_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:P"), "P:")[end]

Triton_taloopI_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:I:$val")
Triton_taloopI_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:I"), "I:")[end]

Triton_taloopD_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:D:$val")
Triton_taloopD_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:D"), "D:")[end]

function Triton_taloopPID_set(instr, val)
    spval = lstrip.(rstrip.(split(val, ',')))
    length(spval) == 3 || (@warn "please input P,I,D"; return "none")
    p, i, d = spval
    query(instr, "SET:DEV:TA:TEMP:LOOP:P:$p:I:$i:D:$d")
end
function Triton_taloopPID_get(instr)
    p = Triton_taloopP_get(instr)
    i = Triton_taloopI_get(instr)
    d = Triton_taloopD_get(instr)
    return "P:$p I:$i D:$d"
end

Triton_talooptset_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:TSET:$val")
Triton_talooptset_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:TSET"), "TSET:")[end][1:end-1]

Triton_talooprange_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:LOOP:RANGE:$val")
Triton_talooprange_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:LOOP:RANGE"), "RANGE:")[end][1:end-2]

Triton_taexcitationtype_set(instr, val) = query(instr, "SET:DEV:TA:TEMP:EXCT:TYPE:$val")
Triton_taexcitationtype_get(instr) = split(query(instr, "READ:DEV:TA:TEMP:EXCT:TYPE"), "TYPE:")[end]

function Triton_taexcitationcur_set(instr, val)
    type = Triton_taexcitationtype_get(instr)
    type == "CUR" || (@warn "excitation is type of voltage"; return "none")
    query(instr, "SET:DEV:TA:TEMP:EXCT:MAG:$val")
end
function Triton_taexcitationcur_get(instr)
    type = Triton_taexcitationtype_get(instr)
    type == "CUR" || (@warn "excitation is type of voltage"; return "none")
    split(query(instr, "READ:DEV:TA:TEMP:EXCT:MAG"), "MAG:")[end][1:end-1]
end

function Triton_taexcitationvolt_set(instr, val)
    type = Triton_taexcitationtype_get(instr)
    type == "VOLT" || (@warn "excitation is type of current"; return "none")
    query(instr, "SET:DEV:TA:TEMP:EXCT:MAG:$val")
end
function Triton_taexcitationvolt_get(instr)
    type = Triton_taexcitationtype_get(instr)
    type == "VOLT" || (@warn "excitation is type of current"; return "none")
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
                loopmode = Triton_loopmode_get(instr)
                loopmode == "OFF" && Triton_loopmode_set(instr, "ON")
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
                loopmode = Triton_loopmode_get(instr)
                loopmode == "OFF" && Triton_loopmode_set(instr, "ON")
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
                loopmode = Triton_loopmode_get(instr)
                loopmode == "OFF" && Triton_loopmode_set(instr, "ON")
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
            loopmode = Triton_loopmode_get(instr)
            loopmode == "ON" && Triton_loopmode_set(instr, "OFF")
            Triton_taexcitationtype_set(instr, "CUR")
            Triton_taexcitationcur_set(instr, "316pA")
            Triton_looprange_set(instr, "0")
            Triton_h2power_set(instr, "8000")
        end
    end
    global Triton_tlm400probeautotsetsw_get(_) = tlm400probeautotsetsw
end

### T8

Triton_t8loopmode_set(instr, val) = query(instr, "SET:DEV:T8:TEMP:LOOP:MODE:$val"; delay=6)
Triton_t8loopmode_get(instr) = split(query(instr, "READ:DEV:T8:TEMP:LOOP:MODE"), "MODE:")[end]

Triton_t8loopP_set(instr, val) = query(instr, "SET:DEV:T8:TEMP:LOOP:P:$val")
Triton_t8loopP_get(instr) = split(query(instr, "READ:DEV:T8:TEMP:LOOP:P"), "P:")[end]

Triton_t8loopI_set(instr, val) = query(instr, "SET:DEV:T8:TEMP:LOOP:I:$val")
Triton_t8loopI_get(instr) = split(query(instr, "READ:DEV:T8:TEMP:LOOP:I"), "I:")[end]

Triton_t8loopD_set(instr, val) = query(instr, "SET:DEV:T8:TEMP:LOOP:D:$val")
Triton_t8loopD_get(instr) = split(query(instr, "READ:DEV:T8:TEMP:LOOP:D"), "D:")[end]

function Triton_t8loopPID_set(instr, val)
    spval = lstrip.(rstrip.(split(val, ',')))
    length(spval) == 3 || (@warn "please input P,I,D"; return "none")
    p, i, d = spval
    query(instr, "SET:DEV:T8:TEMP:LOOP:P:$p:I:$i:D:$d")
end
function Triton_t8loopPID_get(instr)
    p = Triton_t8loopP_get(instr)
    i = Triton_t8loopI_get(instr)
    d = Triton_t8loopD_get(instr)
    return "P:$p I:$i D:$d"
end

Triton_t8looptset_set(instr, val) = query(instr, "SET:DEV:T8:TEMP:LOOP:TSET:$val")
Triton_t8looptset_get(instr) = split(query(instr, "READ:DEV:T8:TEMP:LOOP:TSET"), "TSET:")[end][1:end-1]

Triton_t8looprange_set(instr, val) = query(instr, "SET:DEV:T8:TEMP:LOOP:RANGE:$val")
Triton_t8looprange_get(instr) = split(query(instr, "READ:DEV:T8:TEMP:LOOP:RANGE"), "RANGE:")[end][1:end-2]

Triton_t8excitationtype_set(instr, val) = query(instr, "SET:DEV:T8:TEMP:EXCT:TYPE:$val")
Triton_t8excitationtype_get(instr) = split(query(instr, "READ:DEV:T8:TEMP:EXCT:TYPE"), "TYPE:")[end]

function Triton_t8excitationcur_set(instr, val)
    type = Triton_t8excitationtype_get(instr)
    type == "CUR" || (@warn "excitation is type of voltage"; return "none")
    query(instr, "SET:DEV:T8:TEMP:EXCT:MAG:$val")
end
function Triton_t8excitationcur_get(instr)
    type = Triton_t8excitationtype_get(instr)
    type == "CUR" || (@warn "excitation is type of voltage"; return "none")
    split(query(instr, "READ:DEV:T8:TEMP:EXCT:MAG"), "MAG:")[end][1:end-1]
end

function Triton_t8excitationvolt_set(instr, val)
    type = Triton_t8excitationtype_get(instr)
    type == "VOLT" || (@warn "excitation is type of current"; return "none")
    query(instr, "SET:DEV:T8:TEMP:EXCT:MAG:$val")
end
function Triton_t8excitationvolt_get(instr)
    type = Triton_t8excitationtype_get(instr)
    type == "VOLT" || (@warn "excitation is type of current"; return "none")
    split(query(instr, "READ:DEV:T8:TEMP:EXCT:MAG"), "MAG:")[end][1:end-1]
end

let
    t8autotsetsw::String = "OFF"
    global function Triton_t8autotset_set(instr, val)
        if t8autotsetsw == "ON"
            sv = parse(Float64, val)
            if sv <= 1.5
                exctvolt, looprange = if sv < 0.2
                    "63.2uV", "3.16"
                elseif 0.07 <= sv < 0.7
                    "63.2uV", "10"
                elseif 0.7 <= sv <= 1.5
                    "200uV", "31.6"
                end
                loopmode = Triton_t8loopmode_get(instr)
                loopmode == "OFF" && Triton_t8loopmode_set(instr, "ON")
                Triton_t8excitationtype_set(instr, "VOLT")
                Triton_t8excitationvolt_set(instr, exctvolt)
                Triton_t8looprange_set(instr, looprange)
                Triton_t8looptset_set(instr, val)
            end
        end
    end
    global Triton_t8autotset_get(instr) = Triton_temperatureT8_get(instr)

    global function Triton_t8autotsetsw_set(instr, val)
        if val == "ON"
            t8autotsetsw = "ON"
        elseif val == "OFF"
            t8autotsetsw = "OFF"
            loopmode = Triton_t8loopmode_get(instr)
            loopmode == "ON" && Triton_t8loopmode_set(instr, "OFF")
            Triton_t8excitationtype_set(instr, "VOLT")
            Triton_t8excitationvolt_set(instr, "63.2uV")
            Triton_t8looprange_set(instr, "0")
        end
    end
    global Triton_t8autotsetsw_get(_) = t8autotsetsw
end