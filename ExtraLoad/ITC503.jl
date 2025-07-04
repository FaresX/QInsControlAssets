ITC503_remote_set(instr, val) = query(instr, "C$val")
ITC503_remote_get(instr) = split(split(query(instr, "X"), "C")[end], "S")[1]

ITC503_sensor1temp_get(instr) = split(query(instr, "R1"), "R")[end]
ITC503_sensor2temp_get(instr) = split(query(instr, "R2"), "R")[end]
ITC503_sensor3temp_get(instr) = split(query(instr, "R3"), "R")[end]

ITC503_settemp_set(instr, val) = query(instr, "T$val")
ITC503_settemp_get(instr) = split(query(instr, "R0"), "R")[end]

function ITC503_setheaterctl_set(instr, val)
    val = string(val)
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
    val = string(val)
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

let
    iscondensing::Bool = false
    step::Int = 0
    step1heater::Float64 = 50
    tsorb::Float64 = 27
    tsample::Float64 = 1.47
    delay2::Float64 = 3600
    delay3::Float64 = 600
    pidP::Float64 = 10
    pidI::Float64 = 5
    pidD::Float64 = 0
    NVnormal::Float64 = 2
    NVcondense::Float64 = 7
    NVcooldown::Float64 = 3
    step1starttime::DateTime = now()
    step2starttime::DateTime = now()
    step3starttime::DateTime = now()
    step4starttime::DateTime = now()

    global function ITC503_cdstate_set(instr, val)
        if val == "0"
            iscondensing = false
        elseif val == "1"
            iscondensing || errormonitor(@async condensing(instr))
        end
    end
    global ITC503_cdstate_get(_) = string(Int(iscondensing))
    global ITC503_cdstep_get(_) = string(step)
    global ITC503_cdstep1heater_set(_, val) = step1heater = parse(Float64, val)
    global ITC503_cdstep1heater_get(_) = string(step1heater)
    global ITC503_cdtsorb_set(_, val) = tsorb = parse(Float64, val)
    global ITC503_cdtsorb_get(_) = string(tsorb)
    global ITC503_cdtsample_set(_, val) = tsample = parse(Float64, val)
    global ITC503_cdtsample_get(_) = string(tsample)
    global ITC503_cddelay2_set(_, val) = delay2 = parse(Float64, val)
    global ITC503_cddelay2_get(_) = string(delay2)
    global ITC503_cddelay3_set(_, val) = delay3 = parse(Float64, val)
    global ITC503_cddelay3_get(_) = string(delay3)
    global ITC503_cdpidP_set(_, val) = pidP = parse(Float64, val)
    global ITC503_cdpidP_get(_) = string(pidP)
    global ITC503_cdpidI_set(_, val) = pidI = parse(Float64, val)
    global ITC503_cdpidI_get(_) = string(pidI)
    global ITC503_cdpidD_set(_, val) = pidD = parse(Float64, val)
    global ITC503_cdpidD_get(_) = string(pidD)
    global ITC503_cdNVnormal_set(_, val) = NVnormal = parse(Float64, val)
    global ITC503_cdNVnormal_get(_) = string(NVnormal)
    global ITC503_cdNVcondense_set(_, val) = NVcondense = parse(Float64, val)
    global ITC503_cdNVcondense_get(_) = string(NVcondense)
    global ITC503_cdNVcooldown_set(_, val) = NVcooldown = parse(Float64, val)
    global ITC503_cdNVcooldown_get(_) = string(NVcooldown)
    global ITC503_cdstep1starttime_set(_, val) = step1starttime = parse(Float64, val)
    global ITC503_cdstep1starttime_get(_) = string(step1starttime)[6:end-4]
    global ITC503_cdstep2starttime_set(_, val) = step2starttime = parse(Float64, val)
    global ITC503_cdstep2starttime_get(_) = string(step2starttime)[6:end-4]
    global ITC503_cdstep3starttime_set(_, val) = step3starttime = parse(Float64, val)
    global ITC503_cdstep3starttime_get(_) = string(step3starttime)[6:end-4]
    global ITC503_cdstep4starttime_set(_, val) = step4starttime = parse(Float64, val)
    global ITC503_cdstep4starttime_get(_) = string(step4starttime)[6:end-4]

    function condensing(instr)
        iscondensing = true
        state = step1(instr) && step2(instr) && step3() && step4(instr)
        endcondensing(instr)
        @info state ? "condensing He3 is complete!" : "condensing He3 has been aborted!"
    end
    function step1(instr)
        step = 1
        step1starttime = now()
        ITC503_heaterchannel_set(instr, 1)
        ITC503_setgasflowctl_set(instr, 0)
        ITC503_setheaterctl_set(instr, 0)
        ITC503_gasflow_set(instr, NVnormal)
        ITC503_heaterpct_set(instr, step1heater)
        ITC503_pidP_set(instr, pidP)
        ITC503_pidI_set(instr, pidI)
        ITC503_pidD_set(instr, pidD)
        t1 = parse(Float64, ITC503_sensor1temp_get(instr))
        while iscondensing && (t1 < tsorb && now() - step1starttime < Minute(5))
            sleep(1)
            t1 = parse(Float64, ITC503_sensor1temp_get(instr))
        end
        return iscondensing
    end
    function step2(instr)
        step = 2
        ITC503_heaterchannel_set(instr, 1)
        ITC503_setgasflowctl_set(instr, 0)
        ITC503_setheaterctl_set(instr, 1)
        ITC503_gasflow_set(instr, NVcondense)
        ITC503_settemp_set(instr, tsorb)
        t3 = parse(Float64, ITC503_sensor3temp_get(instr))
        t3lasttime = now()
        step2starttime = now()
        while iscondensing && now() - step2starttime < Second(delay2)
            sleep(1)
            t3 = parse(Float64, ITC503_sensor3temp_get(instr))
            if t3 < tsample
                now() - t3lasttime > Minute(1) && break
            else
                t3lasttime = now()
            end
        end
        return iscondensing
    end
    function step3()
        step = 3
        step3starttime = now()
        while iscondensing && now() - step3starttime < Second(delay3)
            sleep(1)
        end
        return iscondensing
    end
    function step4(instr)
        step = 4
        step4starttime = now()
        ITC503_heaterchannel_set(instr, 1)
        ITC503_setgasflowctl_set(instr, 0)
        ITC503_setheaterctl_set(instr, 0)
        ITC503_heaterpct_set(instr, 0)
        ITC503_settemp_set(instr, 0)
        ITC503_gasflow_set(instr, NVcooldown)
        t1 = parse(Float64, ITC503_sensor1temp_get(instr))
        while iscondensing && t1 > 4
            sleep(1)
            t1 = parse(Float64, ITC503_sensor1temp_get(instr))
        end
        return iscondensing
    end
    function endcondensing(instr)
        ITC503_heaterchannel_set(instr, 1)
        ITC503_setgasflowctl_set(instr, 0)
        ITC503_setheaterctl_set(instr, 0)
        ITC503_gasflow_set(instr, NVnormal)
        ITC503_heaterpct_set(instr, 0)
        ITC503_settemp_set(instr, 0)
        step = 0
        iscondensing = false
    end
end

