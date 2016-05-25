function agm{R<:Real}(a::R, b::R)
    half = isdefined(:parse, (R,)) ? parse(R,"0.5") : (R)(0.5) 
    maxIterations = sizeof(R)*8

    a,b = minmax(a,b)
    a0, b0 = deepcopy(a), deepcopy(b)
    
    for i in 1:maxIterations
    
        if (eps(a) == eps(b))
           if (significand(a) == significand(b))
              break
           else
              a, b = (abs(a) < abs(b)) ? (a,b) : (b,a)
           end
        end
        
        a = (a0 + b0) * half
        b = sqrt( a0 * b0 )
        
        
        (abs(a-b) < eps(a)) & (eps(a)
           break
        end   
    end
end
