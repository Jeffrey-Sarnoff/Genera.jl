#=
    by John Myles White 
    (description and logic from https://gist.github.com/johnmyleswhite/5225361)

    A macro for doing delegation

    This macro call
 
       @delegate MyContainer.elems [ size,  length,  endof]    #  exported implementation
       
       # the original implementation's macro call was thus:
       # @delegate MyContainer.elems [:size, :length, :endof] 

    produces this block of expressions
 
      size(  a::MyContainer) = size(  a.elems)
      length(a::MyContainer) = length(a.elems)
      endof( a::MyContainer) = endof( a.elems)


     
    also this from Toivo for delegation with nary ops
    (https://groups.google.com/forum/#!msg/julia-dev/MV7lYRgAcB0/-tS50TreaPoJ)
    
    julia> type T
               x
           end

    julia> import Base.sin, Base.cos

    julia> for f in (:+, :- )    # delegate binary + and - to T.x
               @eval $f(a::T, b::T) = $f(a.x, b.x)
           end

    julia> for f in (:sin, :cos) # delegate sin and cos
               @eval $f(a::T) = $f(a.x)
           end


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

# for methods that take two equi-typed source arguments

macro delegate2(sourceExemplar, targets)
  typesname = esc(sourceExemplar.args[1])
  fieldname = esc(Expr(:quote, sourceExemplar.args[2].args[1]))
  funcnames = targets.args
  n = length(funcnames)
  fdefs = Array(Any, n)
  for i in 1:n
    funcname = esc(funcnames[i])
    fdefs[i] = quote
                 ($funcname)(a::($typesname), b::($typesname), args...) = 
                   ($funcname)(a.($fieldname), b.($fieldname), args...)
               end
    end
  return Expr(:block, fdefs...)
end


# for methods that take one typed argument and return an iso-typed result

macro delegateTyped(source, targets)
  typename = esc(source.args[1])
  fieldname = esc(Expr(:quote, source.args[2].args[1]))
  funcnames = targets.args
  n = length(funcnames)
  fdefs = Array(Any, n)
  for i in 1:n
    funcname = esc(funcnames[i])
    fdefs[i] = quote
                 ($funcname)(a::($typename), args...) = 
                   ($typename)( ($funcname)(a.($fieldname), args...) )
               end
    end
  return Expr(:block, fdefs...)
end


# for methods that take two equi-typed source arguments) and return an iso-typed result

macro delegateTyped2(sourceExemplar, targets)
  typesname = esc(sourceExemplar.args[1])
  fieldname = esc(Expr(:quote, sourceExemplar.args[2].args[1]))
  funcnames = targets.args
  n = length(funcnames)
  fdefs = Array(Any, n)
  for i in 1:n
    funcname = esc(funcnames[i])
    fdefs[i] = quote
                 ($funcname)(a::($typesname), b::($typesname), args...) = 
                   ($typesname)( ($funcname)(a.($fieldname), b.($fieldname), args...) )
               end
    end
  return Expr(:block, fdefs...)
end
