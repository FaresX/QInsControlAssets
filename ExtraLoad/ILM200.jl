ILM200_heliumlevel_get(instr) = string(round(0.1parse(Int, split(query(instr, "R1"), "R")[end]), digits=1))
function ILM200_heliumlevelrmode_set(instr, val)
    if val == "0"
        query(instr, "S1")
    elseif val == "1"
        query(instr, "T1")
    end
end
let
    fastrateflag::Int = 2
    slowrateflag::Int = 4
    global function ILM200_heliumlevelrmode_get(instr)
        status = split(query(instr, "X"), "S")[end][1:2]
        statusbits = parse(Int, status; base=16)
        statusbits & fastrateflag == fastrateflag && return "1"
        statusbits & slowrateflag == slowrateflag && return "0"
    end
end
ILM200_nitrogenlevel_get(instr) = string(round(0.1parse(Int, split(query(instr, "R2"), "R")[end]), digits=1))