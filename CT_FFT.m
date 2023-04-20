%% Cooley-Tukey implementation 
function cooley_tukey(x)
    N = length(x);
    if (N > 2)
        x_odd = cooley_tukey(x(1:2:N))
        x_even = cooley_tukey(x(2:2:N))
    else
        x_odd = x(1);
        x_even = x(2);
    end
    n = 0:N-1;
    half = div(N,2);
    factor = exp.(-2i*pi*n/N);
    return vcat(x_odd .+ x_even .* factor[1:half],x_odd .(- x_even .* factor(1:half)))

end