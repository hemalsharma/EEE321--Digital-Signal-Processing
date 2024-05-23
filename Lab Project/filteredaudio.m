%% Reset
clc;
close all;
clear;
%Hemal Sharma
%ID: 2221855

%% Read and play noiseless audio
[noiseless, sample_rate] = audioread('expected.m4a');
sound(noiseless, sample_rate); %plays sound

%% Read and play noisy audio
[noisy_data, sample_rate] = audioread('corrupted.m4a');
sound(noisy_data, sample_rate); %plays sound

%% Compare noisy and noiseless data
subplot(3,1,1);
plot(noiseless);            % Original Signal
title('Original Signal');
xlabel('Time (s)'); ylabel ('Amplitude');

subplot(3,1,2);
plot(noisy_data);           % Noisy output
title('Noisy Signal');
xlabel('Time (s)'); ylabel ('Amplitude');

%% Apply filter 1
my_filter1 = filter1; % filter1 is a bandstop filter to remove the 1000Hz noise
filtered_data1 = filter(my_filter1, noisy_data);

%% Play filtered audio 1
sound(filtered_data1, sample_rate); %plays sound

%% Apply filter 2
my_filter2 = filter2; % filter2 is the bandstop filter to remove the 2000Hz noise
filtered_data2 = filter(my_filter2, filtered_data1); % Apply filter 2 to the output of filter 1

%% Play filtered audio 2
sound(filtered_data2, sample_rate); %plays sound

%% Apply filter 3
my_filter3 = filter3; % filter3 is a FIR bandpass filter
filtered_data3 = filter(my_filter3, filtered_data2); % Apply filter 3 to the output of filter 2

%% Plot filtered signal 3
subplot(3,1,3);
plot(filtered_data3);           % Filtered output 3
title('Filtered Signal');
xlabel('Time (s)'); ylabel ('Amplitude');

%% Play filtered audio 3
sound(filtered_data3, sample_rate); %plays sound
