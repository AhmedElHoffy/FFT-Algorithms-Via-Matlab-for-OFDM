function [binn]=audio2bin(AudioFile)
% Read the File
FID=fopen(AudioFile,'rb');
    if FID <0
         
        % error message 
         msgbox(['Cannot Read file :',AUidoFile],'File Error','Error');
    end
    
    Data=fread(FID,Inf,'*uint8');
    Data2=Data(:);
    bin=dec2bin(Data2,8);
    binn=bin(:);
    fclose(FID);
end