
function n=IFFT_snails(k,nfft)
 N=length(k);      % Defining the length of inputs x(n)
 n=zeros(1,nfft);  % creating an array of x(k) outputs with same length of inputs
 Sum=0;            % initializing the summation for use inside the loops
 for i=1:nfft      % creating the outer loop 
     for jj=1:N    % creating the inner loop
         Sum=Sum+k(jj)*exp(2*pi*1i*(jj-1)*(i-1)/nfft);  % Plugging the values of the formula
     end
 n(i)=Sum/nfft;    %plugging the final result of the inner lopp in the index of the outer element
 Sum=0;             % Reset
 end
 return            % to assure stopping execution of the function at the end
end