export read_matpower_m_file, load_rts_timeseries

function read_matpower_m_file(mfile)
    text = read(mfile, String)
    parse_mat(s) = reduce(vcat, (permutedims(parse.(Float64, split(strip(r), r"\s+")))
                                 for r in split(s, ';') if !isempty(strip(r))))

    fields = Dict{String,String}()
    for m in eachmatch(r"mpc\.(\w+)\s*=\s*(?:\[(.*?)\]|([^;\n]+))"s, text)
        fields[m.captures[1]] = something(m.captures[2], m.captures[3])
    end

    return (basemva = parse(Float64, fields["baseMVA"]),
            bus     = parse_mat(fields["bus"]),
            branch  = parse_mat(fields["branch"]),
            gen     = parse_mat(fields["gen"]),
            gencost = parse_mat(fields["gencost"]))
end

function load_rts_timeseries(rts_time_series_file::String)
    raw = DataFrame(CSV.File(rts_time_series_file))
    return loadprofile = Timeseries(
        Matrix(raw[:,5:end]), (size(raw)[2] - 4), Matrix(raw[:,1:4]), names(raw)[1:4], maximum(raw[:,4])
    )
end


