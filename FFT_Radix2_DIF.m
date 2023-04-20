%% Name :-  Ahmed Ismail El Hoofy    

%% -------------------------------------------- EE-488(Communication senior Design Class)----------------------------
%% This function computes the FFT algorithm with Decimation in Frequency (DIF)
function [ y ] = FFT_Radix2_DIF( X )                                             
p=nextpow2(length(X));          %checking the size of the input array 
X=[X zeros(1,(2^p)-length(X))]; % adding  zeros to the array if necessary                                        
N=length(X);                    % computing the array size                                           
number=log2(N);                 % computing the number of conversion stages                                                
mid=N/2;                        % half the length of the array                                         
for stage=1:number                                                              
    for i=0:(N/(2^(stage-1))):(N-1)    % Butterflies for each stage                               
        for j=0:(mid-1)                %creating "butterfly" and saving the results                                  
            pos=j+i+1;                 %index of the data sample                               
            pow=(2^(stage-1))*j;                                           
            w=exp((-1i)*(2*pi)*pow/N); % complex multiplier                                    
            a=X(pos)+X(pos+mid);       % 1-st part of the "butterfly" creating operation                                   
            b=(X(pos)-X(pos+mid)).*w;  % 2-nd part of the "butterfly" creating operation                               
            X(pos)=a;                  % saving computation of the 1-st part                                     
            X(pos+mid)=b;              % saving computation of the 2-nd part                                    
        end
    end
mid=mid/2;                             % computing the next "Half" value                                   
end
y=bitrevorder(X);             % performing bit-reverse operation and returning the result from function                                     
end
