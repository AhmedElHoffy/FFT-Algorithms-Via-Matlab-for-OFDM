%% used for Cooley-Tukeyy computation
function output = FFT(input)
 n = length(input);
 output = zeros(size(input));
 for k = 0 : n - 1  % For each output element
   s = 0;
    for t = 0 : n - 1  % For each input element
     s = s + input(t + 1) * exp(-2i * pi * t * k / n);
   end
   output(k + 1) = s;
 end
end


