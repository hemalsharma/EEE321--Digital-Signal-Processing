close all;
clear all;
%% Load ECG data
load('ECG_Clean.mat')
load('ECG_Raw.mat')
Fs = 300;
dt = 1/Fs;
t = (0:dt:(length(ECG_Raw)*dt)-dt)';

%% Filter
% Define the notch filter frequencies
fc1 = 49; % Lower notch frequency
fc2 = 51; % Upper notch frequency

% Design Butterworth notch filter
[b_notch, a_notch] = butter(3, [fc1 fc2]/(Fs/2), 'stop');

% Apply Butterworth notch filter to remove 50 Hz noise
ECG_Raw_notch_removed = filtfilt(b_notch, a_notch, ECG_Raw);

% Design Butterworth low-pass filter
fc_lp = 60; % Cutoff frequency for low-pass filter
[b_lp, a_lp] = butter(3, fc_lp/(Fs/2), 'low');

% Apply Butterworth low-pass filter
filtered = filtfilt(b_lp, a_lp, ECG_Raw_notch_removed);
%% PSD
PSD_r= pwelch(ECG_Raw);
PSD_c= pwelch(ECG_Clean);
PSD= pwelch(filtered);
%% Plots
% Time Doamin Plot
figure(1)
subplot(3,1,1)
plot(t,ECG_Raw)
xlabel('Time(Sec)');
ylabel('Amplitude');
title('Noisy ECG Signal');
subplot(3,1,2)
plot(t,ECG_Clean)
xlabel('Time(Sec)');
ylabel('Amplitude');
title('Clean ECG Signal');
subplot(3,1,3)
plot(t,filtered);
xlabel('Time(Sec)');
ylabel('Amplitude');
title('Filtered ECG Signal');
% Low pass filter response in magnitude and phase
figure(2)
freqz(b_lp,a_lp)
% plot PSD
figure (3);
subplot(3,1,1); plot(PSD_r); title('PSD of Noisy ECG');
subplot(3,1,2); plot(PSD_c); title('PSD of clean ECG');
subplot(3,1,3); plot(PSD); title('PSD of filtered ECG');
%% Perfomance calculation
msc= mean(mscohere(filtered,ECG_Clean));
corr= det(corrcoef(filtered,ECG_Clean));
before= rmse(ECG_Clean,ECG_Raw);
after= rmse(ECG_Clean,filtered);
r = snr(ECG_Raw,filtered);