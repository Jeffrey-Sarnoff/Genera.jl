"""
JAS is a modular bringer of benificence to my own soft work.


"""
module JAS

"""
Float is an alias for a well defined type of floating point abstraction.
At its least expansive, Float is a Union{Float64, Float32}.
Any other type realizing floating point values, that supports
hash, show, +,-,*,/,sqrt,fma,isless,isequal,==,!=,<,<=,>=,>
is elegible for inclusion in the set of types that Float covers.
For example, Float16 and BigFloat could be included.
""" -> Float

!isdefined(Float) && typealias Float Union{Float64, Float32, Float16}



end # JAS
