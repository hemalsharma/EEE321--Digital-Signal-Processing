function [performance_table] = filter_performance_iir(filter_type, order)
    % Load ECG data
    load('ECG_Clean.mat')
    load('ECG_Raw.mat')
    Fs = 300;
    dt = 1/Fs;
    t = (0:dt:(length(ECG_Raw)*dt)-dt)';

    % Define the notch filter frequencies
    fc1 = 49; % Lower notch frequency
    fc2 = 51; % Upper notch frequency

    % Design appropriate IIR filter based on type
    if strcmpi(filter_type, 'Butterworth')
        % Design Butterworth IIR filter
        [b_lp, a_lp] = butter(order, fc_lp/(Fs/2), 'low');
    elseif strcmpi(filter_type, 'Chebyshev')
        % Design Chebyshev Type I IIR filter
        [b_lp, a_lp] = cheby1(order, 0.5, fc_lp/(Fs/2), 'low');
    elseif strcmpi(filter_type, 'Elliptic')
        % Design Elliptic IIR filter
        [b_lp, a_lp] = ellip(order, 0.5, 40, fc_lp/(Fs/2), 'low');
    else
        error('Invalid filter type. Please specify Butterworth, Chebyshev, or Elliptic.');
    end

    % Apply notch filter to remove 50 Hz noise
    ECG_Raw_notch_removed = filtfilt(b_notch, a_notch, ECG_Raw);

    % Apply low-pass filter
    filtered = filtfilt(b_lp, a_lp, ECG_Raw_notch_removed);

    % Calculate performance metrics
    msc = mean(mscohere(filtered, ECG_Clean));
    corr_coef_matrix = corrcoef(filtered, ECG_Clean);
    corr_coef = corr_coef_matrix(1, 2);
    before_rmse = rmse(ECG_Clean, ECG_Raw);
    after_rmse = rmse(ECG_Clean, filtered);
    signal_power = rms(ECG_Clean)^2;
    noise_power = rms(ECG_Raw - filtered)^2;
    snr = 20 * log10(signal_power / noise_power);

    % Create performance table
    performance_table = table(filter_type, order, msc, corr_coef, ...
        before_rmse, after_rmse, snr, ...
        'VariableNames', {'Filter_Type', 'Filter_Order', ...
        'Mean_Squared_Coherence', 'Correlation_Coefficient', ...
        'RMSE_Before_Filtering', 'RMSE_After_Filtering', 'SNR_dB'});

    % Display results
    disp(performance_table);

    % Plot filtered signal
    figure;
    subplot(2,1,1);
    plot(t, ECG_Clean, 'b', t, filtered, 'r');
    xlabel('Time (s)');
    ylabel('Amplitude');
    title('Filtered ECG Signal');
    legend('Clean ECG', 'Filtered ECG');

    % Plot frequency response
    subplot(2,1,2);
    freqz(b_lp, a_lp);
    title('Frequency Response of Filter');
end
