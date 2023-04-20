%% Name :-  Ahmed Ismail El Hoofy    
clc; clear all; close all;
%% ---------------------------------;----------- EE-488(Communication senior Design Class)----------------------------
%% The Main code for FFT algorithms
N=[2,4,8,16,32,64,128,256,512];
timefft=zeros(1,length(N))';
timeCT=zeros(1,length(N))';
timeRadix2DIT=zeros(1,length(N))';
timeRadix2DIF=zeros(1,length(N))';
timeRadix4DIF=zeros(1,length(N))';
for (i=1:length(N)) 
    data = linspace(0, 2*pi, N(i));
 X=sinc(data);
 X2=triangularPulse(data);
 tic;
 y1 = fft(X);
 timefft(i)=toc;
 tic;
 y2= Cooley_Tukeyy_FFT(X);
 timeCT(i)=toc;
 tic; 
 y3 = FFT_Radix2_DIT(X);
 timeRadix2DIT(i)=toc;
 tic;
 y4 = FFT_Radix2_DIF(X);
 timeRadix2DIF(i)=toc;
 tic;
 y5 = FFT_Radix4_DIF(X);
 timeRadix4DIF(i)=toc;
 y11 = fft(X2);
 y22= Cooley_Tukeyy_FFT(X2);
 y33 = FFT_Radix2_DIT(X2);
 y44 = FFT_Radix2_DIF(X2);
 y55 = FFT_Radix4_DIF(X2);
end

Mat_Time=zeros(length(N),5);
Mat_Time(:,1)= timefft;
Mat_Time(:,2)= timeCT;
Mat_Time(:,3)= timeRadix2DIF;
Mat_Time(:,4)= timeRadix2DIT;
Mat_Time(:,5)= timeRadix4DIF;

figure;

semilogy(N,timefft,'-'); 
hold on;
semilogy(N,timeCT); 
hold on;
semilogy(N,timeRadix2DIT,'--'); 
hold on;
semilogy(N,timeRadix2DIF);
hold on;
semilogy(N,timeRadix4DIF);
hold off;
title('Comparison between Different FFT algorithms with various N length');
xlabel('Number of bits');
ylabel('Computation Time in ms');
legend('fft' ,'Cooley-Tukey','Radix2 DIT','Radix2 DIF', 'Radix4 DIF');
 
figure;
stem(X); title('Sinc Wave in time domain');


figure;
subplot(2,1,1); stem(y2); title('Cooley Tukey FFT of sinc(x)');
subplot(2,1,2); stem(y3); title('FFT Radix2 DIT of sinc(X)');

figure;
subplot(2,1,1); stem(y4); title('FFT Radix2 DIF of sinc(X)');
subplot(2,1,2); stem(y5); title('FFT Radix4 DIF of sinc(X)');

figure; 
stem(X2); title('Tirangular Pulse');

figure;
subplot(2,1,1); stem(y22); title('Cooley Tukeyy FFT of Tri(x)');
subplot(2,1,2); stem(y33); title('FFT Radix2 DIT of tri(X)');
figure;
subplot(2,1,1); stem(y44); title('FFT Radix2 DIF of tri(X)');
subplot(2,1,2); stem(y55); title('FFT Radix4 DIF of tri(X)');

