% A simple code to illustrate the operation of an OFDM transmitter and Receiver including 
% RF upconversion and down-conversion ; 
% References: IEEE802.11 standards, Simulation of Digital communication
% systems with MATLAB by Mathuranathan Viswanathan


clc; 


%--------------------------------------------- 
%--------OFDM Parameters, an example of MCS0 of WLAN standard for a 20MHz wide channel --- 
%Modulation scheme used is BPSK

N = 64; %FFT size or total number of subcarriers (used + unused) 64 
N_s_data = 48; %Number of data subcarriers  
N_s_pilots = 4 ; %Number of pilot subcarriers  
ofdmBW = 20 * 10 ^ 6 ; % OFDM bandwidth 

%--------Derived Parameters-------------------- 
deltaF = ofdmBW/ N; %= 20 MHz/ 64 = 0.3125 MHz 
Tfft = 1/ deltaF; % IFFT/ FFT period = 3.2us 
Tgi = Tfft/ 4;% Guard interval duration and also the duration of cyclic prefix

Tsignal = Tgi + Tfft; %duration of BPSK-OFDM symbol 
Ncp = N* Tgi/ Tfft; %Number of symbols allocated to cyclic prefix 
Nst = N_s_data + N_s_pilots; %Number of total used subcarriers 
nBitsPerSym = Nst; %For BPSK the number of Bits per Symbol is same as num of subcarriers 

%-----------------Transmitter-------------------- 

s = 2*randi([0 1], 1, Nst)-1; %Generating Random Data with BPSK modulation 

% The number of bits being generated is limited to the total number of
% used sub-carriers. There could be more number of bits generated and the
% bits be re-arranged in a number of rows and columns equal to 'Nst' as
% in the commented code below
%data=randi([0 1], numbits, 1);  % Generate vector of of length 'numbits'
% s= [];
%for 0=0:Nst:numbits
%s1 = [data(i+1:(i+(Nst))]
% s = [ s; s1]

%IFFT block 
%Assigning subcarriers from 1 to 26 (mapped to 1-26 of IFFT input) 
%and -26 to -1 (mapped to 38 to 63 of IFFT input); 
%Nulls from 27 to 37 and at 0 position 
X_Freq =[ zeros( 1,1) s( 1: Nst/ 2) zeros( 1,11) s( Nst/ 2 + 1: end)]; 
% Assuming that the data is in frequency domain and converting to time domain 
% and scaling the amplitude appropriately
x_Time = N/ sqrt( Nst)* ifft( X_Freq); 

%Adding Cyclic Prefix 
ofdm_signal =[ x_Time( N-Ncp + 1: N) x_Time]; %Generation of the OFDM baseband signal complete


   
%%----------------------Up-conversion to RF----------------------------
Tsym = Tsignal/(N+Ncp); % duration of each symbol on the OFDM signal
t=Tsym/50:Tsym/50:Tsym; % define a time vector
%fc = 10*ofdmBW; % set the carrier frequency at 10 times the bandwidth of the OFDM channel
fc = 2.412 * 10 ^ 9; % set the carrier frequency at a WLAN cchannel's centre frequency

Carr_real=[];
Carr_imag=[];
Carr = [];
for n=1:length(ofdm_signal)
    Carr_real = real(ofdm_signal(n))*cos(2*pi*fc*t); %modulate the real part on a cosine carrier
    Carr_imag = imag(ofdm_signal(n))*sin(2*pi*fc*t); %modulate the imaginary part on a sine carrier
 %   Carr_real=[Carr_real Carr_real];
 %   Carr_imag=[Carr_imag Carr_imag];
    Carr = [Carr Carr_real+Carr_imag];
end

%% Addition of quantization noise. 
%The OFDM modulation operation is done in a Digital Signal processor in
%most cases whose digital output needs to be converted to analogue domain
%using a digital to analogue converter (DAC). The output of a DAC is
%quantized to discrete levels depending on the reference voltage and bit
%resolution of the DAC. This is generally done before up conversion and
%with individual DACs for the real and imaginary parts of the baseband
%signal. The quantization has been added after up-conversion in this code
%to avoid complexity of having two individual quantization codes for the
%real and imaginary parts of the base band. In either case, the output of
%the up-converter will have amplitudes at discrete staps depending on the
%quantization levels.

n1 = 10; % Number of bits of the ADC/DAC
max1= (2^n1)-1; %maximum n1 bit value
m=length(Carr);

Ac = max(abs(Carr));%Carrier amplitude of 1V
%conversion of the signal ybb to n1 bits digital values quantized to the
%nearest integer value
Vref = Ac*2; % Reference voltage of the converter
conv_fact1 = max1/Vref; %conversion scale for the analogue samples to convert to 16 bits
resolution = Vref/max1;
z1 = [];
for q=1:1:m
    z1(q)=(Carr(q)+Ac)*conv_fact1; %generating 'n1' bit digital representation 
                                          %of each sample of the carrier  
end

x1 = nearest(z1); % Each value is quantized to its nearest n1 bit number

y_tx = [];
for q=1:1:m
    y_tx(q) = ((x1(q)*Vref/max1)-Ac); %generating the analogue equivalent voltage of 
                                       %each 'n1' bit sample 
    qerr1(q) = Carr(q)-y_tx(q);
    
end


%--------------Channel Modeling ----------------
% AWGN and other channel impairments could be added here. AWGN is added for
% inllustrative purpose. Further impairments such as doppler effect,
% Rayleigh fading may be added.

snr = 1;
rx_carr = awgn(y_tx,snr, 'measured');
%%-----------------Receiver---------------------- 

%I-Q or vector down-conversion to recover the OFDM baseband signal from the
%modulated RF carrier
r = [];
r_real= [];
r_imag = [];
for n=1:1:length(ofdm_signal)

    %%XXXXXX inphase coherent dector XXXXXXX
    Z_in=rx_carr((n-1)*length(t)+1:n*length(t)).*cos(2*pi*fc*t); %extract a period of the 
    %signal received and multiply the received signal with the cosine component of the carrier signal
    
    Z_in_intg=(trapz(t,Z_in))*(2/Tsym);% integration using Trapizodial rule 
                                    %over a period of half bit duration
    r_real=Z_in_intg;
    
    %%XXXXXX Quadrature coherent dector XXXXXX
    Z_qd=rx_carr((n-1)*length(t)+1:n*length(t)).*sin(2*pi*fc*t);
    %above line indicat multiplication ofreceived & Quadphase carred signal
    
    Z_qd_intg=(trapz(t,Z_qd))*(2/Tsym);%integration using trapizodial rull
        
    r_imag =  Z_qd_intg;   
        
        r=[r  r_real+1i*(r_imag)]; % Received Data vector
end



%Removing cyclic prefix 
r_Parallel = r( Ncp + 1:( N + Ncp)); 
%FFT Block 
r_Time = sqrt( Nst)/ N*( fft( r_Parallel)); 
%Extracting the data carriers from the FFT output 
R_Freq = r_Time([( 2: Nst/ 2 + 1) (Nst/ 2 + 13: Nst + 12)]);

%BPSK demodulation / Constellation Demapper.Force + ve value --> 1, -ve value --> -1 
R_Freq( R_Freq > 0) = + 1; 
R_Freq( R_Freq < 0) = -1; 
s_cap = R_Freq; 
numErrors = sum( abs( s_cap-s)/ 2); %Count number of errors 

R_Freq( R_Freq < 0) = 0
s(s < 0) = 0;
[numErrors, ber] = biterr(s, R_Freq);
fprintf('\nThe bit error rate = %5.2e, based on %d errors\n', ...
    ber, numErrors)








