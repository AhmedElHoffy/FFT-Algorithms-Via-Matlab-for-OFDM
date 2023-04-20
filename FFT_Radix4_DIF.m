%% Name :-  Ahmed Ismail El Hoofy    

%% -------------------------------------------- EE-488(Communication senior Design Class)----------------------------
%% % This is a radix-4 FFT, using decimation in frequency (DIF)

function S = FFT_Radix4_DIF(s)
    N = length(s);
    M = log2(N)/2;
    %% Initialize variables 
    W=exp(-j*2*pi*(0:N-1)/N);
    S = complex(zeros(1,N));
    Temp = complex(zeros(1,N));
    %% FFT algorithm
    Temp = s;
    for stage = 0:M-2  % Calculate butterflies for first M-1 stages
        for n=1:N/4
            S((1:4)+(n-1)*4) = radix4bfly(Temp(n:N/4:end), floor((n-1)/(4^stage)) *(4^stage), 1, W);
        end
        Temp = S;
    end
    for n=1:N/4 % Calculate butterflies for last stage
        S((1:4)+(n-1)*4) = radix4bfly(Temp(n:N/4:end), floor((n-1)./(4^stage)) .* (4^stage), 0, W);
    end
    Temp = S;
    S = S*N;    % Rescale the final output
   
end




%% For the last stage of a radix-4 FFT all the ABCD multiplers are 1. 

function Z = radix4bfly(x,segment,stageFlag,W)     
         
    % stageFlag = 0 indicates last FFT stage, set to 1 otherwise
   
    a=x(1)*.25;b=x(2)*.25;c=x(3)*.25;d=x(4)*.25;  % Initialize variables and scale to 1/4

    %% Radix-4 Algorithm
    A=a+b+c+d;
    B=(a-b+c-d)*W(2*segment*stageFlag + 1);
    C=(a-b*1i-c+d*1i)*W(segment*stageFlag + 1);  % Use the stageFlag variable to indicate the last stage  
    D=(a+b*1i-c-d*1i)*W(3*segment*stageFlag + 1);
    
    Z = [A B C D];

end


