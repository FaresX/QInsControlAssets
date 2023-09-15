function queryproteox(instr,
    cmd;
    python="C:/Users/Proteox/anaconda3/python.exe",
)
    ss = string.(split(instr.addr, "::"))
    @assert length(ss) == 6 "unavailable address"
    _, user, user_secret, url, realm, _ = ss
    cmdf = Cmd([python, joinpath(Base.@__DIR__, "Proteox.py"), cmd, user, user_secret, url, realm])
    split(readchomp(cmdf), '\n')[end]
end

Proteox_drimixs_get(instr) = split(queryproteox(instr, "oi.decs.temperature_control.DRI_MIX_CL.DRI_MIX_S.temperature"), ',')[5]