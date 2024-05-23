%Hemal Sharma
%ID: 2221855

% Import audio file
[y, Fs] = audioread("corrupted.m4a");     % 'y' contains the audio samples, 'Fs' is the sample rate

% Plot the waveform
subplot(2, 1, 1);
plot(y);
xlabel('Time (s)');
ylabel('Amplitude');
title('Noisy Signal');

% Compute and plot the frequency spectrum
N = length(y);                      % Length of the signal
Y = fft(y);                         % Compute the FFT
f = (0:N-1)*(Fs/N);                 % Frequency vector
subplot(2, 1, 2);
plot(f, abs(Y));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Noisy Signal in Frequency Domain');
xlim([0 Fs/2]);                     % Display only positive frequencies