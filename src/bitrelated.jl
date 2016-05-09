#=
=#

@inline ilog2_core{T<:Integer}(x::T) = trailing_zeros(prevpow2(abs(x)))
@inline ilog2_core{T<:AbstractFloat}(x::T) = abs(floor(Int, log2(abs(x))))

ilog2{T<:Integer}(x::T) = 
    ifelse( x!=zero(T), ilog2_core(x), zero(T))
    
ilog2{T<:AbstractFloat}(x::T) = 
    ifelse( x!=zero(T), ilog2_core(x)-(abs(x)<one(T)), zero(T))
