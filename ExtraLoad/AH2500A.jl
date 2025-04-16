let
    r = r"C=([ \-+][\w.0-9]*)[ ]*PF L=([ \-+][\w.0-9]*)[ ]*NS V=([ \-+][\w.0-9]*)"
    global function AH2500A_querydata_get(instr)
        s = query(instr, "Q")
        C, PFL, NSV = match(r, s)
        return "$C,$PFL,$NSV"
    end
end