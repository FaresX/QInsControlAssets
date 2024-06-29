PPMS_channel1_get(instr) = split(rstrip(query(instr, "GETDAT? 16"), ';'), ",")[end]
PPMS_channel2_get(instr) = split(rstrip(query(instr, "GETDAT? 64"), ';'), ",")[end]
PPMS_channel3_get(instr) = split(rstrip(query(instr, "GETDAT? 256"), ';'), ",")[end]
PPMS_channel4_get(instr) = split(rstrip(query(instr, "GETDAT? 1024"), ';'), ",")[end]

function PPMS_fieldfield_set(instr, val)
    _, r, am, mm = split(rstrip(query(instr, "FIELD?"), ';'), ",")
    write(instr, "FIELD $val,$r,$am,$mm")
end
PPMS_fieldfield_get(instr) = split(query(instr, "FIELD?"), ",")[1]
function PPMS_fieldrate_set(instr, val)
    f, _, am, mm = split(rstrip(query(instr, "FIELD?"), ';'), ",")
    write(instr, "FIELD $f,$val,$am,$mm")
end
PPMS_fieldrate_get(instr) = split(query(instr, "FIELD?"), ",")[2]
function PPMS_fieldAM_set(instr, val)
    f, r, _, mm = split(rstrip(query(instr, "FIELD?"), ';'), ",")
    write(instr, "FIELD $f,$r,$val,$mm")
end
PPMS_fieldAM_get(instr) = split(query(instr, "FIELD?"), ",")[3]
function PPMS_fieldMM_set(instr, val)
    f, r, am, _ = split(query(instr, "FIELD?"), ",")
    write(instr, "FIELD $f,$r,$am,$val")
end
PPMS_fieldMM_get(instr) = split(rstrip(query(instr, "FIELD?"), ';'), ",")[end]

PPMS_fieldread_get(instr) = split(rstrip(query(instr, "GETDAT? 4"), ';'), ",")[end]

function PPMS_positionpos_set(instr, val)
    _, m, sdc = split(rstrip(query(instr, "MOVE?"), ';'), ",")
    write(instr, "MOVE $val,$m,$sdc")
end
PPMS_positionpos_get(instr) = split(query(instr, "MOVE?"), ",")[1]
function PPMS_positionmode_set(instr, val)
    p, _, sdc = split(rstrip(query(instr, "MOVE?"), ';'), ",")
    write(instr, "MOVE $p,$val,$sdc")
end
PPMS_positionmode_get(instr) = split(query(instr, "MOVE?"), ",")[2]
function PPMS_positionSDC_set(instr, val)
    p, m, _ = split(query(instr, "MOVE?"), ",")
    write(instr, "MOVE $p,$m,$val")
end
PPMS_positionSDC_get(instr) = split(rstrip(query(instr, "MOVE?"), ';'), ",")[end]

PPMS_positionread_get(instr) = split(rstrip(query(instr, "GETDAT? 8"), ';'), ",")[end]

function PPMS_temperaturetemp_set(instr, val)
    _, r, ac = split(rstrip(query(instr, "TEMP?"), ';'), ",")
    write(instr, "MOVE $val,$r,$ac")
end
PPMS_temperaturetemp_get(instr) = split(query(instr, "TEMP?"), ",")[1]
function PPMS_temperaturerate_set(instr, val)
    t, _, ac = split(rstrip(query(instr, "TEMP?"), ';'), ",")
    write(instr, "MOVE $t,$val,$ac")
end
PPMS_temperaturerate_get(instr) = split(query(instr, "TEMP?"), ",")[2]
function PPMS_temperatureAC_set(instr, val)
    t, r, _ = split(query(instr, "TEMP?"), ",")
    write(instr, "MOVE $t,$r,$val")
end
PPMS_temperatureAC_get(instr) = split(rstrip(query(instr, "TEMP?"), ';'), ",")[end]

PPMS_tempread_get(instr) = split(rstrip(query(instr, "GETDAT? 2"), ';'), ",")[end]