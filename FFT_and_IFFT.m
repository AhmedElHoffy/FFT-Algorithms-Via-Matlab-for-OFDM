%------------------------------------------- IFFT ------------------------------------
IFFT_optemp=ifft(Parallel_Data);
IFFT_op=ifftshift(IFFT_optemp);


%----------------------------------------- FFT --------------------------

FFT_optemp=fft(startOfSignal);
FFT_op=fftshift(FFT_optemp);