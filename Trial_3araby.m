%% OFDM 
clear all; close all; clc;
% n_FFT , n_Symbols
n_sc= 2048;       %number of subcarriers= n_FFT = 2048
n_sym= 1e3;       % number of OFDM symbols

% Modulation Type

M = 16;            % Modulation: 16-QAM
k = log2(M);       % number of bits per symbol
mod = modem.qammod ('M',M,'SymbolOrder','Gray');
demod = modem.qamdemod(mod);

% cyclic Prefix
n_cp= 16;             % cyclic prefix=[0,16,32,64] symbols --> powers of 2

% channel type
chan_type='AWGN';
EbN0= 0:16;
SNR=EbN0 + (10*log10(k));

% Generation of Data
x1= randi([0,1],n_sym*n_sc,1);

% Modulation
x11= bi2de (reshape(x1,k,length(x1)/k).','left-msb');
x2= modulate(mod,x11);

% Serial-to-Parallel

x3=reshape(x2,n_sc,length(x2)/n_sc).';
% IFFT
x4=ifft(x3,n_sc,2);
%cyclic prefix
x5=[x4(:,end-n_cp+1:end) , x4];

% Add Noise
for i=1:length(EbN0)
    % AWGN
    y5=awgn(x5,SNR(i),'measured');
    % Remove Cyclic Prefix
    y4=y5(:,n_cp+1:end);
    %FFT
    y3=fft(y4,n_sc,2);
    % Parallel-to-serial
    y2=reshape(y3.',length(y3),1);
    %Demodulation
    y11=demodulate(demod,y2);
    y12=de2bi(y11,'left-msb');
    y1=reshape(y12.',length(y12),1);
    %BER counter
    BER(i)=sum(x1~=y1)/length(x1);
end
% Plot
%BER_th=

