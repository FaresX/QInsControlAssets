ITC503_remote_set(instr, val) = query(instr, "C$val")
ITC503_remote_get(instr) = split(split(query(instr, "X"), "C")[end], "S")[1]

ITC503_sensor1temp_get(instr) = split(query(instr, "R1"), "R")[end]
ITC503_sensor2temp_get(instr) = split(query(instr, "R2"), "R")[end]
ITC503_sensor3temp_get(instr) = split(query(instr, "R3"), "R")[end]

ITC503_settemp_set(instr, val) = query(instr, "T$val")
ITC503_settemp_get(instr) = split(query(instr, "R0"), "R")[end]

function ITC503_setheaterctl_set(instr, val)
    gasflowstate = parse(Bool, ITC503_setgasflowctl_get(instr))
    if val == "0"
        query(instr, gasflowstate ? "A2" : "A0")
    elseif val == "1"
        query(instr, gasflowstate ? "A3" : "A1")
    end
end
ITC503_setheaterctl_get(instr) = split(split(query(instr, "X"), "A")[end], "C")[1] in ["0", "2"] ? "0" : "1"

ITC503_heaterchannel_set(instr, val) = query(instr, "H$val")
ITC503_heaterchannel_get(instr) = split(split(query(instr, "X"), "H")[end], "L")[1]

ITC503_heaterpct_set(instr, val) = query(instr, "O$val")
ITC503_heaterpct_get(instr) = string(round(parse(Float64, split(query(instr, "R5"), "R")[end]); digits=1))

function ITC503_setgasflowctl_set(instr, val)
    heaterstate = parse(Bool, ITC503_setheaterctl_get(instr))
    if val == "0"
        query(instr, heaterstate ? "A1" : "A0")
    elseif val == "1"
        query(instr, heaterstate ? "A3" : "A2")
    end
end
ITC503_setgasflowctl_get(instr) = split(split(query(instr, "X"), "A")[end], "C")[1] in ["0", "1"] ? "0" : "1"

ITC503_gasflow_set(instr, val) = query(instr, "G$val")
ITC503_gasflow_get(instr) = string(round(parse(Float64, split(query(instr, "R7"), "R")[end]); digits=1))

ITC503_pidP_set(instr, val) = query(instr, "P$val")
ITC503_pidP_get(instr) = split(query(instr, "R8"), "R")[end]
ITC503_pidI_set(instr, val) = query(instr, "I$val")
ITC503_pidI_get(instr) = split(query(instr, "R9"), "R")[end]
ITC503_pidD_set(instr, val) = query(instr, "D$val")
ITC503_pidD_get(instr) = split(query(instr, "R10"), "R")[end]