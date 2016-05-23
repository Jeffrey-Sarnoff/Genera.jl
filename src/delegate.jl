#=
    originally by John Myles White (see end of file for source code refs)
=#
"""
    macros for doing delegation

    Given these types
    
       type MyInts                     type MyNums{T}
          elems::Int                      elems::T
       end                             end
        
    These macro calls
 
       @delegate MyInts.elems [ size,  length,  endof]    #  exported implementation
       @delegate MyNums.elems [ size,  length,  endof]    #  exported implementation
       
    produces these blocks of expressions
 
      size(  a::MyInts) = size(   getfield(a, :elems) )
      length(a::MyInts) = length( getfield(a, :elems) )
      endof( a::MyInts) = endof(  getfield(a, :elems) )

      size(  a::MyNums) = size(   getfield(a, :elems) )
      length(a::MyNums) = length( getfield(a, :elems) )
      endof( a::MyNums) = endof(  getfield(a, :elems) )

    and allows
    
      myInts = MyInts([5, 4, 3, 2, 1])
      myNums = MyNums([1.0, 2.0, 3.0])
      
      length(myInts) # 5
      length(myNums) # 3
      
      endof(myInts) # 1
      endof(myNums) # 3.0
"""
macro delegate(source, targets)
  typename = esc(source.args[1])
  fieldname = esc(Expr(:quote, source.args[2].args[1]))
  funcnames = targets.args
  n = length(funcnames)
  fdefs = Array(Any, n)
  for i in 1:n
    funcname = esc(funcnames[i])
    fdefs[i] = quote
                 ($funcname)(a::($typename), args...) = ($funcname)(getfield(a,($fieldname)), args...)
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
                   ($funcname)(getfield(a,($fieldname)), getfield(b,($fieldname)), args...)
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
                   ($typename)( ($funcname)(getfield(a,($fieldname)), args...) )
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
                   ($typesname)( ($funcname)(getfield(a,($fieldname)), getfield(b,($fieldname)), args...) )
               end
    end
  return Expr(:block, fdefs...)
end

#=
    initial implementation
    (description and logic from https://gist.github.com/johnmyleswhite/5225361)

    additional macro text from
      https://github.com/JuliaLang/DataStructures.jl/blob/master/src/delegate.jl

     
    and from Toivo for delegation with nary ops
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
=#

