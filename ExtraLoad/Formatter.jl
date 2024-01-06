registermodes!(["head"], :code)

function formatdata(fd::FormatCodes, ::Val{:head})
    """
    ```julia
    root_path="C:\\Users\\22112\\OneDrive - mails.ucas.ac.cn\\文档\\EXPERIMENTS\\WTe2\\D27\\DATA\\HR 911\\Data\\2023\\2023-12"
    using Pkg; Pkg.activate("C:\\Users\\22112\\OneDrive - mails.ucas.ac.cn\\文档\\CODE\\Julia\\MyPackages\\MyExperimentalTools")
    using MyExperimentalTools
    using Plots
    using Unitful
    using Smoothers
    plotlyjs()
    theme(:wong)
    ```
    
    """
end


registermodes!(["biasbz", "biasrfp", "rfprff"])

function formatdata(fd::FormatData, ::Val{:biasbz})
    ""
end

function formatdata(fd::FormatData, ::Val{:biasrfp})
    loaddtviewer!(fd.dtviewer, fd.path)
    path = joinpath(splitpath(fd.path)[end-1:end]...)
    f = 1
    insbufkeys = sort(collect(filter(x -> occursin("instrbufferviewers", x), keys(fd.dtviewer.data))))
    for (ins, inses) in fd.dtviewer.data[insbufkeys[end]]
        if ins == "ESG-Series"
            fparse = tryparse(Float64, only(values(inses)).insbuf.quantities["frequency"].read)
            isnothing(fparse) || (f = fparse * 1e-9)
        end
    end
    """
    ```julia
    path = "\$root_path/$path"
    x, y, z = loadxyz(path)
    y *= 1e9
    y .-= 80
    heatmap(x, y, z, title="$f GHz", xlabel="Power(dBm)", ylabel="Ibias(nA)", cb_title="dV/dI(Ω)")
    ```

    ```julia
    Vs = intIbias(y, z)
    V, R = interpVs(Vs, z)
    Rp = normalization(R);
    Gs = IV2dIdVmap(Vs, y)
    V, G = interpVs(Vs, Gs)
    Gp = normalization(G)
    V0 = ustrip(Unitful.Φ0)*$f*1e9*1e9
    heatmap(x, V./V0, [R, Gp], size=(1000, 400), layout=2, xlabel="Power(dBm)", ylabel="V(hf/2e)", cb_title="dV/dI(Ω)", title="$f GHz")
    plot!(x, fill(2, length(x)), color=:red)
    ```

    ```julia
    Vnorm, Ihs = binstep(Vs/V0, y, 0.2)
    heatmap(x, Vnorm, Ihs; clims=(0, max(Ihs...)/4))
    idx1 = argmin(abs.(Vnorm.-1.))
    idx2 = argmin(abs.(Vnorm.-2))
    plot!(x, fill(Vnorm[idx1], length(x)))
    plot!(x, fill(Vnorm[idx2], length(x)))
    Ihs1 = Ihs[idx1,:]
    Ihs2 = Ihs[idx2,:]
    plot(x, loedata(x, Ihs1))
    plot!(x, loedata(x, Ihs2))
    scatter!(x, Ihs1; color=:orange, ms=2)
    scatter!(x, Ihs2; color=:deepskyblue, ms=2)
    ```

    ```julia
    fig = cm.Figure(fontsize=36)
    ax = cm.Axis(fig[1,1],
        title=rich(rich("f", font=:italic), rich("=$f GHz ", font=:regular)),
        xlabel=rich(rich("P", font=:italic), "(dBm)"),
        ylabel=rich(rich("V", font=:italic), "(hf/2e)"),
        xgridvisible=false,
        ygridvisible=false
    )
    p = cm.heatmap!(ax, x, V/V0, transpose(R))
    cm.Colorbar(fig[1,2], p, label=rich("d", rich("V", font=:italic), "/d", rich("I", font=:italic), "(Ω)"))
    cm.hlines!(ax, 2, color=:red, size=2)
    fig
    ```
    """
end

function formatdata(fd::FormatData, ::Val{:rfprff})
    ""
end