#=
julia> ilog2(15),ilog2(-15),ilog2(16),ilog2(-16),ilog2(17),ilog2(-17)
(3,3,4,4,4,4)

julia> ilog2(15.),ilog2(-15.),ilog2(16.),ilog2(-16.),ilog2(17.),ilog2(-17.)
(3,3,4,4,4,4)

julia> ilog2(1/15.),ilog2(-1/15.),ilog2(1/16.),ilog2(-1/16.),ilog2(1/17.),ilog2(-1/17.)
(3,3,3,3,4,4)
=#

@inline ilog2_core{T<:Integer}(x::T) = trailing_zeros(prevpow2(abs(x)))
@inline ilog2_core{T<:AbstractFloat}(x::T) = abs(floor(Int, log2(abs(x))))

ilog2{T<:Integer}(x::T) = 
    ifelse( x!=zero(T), ilog2_core(x), zero(T))
    
ilog2{T<:AbstractFloat}(x::T) = 
    ifelse( x!=zero(T), ilog2_core(x)-(abs(x)<one(T)), zero(T))
