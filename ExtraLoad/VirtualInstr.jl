VirtualInstr_SystemTime_get(_) = string(time())

VirtualInstr_DateTime_get(_) = string(now())

VirtualInstr_Date_get(_) = string(Date(now()))

VirtualInstr_Time_get(_) = string(Time(now()))

function VirtualInstr_YearMonthDayHMSM_get(_)
    whole = now()
    return string(
        year(whole), ",", month(whole), ",", day(whole), ",",
        hour(whole), ",", minute(whole), ",", second(whole), ",", millisecond(whole)
    )
end

VirtualInstr_HourMinuteSecond_get(_) = (whole = now(); string(hour(whole), ":", minute(whole), ":", second(whole)))

# let
#     sweepv::String = "0"
#     global VirtualInstr_SweepTest_set(_, setv) = (sweepv = string(setv))
#     global VirtualInstr_SweepTest_get(_) = sweepv
# end

# VirtualInstr_SweepTest2_set(, setv) = @info "VirtualInstr sweep2 : $setv"
# VirtualInstr_SweepTest2_get() = string(rand(Int8))

# let
#     setval::String = "0"
#     global VirtualInstr_SetTest_set(_, setv) = (setval = string(setv))
#     global VirtualInstr_SetTest_get(_) = setval
# end

let
    I::Float64 = 0
    Iac::Float64 = 0
    Vac::Float64 = 0
    B::Float64 = 0
    Power::String = "0"
    Vacrange::Float64 = 1

    Ic(b) = 1e-6 * abs(sinc(1e3b))
    function IR(i)
        if Power == "1"
            δIc = 0.1Ic(B)
            if abs(i) < Ic(B) - δIc
                return 600 * 0.005randn()
            elseif Ic(B) - δIc < abs(i) < Ic(B) + δIc
                return (1200 / (1 + 9e13abs2(abs(i) - Ic(B)))) * (1 + 0.005randn())
            else
                return 600 * (1 + 0.005randn())
            end
        else
            return 600 * 0.001randn()
        end
    end

    global VirtualInstr_I_set(_, setv) = (Iparse = tryparse(Float64, setv); I = isnothing(Iparse) ? 0 : Iparse)
    global VirtualInstr_I_get(_) = string(I)

    global VirtualInstr_Iac_set(_, setv) = (Iacparse = tryparse(Float64, setv); Iac = isnothing(Iacparse) ? 0 : Iacparse)
    global VirtualInstr_Iac_get(_) = string(Iac)

    global function VirtualInstr_Vacrange_set(_, setv)
        Vacrangeparse = tryparse(Float64, setv)
        if isnothing(Vacrangeparse)
            Vacrange = 1
        else
            Vacrange = if abs(Vacrangeparse) <= 1e-6
                1e-6
            elseif abs(Vacrangeparse) <= 1e-3
                1e-3
            else
                1
            end
        end
    end
    global VirtualInstr_Vacrange_get(_) = string(Vacrange)

    global function VirtualInstr_Vac_get(_)
        vac = IR(I) * Iac
        vac > Vacrange && (vac = Vacrange)
        vac < -Vacrange && (vac = -Vacrange)
        return string(vac)
    end

    global function VirtualInstr_VacCtrl_get(_)
        vac = IR(I) * Iac
        vac > Vacrange && (vac = Vacrange)
        vac < -Vacrange && (vac = -Vacrange)
        return string(vac, ",", -Vacrange, ",", Vacrange, ",", Power == "1")
    end

    global VirtualInstr_B_set(_, setv) = (Bparse = tryparse(Float64, setv); B = isnothing(Bparse) ? 0 : Bparse)
    global VirtualInstr_B_get(_) = string(B)

    global function VirtualInstr_power_set(_, setv)
        Power = if setv in ["0", "OFF"]
            "0"
        elseif setv in ["1", "ON"]
            "1"
        else
            Power
        end
    end
    global VirtualInstr_power_get(_) = Power
end