
# ilog2_core assumes x>0
@inline ilog2_core{T::Integer}(x::T) = trailing_zeros(prevpow2(x))
@inline ilog2_core{T::AbstractFloat}(x::T) = floor(Int, log2(x))

ilog2{T:<Union{Integer,AbstractFloat}(x::T) = 
    ifelse( x>zero(T), 
            ilog2_core(x),
            ifelse( x!=zero(T),
                    ilog2_core(-x),
                    zero(T)
          )       )
