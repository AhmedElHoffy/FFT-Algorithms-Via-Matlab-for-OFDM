

clc; clear all; close all;
t=1:0.1:5;
x=sin(t);
y1=fft(x);
y2=FFT_snails(x,length(x));

figure(1);
subplot(2,1,1);stem(t,real(y1)); xlabel('t-samples'); ylabel('y1-real'); title('FFT real output');
subplot(2,1,2);stem(t,imag(y1)); xlabel('t-samples'); ylabel('y1-imag'); title('FFT imag output')
title('y1-imagrinary output');
figure(2);
subplot(2,1,1);stem(t,real(y2)); xlabel('t-samples'); ylabel('y2-real'); title('FFT-Snails real output');
subplot(2,1,2);stem(t,imag(y2)); xlabel('t-samples'); ylabel('y2-imag'); title('FFT-Snails imag output');
%%%%%%%%%%%%%
% 
% Xf=[1,2,3,4,5];
% Y1=ifft(Xf);
% Y2=IFFT_snails(Xf,length(Xf));
% 

