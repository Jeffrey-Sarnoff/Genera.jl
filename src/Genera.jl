"""
Genera is a modular bringer of benificence to my own soft work.

Float is an alias for a well defined type of floating point abstraction.
At its least expansive, Float is a Union{Float64, Float32}.
Any other type realizing floating point values, that supports
hash, show, +,-,*,/,sqrt,fma,isless,isequal,==,!=,<,<=,>=,>
is elegible for inclusion in the set of types that Float covers.
For example, Float16 and BigFloat could be included.
"""
module Genera

export SysFloat, StdFloat, SysInt, StdInt,
       @delegate, @delegate2,
       @delegateTyped, @delegateTyped2


!isdefined(:SysFloat) && typealias SysFloat Union{Float64, Float32}
!isdefined(:StdFloat) && typealias StdFloat Union{Float64, Float32, Float16}

!isdefined(:SysInt) && typealias SysInt Union{Int64, Int32}
!isdefined(:StdInt) && typealias StdInt Union{Int64, Int32, Int16}

include("delegate.jl")


end # Genera
