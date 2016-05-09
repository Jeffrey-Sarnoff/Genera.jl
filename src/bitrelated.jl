
@inline ilog2_core{T::Integer}(x::T) = trailing_zeros(prevpow2(abs(x)))
@inline ilog2_core{T::AbstractFloat}(x::T) = floor(Int, log2(abs(x)))

ilog2{T:<Union{Integer,AbstractFloat}(x::T) = 
    ifelse( x>=one(T), 
            ilog2_core(x),
            ifelse( x>zero(T),
                    ilog2_core(x)+one(T),
                    zero(T)
          )       )
