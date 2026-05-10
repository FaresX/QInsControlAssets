idn_AH2500A(_) = "AH2500A"
let
    r = r"C=([ \-+][\w.0-9]*)[ ]*PF L=([ \-+][\w.0-9]*)[ ]*[ND]S V=([ \-+][\w.0-9]*)"
    global function AH2500A_querydata_get(instr)
        s = query(instr, "Q")
        m = match(r, s)
        isnothing(m) && @error "m is nothing" s=s
        C, PFL, NSV = m
        return "$C,$PFL,$NSV"
    end
end