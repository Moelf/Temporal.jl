# Autocorrelation

#TODO: move to another file to maintain a more logical structure

function lagindex(x::Vector{Float64}, n::Int=1)::UnitRange{Int}
    @assert n < size(x,1)
    N = size(x, 1)
    idx = 1:N
    if n == 0
        return idx
    elseif n > 0
        return idx[n+1:N]
    elseif n < 0
        return idx[1:N+n]
    end
end


function lag(x::Vector{Float64}, n::Int=1; pad::Bool=true, padval::Float64=NaN)
    if n==0
        return x
    elseif n>0
        if pad
            return [ones(n)*padval; x[n+1:end]]
        else
            return x[n+1:end]
        end
    elseif n<0
        n *= -1
        if pad
            return [x[1:end-n]; ones(n)*padval]
        else
            return x[1:end-n]
        end
    end
end


function corlag{T<:Number}(x::AbstractArray{T,1}, n::Int=1)
    if n == 0
        return 1.0
    end
    @assert n > 0
    @assert n < size(x,1) - 2
    idx = lagindex(x, n)
    return cor(x[idx-n], x[idx])
end

@doc """
Compute the autocorrelation function of a univariate time series

`acf{T<:Number}(x::AbstractArray{T,1}, maxlag::Int=15; lags::AbstractArray{Int,1}=0:maxlag)`
""" ->
function acf{T<:Number}(x::Vector{T}, maxlag::Int=15; lags::AbstractArray{Int,1}=0:maxlag)::Vector{Float64}
    @assert all(lags .< size(x,1)-2)
    return map((n) -> corlag(x, n), lags)
end

function acf{T<:Number}(x::Matrix{T}, maxlag::Int=15; lags::AbstractVector{Int}=0:maxlag)::Matrix{Float64}
    k = size(x,2)
    out = zeros(Float64, (length(lags), k))
    @inbounds for j in 1:k
        out[:,j] = acf(x[:,j], maxlag, lags=lags)
    end
    return out
end

acf(x::TS, maxlag::Int=15; lags::AbstractArray{Int,1}=0:maxlag) = acf(x.values, maxlag; lags=lags)

