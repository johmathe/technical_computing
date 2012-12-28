# Black and white Julia set written in Julia
# Author: johmathe@google.com (Johan Mathe)
#
# http://en.wikipedia.org/wiki/Julia_set

const ITER = 15
const THRESHOLD = 14
const CPLEX_CTE = 0.2+0.65*im

function julia_set(z)
    b=0
    for n = 1:ITER
        b+= (abs(z) <= 2)
        if b > THRESHOLD
		return true
        end
        z = z^2 + CPLEX_CTE
    end
    return false
end

function draw_julia_set(M::Array{Uint8, 2}, n::Int)
    for y = 0:n-1
        for x = 0:n-1
            c = (x-n/2)/n + (y-n/2)/n*im
            if julia_set(c)
                M[div(x, 8) + 1, y + 1] |= 1 << uint8(7 - x%8)
            end
        end
    end
end

function main(args, stream)
    if length(args) > 0
        n = int(args[1])
    else
        n = 2048
    end

    if n%8 != 0
        error("Error: n of $n is not divisible by 8")
    end

    M = zeros(Uint8, div(n, 8), n)
    draw_julia_set(M, n)
    write(stream, "P4\n$n $n\n")
    write(stream, M)
    flush(stream)
end

main(ARGS, stdout_stream)
