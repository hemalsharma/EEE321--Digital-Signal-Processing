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
% Define range of filter orders to test
order_range = 1:20; % For example, from 1 to 20

% Initialize arrays to store performance metrics
msc_values = zeros(size(order_range));
corr_values = zeros(size(order_range));
before_values = zeros(size(order_range));
after_values = zeros(size(order_range));
snr_values = zeros(size(order_range));

% Loop through each filter order
for i = 1:length(order_range)
    % Design Butterworth low-pass filter with current order
    [b_lp, a_lp] = butter(order_range(i), fc_lp/(Fs/2), 'low');

    % Apply Butterworth low-pass filter
    filtered = filtfilt(b_lp, a_lp, ECG_Raw_notch_removed);

    % Calculate performance metrics
    msc_values(i) = mean(mscohere(filtered, ECG_Clean));
    corr_coef_matrix = corrcoef(filtered, ECG_Clean);
    corr_values(i) = corr_coef_matrix(1, 2);
    before_values(i) = rmse(ECG_Clean, ECG_Raw);
    after_values(i) = rmse(ECG_Clean, filtered);
    signal_power = rms(ECG_Clean)^2;
    noise_power = rms(ECG_Raw - filtered)^2;
    snr_values(i) = 20 * log10(signal_power / noise_power);
end

% Create a table for filter performance vs. filter order
performance_vs_order_table = table(order_range', msc_values', corr_values', ...
    before_values', after_values', snr_values', ...
    'VariableNames', {'Filter_Order', 'Mean_Squared_Coherence', ...
    'Correlation_Coefficient', 'RMSE_Before_Filtering', ...
    'RMSE_After_Filtering', 'SNR_dB'});

% Display the table
disp('Filter Performance vs. Filter Order:');
disp(performance_vs_order_table);
