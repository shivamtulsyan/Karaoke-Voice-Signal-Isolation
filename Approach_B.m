clear

input_signal_name = input('Specify the name of input music signal (along with extension) - \n', 's');
if isempty(input_signal_name)
    input_signal_name = 'Source_B/base_melody_looped.wav';
end
[input_signal, fs1] = audioread(input_signal_name);

rec_signal_name = input('Specify the name of recorded signal (along with extension) - \n', 's');
if isempty(rec_signal_name)
    rec_signal_name = 'Source_B/recording.wav';
end
[rec, fs2] = audioread(rec_signal_name);

if fs1~=fs2
    disp('ERROR : Sampling Frequency of both signals are not same');
    return;
else
    fs = fs1;
end

len = 5*fs; %separating out the starting part with no intereference

[c, lags] = xcorr(rec(1:len), input_signal, len);%cross-correlating it with base input signal

[M, I] = max(c);
I = abs(lags(I));%finding out the time lag

sub = zeros([I 1]);

input_signal = [sub ; input_signal];

ratio = max(rec(1:5*fs))/max(input_signal(1:5*fs));
if length(rec)>length(input_signal)
    input_signal = [input_signal ; zeros([length(rec)-length(input_signal) 1])];
else
    input_signal = input_signal(1:size(rec));
end

final = rec-ratio.*input_signal;

output_signal_name = input('Specify the name of output you would like (along with extension)- \n', 's');
while isempty(output_signal_name)
   output_signal_name = input('Please Specify the name of output you would like (along with extension)- \n', 's');
end 
audiowrite(output_signal_name, final, fs);

tiledlayout(2,2);
nexttile;
plot(input_signal);
title('Input Music Signal');

nexttile;
plot(lags, c);
title('Cross-Correlation Output');

nexttile;
plot(rec);
title('Recorded Mixture');

nexttile;
plot(final);
title('Output Signal From this Approach');