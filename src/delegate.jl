#=
    by John Myles White 
    (description and logic from https://gist.github.com/johnmyleswhite/5225361)

    A macro for doing delegation

    This macro call
 
       @delegate MyContainer.elems [:size, :length, :endof]

    produces this block of expressions
 
      size(  a::MyContainer) = size(  a.elems)
      length(a::MyContainer) = length(a.elems)
      endof( a::MyContainer) = endof( a.elems)


     macro text from
     https://github.com/JuliaLang/DataStructures.jl/blob/master/src/delegate.jl
=#

macro delegate(source, targets)
  typename = esc(source.args[1])
  fieldname = esc(Expr(:quote, source.args[2].args[1]))
  funcnames = targets.args
  n = length(funcnames)
  fdefs = Array(Any, n)
  for i in 1:n
    funcname = esc(funcnames[i])
    fdefs[i] = quote
                 ($funcname)(a::($typename), args...) = ($funcname)(a.($fieldname), args...)
               end
    end
  return Expr(:block, fdefs...)
end
