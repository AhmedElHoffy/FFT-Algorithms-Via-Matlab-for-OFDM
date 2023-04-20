%% This function computes the  Fourier Transform(FT)  of Cooley_Tukey algorithm
function output=Cooley_Tukeyy_FFT(data)
pow = nextpow2(length(data));
N=2^pow;
data_new=[data,zeros(1,N-length(data) )];
temp=factor(length(data));
rowsp = floor(length(temp)/2); %5
columnsp= pow-rowsp;
rows=2^rowsp;
columns=2^columnsp;%6
% rows = 16 ; 
% columns = 8 ;
matrix=(reshape(data_new, columns, rows))'; % Read in row wise
test = matrix;
%Perform column-wise dft
for x=1:columns
    matrix(:,x)=FFT(matrix(:,x));
end
Y2=fft(data);
%Perform Twiddles
for x=1:columns
    for y=1:rows
        matrix(y,x)=matrix(y,x)*exp((-2*pi*(y-1)*(x-1)/N)*1i);
    end
end
%Perform FFT on rows
for y=1:rows
    matrix(y,:)=FFT(matrix(y,:));
end
output=Y2;

end
