%% This function computes the Inverse Fourier Transform(IFT)  of Cooley_Tukey algorithm
function output=Cooley_Tukeyy_IFFT(data)
pow = nextpow2(length(data));
N=2^pow;
data_new=[data,zeros(1,N-length(data) )];

rows = sqrt(N); 
columns=sqrt(N);
matrix=(reshape(data_new, columns, rows))'; % Read in row wise
test = matrix;
%Perform column-wise dft
for x=1:columns
    matrix(:,x)=IFFT(matrix(:,x));
end
Y2=ifft(data);
%Perform Twiddles
for x=1:columns
    for y=1:rows
        matrix(y,x)=matrix(y,x)*exp((2*pi*(y-1)*(x-1)/N)*1i);
    end
end

%Perform FFT on rows
for y=1:rows
    matrix(y,:)=IFFT(matrix(y,:));
end
output=Y2;

end
