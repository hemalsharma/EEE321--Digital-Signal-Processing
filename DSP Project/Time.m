clear all; close all; clc;
load('ECG_Raw.mat');
load('ECG_Clean.mat');
Fs = 300; %sampling frequency
Ts= 1/Fs; %sampling time
t = (0:Ts:(length(ECG_Raw)*Ts)-Ts); %time domain in Ts intervals

%plotting the given signals in time domain
figure(1)
subplot(2,1,1)
plot(t,ECG_Raw)
title('ECG Raw signal');
ylabel('Amplitude');
xlabel('Time(s)');
subplot(2,1,2)
plot(t,ECG_Clean)
title('ECG Clean signal');
ylabel('Amplitude');
xlabel('Time(s)');

%plotting the given signals in frequency domain
raw_fft = abs(fft(ECG_Raw));
clean_fft = abs(fft(ECG_Clean));
f = (0:length(ECG_Raw)-1) * Fs / length(ECG_Raw);
% Plot frequency analysis
figure(2);
subplot(2,1,1);
plot(f, raw_fft);
title('Frequency Analysis of Raw ECG Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

subplot(2,1,2);
plot(f, clean_fft);
title('Frequency Analysis of Clean ECG Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');