clc; clf; close all; clear all;
N = 128;
rows = 8; %5
columns=16;%6
data = linspace(0, 2*pi, N);
data = sin(data)+0.1*sin(pi*data);
tic;
Y2=fft(data);
time2=toc;
plot(data);
title('Sine wave');
count=1;
tic;
matrix=(reshape(data, columns, rows))'; % Read in row wise
test = matrix;
%Perform column-wise dft
for x=1:columns
    matrix(:,x)=FFT(matrix(:,x));
end
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
out=20*log10(abs(reshape(matrix,1,N)));
time1=toc;
figure
subplot(211);
stem(out); title('Using cooley-tukey');
subplot(212);
stem(20*log10(abs(fft(data)))); title('Using fft');
