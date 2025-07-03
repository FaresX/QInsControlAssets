idn_with_V(instr) = query(instr, "V")

IPS120_remote_set(instr, val) = query(instr, "C$val")
IPS120_remote_get(instr) = split(split(query(instr, "X"), "C")[end], "H")[1]

###Z Field###
function IPS120_sigrfstz_set(instr, val)
    parse(Float64, val) > 0.3 && (@warn "no larger than 0.2 T/min !!!"; return)
    query(instr, "T$val")
end
IPS120_sigrfstz_get(instr) = split(query(instr, "R9"), "R")[end]

IPS120_sigfsetz_set(instr, val) = query(instr, "J$val")
IPS120_sigfsetz_get(instr) = split(query(instr, "R8"), "R")[end]

# let
#     historyBs::Vector{Tuple{Float64,Float64}} = []
#     function isvalidnum(bstr)
#         b = tryparse(Float64, bstr)
#         return !(isnothing(b) || abs(b) > 6), b
#     end
#     function isvalidB(instr, bstr)
#         isv, bin = isvalidnum(bstr)
#         isv || return false
#         length(historyBs) != 0 && time() - historyBs[end][1] > 60 && empty!(historyBs)
#         n = length(historyBs)
#         if n < 11
#             i = 1
#             while length(historyBs) < 11 && i < 100
#                 bstr = split(query(instr, "R7"), "R")[end]
#                 isv, b = isvalidnum(bstr)
#                 isv && push!(historyBs, (time(), b))
#                 i += 1
#             end
#             length(historyBs) < 11 && return false
#         elseif n > 11
#             resize!(historyBs, 11)
#         end
#         bs = [d[2] for d in historyBs]
#         sp = sortperm(bs)
#         mt, mb = historyBs[sp[6]]
#         t = time()
#         isv = abs(mb - bin) < 0.0033 * (t - mt)
#         isv && (popfirst!(historyBs); push!(historyBs, (t, bin)))
#         return isv
#     end
#     global function IPS120_sigfldz_get(instr)
#         for _ in 1:6
#             bstr = split(query(instr, "R7"), "R")[end]
#             isvalidB(instr, bstr) && return bstr
#         end
#         error("invalid field value!!!")
#     end
# end
IPS120_sigfldz_get(instr) = split(query(instr, "R7"), "R")[end]
IPS120_sigpfldz_get(instr) = split(query(instr, "R18"), "R")[end]

IPS120_sigpcurz_get(instr) = split(query(instr, "R0"), "R")[end]

function IPS120_drivez_set(instr, val)
    IPS120_sigfsetz_set(instr, val)
    sleep(0.1)
    IPS120_sigactnz_set(instr, "1")
end
IPS120_drivez_get(instr) = IPS120_sigfldz_get(instr)

let
    stabilizationtime::Float64 = 60
    timespent::Float64 = 0
    global function IPS120_zheater_set(instr, val)
        heaterstate = IPS120_zheater_get(instr)
        if timespent == 0 && heaterstate != val
            if val == "1"
                pfldz = IPS120_sigpfldz_get(instr)
                IPS120_drivez_set(instr, pfldz)
                timedwait(60; pollint=1) do
                    fldz = IPS120_sigfldz_get(instr)
                    try
                        abs(parse(Float64, fldz) - parse(Float64, pfldz)) < 0.0005
                    catch
                        false
                    end
                end
            end
            query(instr, "H$val"; delay=4)
            t1 = time()
            hs = IPS120_zheater_get(instr)
            timespent = hs == val ? time() - t1 : 0
            if timespent != 0
                @async begin
                    while timespent < stabilizationtime
                        sleep(1)
                        timespent = time() - t1
                    end
                    timespent = 0
                    val == "0" && IPS120_sigactnz_set(instr, "2")
                end
            end
        end
    end
    global function IPS120_zheater_get(instr)
        state = split(split(query(instr, "X"), "H")[end], "M")[1]
        state in ["0", "2"] && return "0"
        state == "1" && return "1"
        state == "5" && @error "Switch heater fault!"
        state == "8" && return "No heater"
    end

    global IPS120_zheatertime_set(_, val) = (t = tryparse(Float64, val); isnothing(t) || (stabilizationtime = t))
    global IPS120_zheatertime_get(_) = string(stabilizationtime)

    global IPS120_zheatertimespent_get(_) = string(floor(Int, timespent))

    global function IPS120_sigactnz_set(instr, val)
        if val == "4"
            heaterstate = IPS120_zheater_get(instr)
            fldz = parse(Float64, IPS120_sigfldz_get(instr))
            (heaterstate != "0" || abs(fldz) > 0.0005) && (@warn "heater is on or field is not zero"; return)
        end
        query(instr, "A$val")
    end
    global IPS120_sigactnz_get(instr) = split(split(query(instr, "X"), "A")[end], "C")[1]
end