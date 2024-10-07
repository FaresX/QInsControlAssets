###X Field###
MercuryIPS_sigrfstx_set(instr, val) = query(instr, "SET:DEV:GRPX:PSU:SIG:RFST:$val")
MercuryIPS_sigrfstx_get(instr) = split(query(instr, "READ:DEV:GRPX:PSU:SIG:RFST"), "RFST:")[end][1:end-3]

MercuryIPS_sigfsetx_set(instr, val) = query(instr, "SET:DEV:GRPX:PSU:SIG:FSET:$val")
MercuryIPS_sigfsetx_get(instr) = split(query(instr, "READ:DEV:GRPX:PSU:SIG:FSET"), "FSET:")[end][1:end-1]

MercuryIPS_sigactnx_set(instr, val) = query(instr, "SET:DEV:GRPX:PSU:ACTN:$val")
MercuryIPS_sigactnx_get(instr) = split(query(instr, "READ:DEV:GRPX:PSU:ACTN"), "ACTN:")[end]

MercuryIPS_sigpfldx_get(instr) = split(query(instr, "READ:DEV:GRPX:PSU:SIG:PFLD"), "PFLD:")[end][1:end-1]

MercuryIPS_sigfldx_get(instr) = split(query(instr, "READ:DEV:GRPX:PSU:SIG:FLD"), "FLD:")[end][1:end-1]

function MercuryIPS_drivex_set(instr, val)
    MercuryIPS_sigactnx_set(instr, "HOLD")
    sleep(0.1)
    MercuryIPS_sigfsetx_set(instr, val)
    sleep(0.1)
    MercuryIPS_sigactnx_set(instr, "RTOS")
end
MercuryIPS_drivex_get(instr) = MercuryIPS_sigpfldx_get(instr)

###Y Field###
MercuryIPS_sigrfsty_set(instr, val) = query(instr, "SET:DEV:GRPY:PSU:SIG:RFST:$val")
MercuryIPS_sigrfsty_get(instr) = split(query(instr, "READ:DEV:GRPY:PSU:SIG:RFST"), "RFST:")[end][1:end-3]

MercuryIPS_sigfsety_set(instr, val) = query(instr, "SET:DEV:GRPY:PSU:SIG:FSET:$val")
MercuryIPS_sigfsety_get(instr) = split(query(instr, "READ:DEV:GRPY:PSU:SIG:FSET"), "FSET:")[end][1:end-1]

MercuryIPS_sigactny_set(instr, val) = query(instr, "SET:DEV:GRPY:PSU:ACTN:$val")
MercuryIPS_sigactny_get(instr) = split(query(instr, "READ:DEV:GRPY:PSU:ACTN"), "ACTN:")[end]

MercuryIPS_sigpfldy_get(instr) = split(query(instr, "READ:DEV:GRPY:PSU:SIG:PFLD"), "PFLD:")[end][1:end-1]

MercuryIPS_sigfldy_get(instr) = split(query(instr, "READ:DEV:GRPY:PSU:SIG:FLD"), "FLD:")[end][1:end-1]

function MercuryIPS_drivey_set(instr, val)
    MercuryIPS_sigactny_set(instr, "HOLD")
    sleep(0.1)
    MercuryIPS_sigfsety_set(instr, val)
    sleep(0.1)
    MercuryIPS_sigactny_set(instr, "RTOS")
end
MercuryIPS_drivey_get(instr) = MercuryIPS_sigpfldy_get(instr)

###Z Field###
function MercuryIPS_sigrfstz_set(instr, val)
    parse(Float64, val) > 0.3 && (@warn "no larger than 0.3 T/min !!!"; return)
    query(instr, "SET:DEV:GRPZ:PSU:SIG:RFST:$val")
end
MercuryIPS_sigrfstz_get(instr) = split(query(instr, "READ:DEV:GRPZ:PSU:SIG:RFST"), "RFST:")[end][1:end-3]

MercuryIPS_sigfsetz_set(instr, val) = query(instr, "SET:DEV:GRPZ:PSU:SIG:FSET:$val")
MercuryIPS_sigfsetz_get(instr) = split(query(instr, "READ:DEV:GRPZ:PSU:SIG:FSET"), "FSET:")[end][1:end-1]

MercuryIPS_sigpfldz_get(instr) = split(query(instr, "READ:DEV:GRPZ:PSU:SIG:PFLD"), "PFLD:")[end][1:end-1]

MercuryIPS_sigfldz_get(instr) = split(query(instr, "READ:DEV:GRPZ:PSU:SIG:PFLD"), "FLD:")[end][1:end-1]

function MercuryIPS_drivez_set(instr, val)
    MercuryIPS_sigactnz_set(instr, "HOLD")
    sleep(0.1)
    MercuryIPS_sigfsetz_set(instr, val)
    sleep(0.1)
    MercuryIPS_sigactnz_set(instr, "RTOS")
end
MercuryIPS_drivez_get(instr) = MercuryIPS_sigpfldz_get(instr)

let
    stabilizationtime::Float64 = 120
    timespent::Float64 = 0
    global function MercuryIPS_zheater_set(instr, val)
        heaterstate = MercuryIPS_zheater_get(instr)
        if timespent == 0 && heaterstate != val
            query(instr, "SET:DEV:GRPZ:PSU:SIG:SWHT:$val"; delay=4)
            t1 = time()
            hs = MercuryIPS_zheater_get(instr)
            timespent = hs == val ? time() - t1 : 0
            if timespent != 0
                @async begin
                    while timespent < stabilizationtime
                        sleep(1)
                        timespent = time() - t1
                    end
                    timespent = 0
                end
            end
        end
    end
    global MercuryIPS_zheater_get(instr) = split(query(instr, "READ:DEV:GRPZ:PSU:SIG:SWHT"), "SWHT:")[end]

    global MercuryIPS_zheatertime_set(_, val) = (t = tryparse(Float64, val); isnothing(t) || (stabilizationtime = t))
    global MercuryIPS_zheatertime_get(_) = string(stabilizationtime)

    global MercuryIPS_zheatertimespent_get(_) = string(floor(Int, timespent))

    global function MercuryIPS_sigactnz_set(instr, val)
        val == "RTOS" && timespent != 0 && (@warn "waiting for heater on"; return)
        query(instr, "SET:DEV:GRPZ:PSU:ACTN:$val")
    end
    global MercuryIPS_sigactnz_get(instr) = split(query(instr, "READ:DEV:GRPZ:PSU:ACTN"), "ACTN:")[end]
end

MercuryIPS_heliumlevel_get(instr) = split(query(instr, "READ:DEV:DB1.L1:LVL:SIG:HEL:LEV"), "LEV:")[end]
MercuryIPS_heliumlevelrmode_set(instr, val) = query(instr, "SET:DEV:DB1.L1:LVL:HEL:PULS:SLOW:$val")
MercuryIPS_heliumlevelrmode_get(instr) = split(query(instr, "READ:DEV:DB1.L1:LVL:HEL:PULS:SLOW"), "SLOW:")[end]
MercuryIPS_nitrogenlevel_get(instr) = split(query(instr, "READ:DEV:DB1.L1:LVL:SIG:NIT:LEV"), "LEV:")[end]
MercuryIPS_magnetT_get(instr) = split(query(instr, "READ:DEV:MB1.T1:TEMP:SIG:TEMP"), "TEMP:")[end][1:end-1]