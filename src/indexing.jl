function overlaps(x::AbstractArray, y::AbstractArray, n::Int=1)
    if n == 1
        xx = falses(x)
        for i = 1:size(x,1), j = 1:size(y,1)
            if x[i] == y[j]
                xx[i] = true
            end
        end
        return xx
    elseif n == 2
        yy = falses(y)
        for i = 1:size(x,1), j = 1:size(y,1)
            if x[i] == y[j]
                yy[i] = true
            end
        end
        return yy
    else
        error("Argument `n` must be either 1 (x) or 2 (y).")
    end
end
#===============================================================================
							NUMERICAL INDEXING
===============================================================================#
getindex(x::TS) = x
getindex(x::TS, ::Colon) = x
getindex(x::TS, ::Colon, ::Colon) = x
getindex(x::TS, ::Colon, c::Int) = TS(x.values[:,c], x.index, [x.fields[c]])
getindex(x::TS, ::Colon, c::AbstractArray{Int,1}) = TS(x.values[:,c], x.index, x.fields[c])
getindex(x::TS, r::Int) = ts(x.values[r,:], x.index[r], x.fields)
getindex(x::TS, r::Int, ::Colon) = TS(x.values[r,:], [x.index[r]], x.fields)
getindex(x::TS, r::Int, c::Int) = TS([x.values[r,c]], [x.index[r]], [x.fields[c]])
getindex(x::TS, r::Int, c::AbstractArray{Int,1}) = TS(x.values[r,c], [x.index[r]], x.fields[c])
getindex(x::TS, r::AbstractArray{Int,1}) = ts(x.values[r,:], x.index[r], x.fields)
getindex(x::TS, r::AbstractArray{Int,1}, ::Colon) = TS(x.values[r,:], x.index[r], x.fields)
getindex(x::TS, r::AbstractArray{Int,1}, c::Int) = TS(x.values[r,c], x.index[r], [x.fields[c]])
getindex(x::TS, r::AbstractArray{Int,1}, c::AbstractArray{Int,1}) = TS(x.values[r, c], x.index[r], x.fields[c])

#===============================================================================
							BOOLEAN INDEXING
===============================================================================#
getindex(x::TS, r::BitArray{1}) = TS(x.values[r,:], x.index[r], x.fields)
getindex(x::TS, r::BitArray{1}, ::Colon) = TS(x.values[r,:], x.index[r], x.fields)
getindex(x::TS, r::BitArray{1}, c::Int) = TS(x.values[r,c], x.index[r], x.fields[c])
getindex(x::TS, r::BitArray{1}, c::AbstractArray{Int,1}) = TS(x.values[r,c], x.index[r], x.fields[c])
getindex(x::TS, r::BitArray{1}, c::BitArray{1}) = TS(x.values[r,c], x.index[r], x.fields[c])
getindex(x::TS, ::Colon, c::BitArray{1}) = TS(x.values[r,c], x.index[r], x.fields[c])
getindex(x::TS, r::Int, c::BitArray{1}) = TS(x.values[r,c], x.index[r], x.fields[c])
getindex(x::TS, r::AbstractArray{Int,1}, c::BitArray{1}) = TS(x.values[r,c], x.index[r], x.fields[c])


#===============================================================================
							TEMPORAL INDEXING
===============================================================================#
getindex(x::TS, t::TimeType) = x[find(map((r) -> r == t, x.index))]
getindex(x::TS, t::TimeType, ::Colon) = x[find(map((r) -> r == t, x.index)), :]
getindex(x::TS, t::TimeType, c::Int) = x[find(map((r) -> r == t, x.index)), c]
getindex(x::TS, t::TimeType, c::AbstractArray{Int,1}) = x[find(map((r) -> r == t, x.index)), c]
getindex(x::TS, t::TimeType, c::BitArray{1}) = TS(x.values[r,c], x.index[r], x.fields[c])
getindex(x::TS, t::AbstractArray{Date,1}) = x[overlaps(x.index, t)]
getindex(x::TS, t::AbstractArray{Date,1}, ::Colon) = x[overlaps(x.index, t), :]
getindex(x::TS, t::AbstractArray{Date,1}, c::Int) = x[overlaps(x.index, t), c]
getindex(x::TS, t::AbstractArray{Date,1}, c::AbstractArray{Int,1}) = x[overlaps(x.index, t), c]
getindex(x::TS, t::AbstractArray{Date,1}, c::BitArray{1}) = x[overlaps(x.index, t), c]
getindex(x::TS, t::AbstractArray{DateTime,1}) = x[overlaps(x.index, t)]
getindex(x::TS, t::AbstractArray{DateTime,1}, ::Colon) = x[overlaps(x.index, t), :]
getindex(x::TS, t::AbstractArray{DateTime,1}, c::Int) = x[overlaps(x.index, t), c]
getindex(x::TS, t::AbstractArray{DateTime,1}, c::AbstractArray{Int,1}) = x[overlaps(x.index, t), c]
getindex(x::TS, t::AbstractArray{DateTime,1}, c::BitArray{1}) = x[overlaps(x.index, t), c]

#===============================================================================
							TEXTUAL INDEXING
===============================================================================#
getindex(x::TS, ::Colon, c::ByteString) = x[:, find(x.fields .== c)]
getindex(x::TS, ::Colon, c::ASCIIString) = x[:, find(x.fields .== c)]
getindex(x::TS, ::Colon, c::UTF8String) = x[:, find(x.fields .== c)]
getindex(x::TS, ::Colon, c::Vector{ByteString}) = x[:, find(overlaps(x.fields, c))]
getindex(x::TS, ::Colon, c::Vector{ASCIIString}) = x[:, find(overlaps(x.fields, c))]
getindex(x::TS, ::Colon, c::Vector{UTF8String}) = x[:, find(overlaps(x.fields, c))]
getindex(x::TS, r::Int, c::ByteString) = x[r, find(x.fields .== c)]
getindex(x::TS, r::Int, c::ASCIIString) = x[r, find(x.fields .== c)]
getindex(x::TS, r::Int, c::UTF8String) = x[r, find(x.fields .== c)]
getindex(x::TS, r::Int, c::Vector{ByteString}) = x[r, find(overlaps(x.fields, c))]
getindex(x::TS, r::Int, c::Vector{ASCIIString}) = x[r, find(overlaps(x.fields, c))]
getindex(x::TS, r::Int, c::Vector{UTF8String}) = x[r, find(overlaps(x.fields, c))]
getindex(x::TS, r::AbstractArray{Int,1}, c::ByteString) = x[r, find(x.fields .== c)]
getindex(x::TS, r::AbstractArray{Int,1}, c::ASCIIString) = x[r, find(x.fields .== c)]
getindex(x::TS, r::AbstractArray{Int,1}, c::UTF8String) = x[r, find(x.fields .== c)]
getindex(x::TS, r::AbstractArray{Int,1}, c::Vector{ByteString}) = x[r, find(overlaps(x.fields, c))]
getindex(x::TS, r::AbstractArray{Int,1}, c::Vector{ASCIIString}) = x[r, find(overlaps(x.fields, c))]
getindex(x::TS, r::AbstractArray{Int,1}, c::Vector{UTF8String}) = x[r, find(overlaps(x.fields, c))]
getindex(x::TS, r::BitArray{1}, c::ByteString) = x[r, find(x.fields .== c)]
getindex(x::TS, r::BitArray{1}, c::ASCIIString) = x[r, find(x.fields .== c)]
getindex(x::TS, r::BitArray{1}, c::UTF8String) = x[r, find(x.fields .== c)]
getindex(x::TS, r::BitArray{1}, c::Vector{ByteString}) = x[:, find(overlaps(x.fields, c))]
getindex(x::TS, r::BitArray{1}, c::Vector{ASCIIString}) = x[:, find(overlaps(x.fields, c))]
getindex(x::TS, r::BitArray{1}, c::Vector{UTF8String}) = x[:, find(overlaps(x.fields, c))]

function thrudt(s::AbstractString, t::Vector{Date})
    n = length(s)
    if n == 4  # yyyy given
        y = parse(Int, s)
        ymd = Date(y, 12, 31)
    elseif n == 7  # yyyy-mm given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        ymd = lastdayofmonth(Date(y, m, 1))
    elseif n == 10  # yyyy-mm-dd given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        d = parse(Int, a[3])
        ymd = Date(y, m, d)
    else
        error("Unable to parse date string $s.")
    end
    return t .<= ymd
end
function fromdt(s::AbstractString, t::Vector{Date})
    n = length(s)
    if n == 4  # yyyy given
        y = parse(Int, s)
        ymd = Date(y, 1, 1)
    elseif n == 7  # yyyy-mm given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        ymd = Date(y, m, 1)
    elseif n == 10  # yyyy-mm-dd given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        d = parse(Int, a[3])
        ymd = Date(y, m, d)
    else
        error("Unable to parse date string $s.")
    end
    return t .>= ymd
end
function thisdt(s::AbstractString, t::Vector{Date})
    n = length(s)
    if n == 4  # yyyy given
        y = parse(Int, s)
        return year(t) .== y
    elseif n == 7  # yyyy-mm given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        return (year(t) .== y) .* (month(t) .== m)
    elseif n == 10  # yyyy-mm-dd given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        d = parse(Int, a[3])
        return (year(t) .== y) .* (month(t) .== m) .* day(t) .== d
    else
        error("Unable to parse date string $s.")
    end
end
function fromthru(from::AbstractString, thru::AbstractString, t::Vector{Date})
    fromidx = fromdt(from, t)
    thruidx = thrudt(thru, t)
    return fromidx .* thruidx
end
function thrudt(s::AbstractString, t::Vector{DateTime})
    n = length(s)
    if n == 4  # yyyy given
        y = parse(Int, s)
        ymdhms = DateTime(y, 12, 31)
    elseif n == 7  # yyyy-mm given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        ymdhms = lastdayofmonth(DateTime(y, m, 1))
    elseif n == 10  # yyyy-mm-dd given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        d = parse(Int, a[3])
        ymdhms = DateTime(y, m, d)
    elseif n == 13  # yyyy-mm-ddTHH given
        a = split(s, 'T')
        b = split(a[1], '-')
        c = split(a[2], ':')
        y = parse(Int, b[1])
        m = parse(Int, b[2])
        d = parse(Int, b[3])
        hr = parse(Int, c[1])
        min = 59
        sec = 59
        ymdhms = DateTime(y, m, d, hr, min, sec)
    elseif n == 16  # yyyy-mm-ddTHH:MM given
        a = split(s, 'T')
        b = split(a[1], '-')
        c = split(a[2], ':')
        y = parse(Int, b[1])
        m = parse(Int, b[2])
        d = parse(Int, b[3])
        hr = parse(Int, c[1])
        min = parse(Int, c[2])
        sec = 59
        ymdhms = DateTime(y, m, d, hr, min, sec)
    elseif n == 19  # yyyy-mm-ddTHH:MM:SS given
        a = split(s, 'T')
        b = split(a[1], '-')
        c = split(a[2], ':')
        y = parse(Int, b[1])
        m = parse(Int, b[2])
        d = parse(Int, b[3])
        hr = parse(Int, c[1])
        min = parse(Int, c[2])
        sec = parse(Int, c[3])
        ymdhms = DateTime(y, m, d, hr, min, sec)
    else
        error("Unable to parse date string $s.")
    end
    return t .<= ymdhms
end
function fromdt(s::AbstractString, t::Vector{DateTime})
    n = length(s)
    if n == 4  # yyyy given
        y = parse(Int, s)
        ymdhms = DateTime(y)
    elseif n == 7  # yyyy-mm given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        ymdhms = DateTime(y, m)
    elseif n == 10  # yyyy-mm-dd given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        d = parse(Int, a[3])
        ymdhms = DateTime(y, m, d)
    elseif n == 13  # yyyy-mm-ddTHH given
        a = split(s, 'T')
        b = split(a[1], '-')
        c = split(a[2], ':')
        y = parse(Int, b[1])
        m = parse(Int, b[2])
        d = parse(Int, b[3])
        hr = parse(Int, c[1])
        ymdhms = DateTime(y, m, d, hr, min, sec)
    elseif n == 16  # yyyy-mm-ddTHH:MM given
        a = split(s, 'T')
        b = split(a[1], '-')
        c = split(a[2], ':')
        y = parse(Int, b[1])
        m = parse(Int, b[2])
        d = parse(Int, b[3])
        hr = parse(Int, c[1])
        min = parse(Int, c[2])
        ymdhms = DateTime(y, m, d, hr, min, sec)
    elseif n == 19  # yyyy-mm-ddTHH:MM:SS given
        a = split(s, 'T')
        b = split(a[1], '-')
        c = split(a[2], ':')
        y = parse(Int, b[1])
        m = parse(Int, b[2])
        d = parse(Int, b[3])
        hr = parse(Int, c[1])
        min = parse(Int, c[2])
        sec = parse(Int, c[3])
        ymdhms = DateTime(y, m, d, hr, min, sec)
    else
        error("Unable to parse date string $s.")
    end
    return t .>= ymdhms
end
function thisdt(s::AbstractString, t::Vector{DateTime})
    n = length(s)
    if n == 4  # yyyy given
        y = parse(Int, s)
        return year(t) .== y
    elseif n == 7  # yyyy-mm given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        return (year(t) .== y) .* (month(t) .== m)
    elseif n == 10  # yyyy-mm-dd given
        a = split(s, '-')
        y = parse(Int, a[1])
        m = parse(Int, a[2])
        d = parse(Int, a[3])
        return (year(t) .== y) .* (month(t) .== m) .* (day(t) .== d)
    elseif n == 13  # yyyy-mm-ddTHH given
        a = split(s, 'T')
        b = split(a[1], '-')
        c = split(a[2], ':')
        y = parse(Int, b[1])
        m = parse(Int, b[2])
        d = parse(Int, b[3])
        hr = parse(Int, c[1])
        return (year(t) .== y) .* (month(t) .== m) .* (day(t) .== d) .* (hour(t) .== hr)
    elseif n == 16  # yyyy-mm-ddTHH:MM given
        a = split(s, 'T')
        b = split(a[1], '-')
        c = split(a[2], ':')
        y = parse(Int, b[1])
        m = parse(Int, b[2])
        d = parse(Int, b[3])
        hr = parse(Int, c[1])
        min = parse(Int, c[2])
        return (year(t) .== y) .* (month(t) .== m) .* (day(t) .== d) .* (hour(t) .== hr) .* (minute(t) .== min)
    elseif n == 19  # yyyy-mm-ddTHH:MM:SS given
        a = split(s, 'T')
        b = split(a[1], '-')
        c = split(a[2], ':')
        y = parse(Int, b[1])
        m = parse(Int, b[2])
        d = parse(Int, b[3])
        hr = parse(Int, c[1])
        min = parse(Int, c[2])
        sec = parse(Int, c[3])
        return (year(t) .== y) .* (month(t) .== m) .* (day(t) .== d) .* (hour(t) .== hr) .* (minute(t) .== min) .* (second(t) .== sec)
    else
        error("Unable to parse date string $s.")
    end
end
function fromthru(from::AbstractString, thru::AbstractString, t::Vector{DateTime})
    fromidx = fromdt(from, t)
    thruidx = thrudt(thru, t)
    return fromidx .* thruidx
end

function dtidx(s::AbstractString, t::Vector{Date})
    @assert !in('T', s) "Cannot index Date type with sub-daily frequency."
    bds = split(s, "::")
    if length(bds) == 1  # single date
        return thisdt(s, t)
    elseif length(bds) == 2  # date range
        n1 = length(bds[1])
        n2 = length(bds[2])
        if n1 == 0 && n2 != 0  # thru date given
            return thrudt(bds[2], t)
        elseif n1 != 0 && n2 == 0  # from date given
            return fromdt(bds[1], t)
        elseif n1 != 0 && n2 != 0  # from and thru date given
            return fromthru(bds[1], bds[2], t)
        else
            error("Invalid indexing string: Unable to parse $s")
        end
    else
        error("Invalid indexing string: Unable to parse $s")
    end
end
function dtidx(s::AbstractString, t::Vector{DateTime})
    @assert !in('T', s) "Cannot index Date type with sub-daily frequency."
    bds = split(s, "::")
    if length(bds) == 1  # single date
        return thisdt(s, t)
    elseif length(bds) == 2  # date range
        n1 = length(bds[1])
        n2 = length(bds[2])
        if n1 == 0 && n2 != 0  # thru date given
            return thrudt(bds[2], t)
        elseif n1 != 0 && n2 == 0  # from date given
            return fromdt(bds[1], t)
        elseif n1 != 0 && n2 != 0  # from and thru date given
            return fromthru(bds[1], bds[2], t)
        else
            error("Invalid indexing string: Unable to parse $s")
        end
    else
        error("Invalid indexing string: Unable to parse $s")
    end
end

getindex(x::TS, r::AbstractString) = x[dtidx(r, x.index)]
getindex(x::TS, r::AbstractString, ::Colon) = x[dtidx(r, x.index)]
getindex(x::TS, r::AbstractString, c::Int) = x[dtidx(r, x.index), c]
getindex(x::TS, r::AbstractString, c::AbstractArray{Int,1}) = x[dtidx(r, x.index), c]
getindex(x::TS, r::AbstractString, c::BitArray{1}) = x[dtidx(r, x.index), c]
getindex(x::TS, r::AbstractString, c::ByteString) = x[dtidx(r, x.index), c]
getindex(x::TS, r::AbstractString, c::ASCIIString) = x[dtidx(r, x.index), c]
getindex(x::TS, r::AbstractString, c::UTF8String) = x[dtidx(r, x.index), c]
getindex(x::TS, r::AbstractString, c::Vector{ByteString}) = x[dtidx(r, x.index), c]
getindex(x::TS, r::AbstractString, c::Vector{ASCIIString}) = x[dtidx(r, x.index), c]
getindex(x::TS, r::AbstractString, c::Vector{UTF8String}) = x[dtidx(r, x.index), c]
