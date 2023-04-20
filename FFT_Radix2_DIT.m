%% Name :-  Ahmed Ismail El Hoofy    

%% -------------------------------------------- EE-488(Communication senior Design Class)----------------------------
%% This function computes the FFT algorithm with Decimation in Time (DIT)

function [ y ] = FFT_Radix2_DIT( x )     
p=nextpow2(length(x));                   % checking the size of the input array
x=[x zeros(1,(2^p)-length(x))];          % complementing an array of zeros if necessary
N=length(x);                             % computing the array size
S=log2(N);                               % computing the number of conversion stages
Half=1;                               
x=bitrevorder(x);                     
for stage=1:S                         
    for index=0:(2^stage):(N-1)         % series of "butterflies" for each stage
        for n=0:(Half-1)                % creating "butterfly" and saving the results
            pos=n+index+1;               % index of the data sample
            pow=(2^(S-stage))*n;      
            w=exp((-1i)*(2*pi)*pow/N);   % complex multiplier
            a=x(pos)+x(pos+Half).*w;     % 1-st part of the "butterfly" creating operation
            b=x(pos)-x(pos+Half).*w;     % 2-nd part of the "butterfly" creating operation
            x(pos)=a;                    % saving computation of the 1-st part
            x(pos+Half)=b;               % saving computation of the 2-nd part
        end
    end
Half=2*Half;                             % computing the next "Half" value
end
y=x;                                     % returning the result from function
end