clear

input_signal_name = input('Specify the name of input music signal, i.e., single cycle of stationary signal (along with extension) - \n', 's');
if isempty(input_signal_name)
    input_signal_name = 'Source_C/base_melody.wav';
end
[base, fs1] = audioread(input_signal_name);

rec_signal_name = input('Specify the name of recorded signal (along with extension) - \n', 's');
if isempty(rec_signal_name)
    rec_signal_name = 'Source_C/recording.wav';
end
[rec, fs2] = audioread(rec_signal_name);

if fs1~=fs2
    disp('ERROR : Sampling Frequency of both signals are not same');
    return;
else
    fs = fs1;
end

len = length(base)+2*fs; %separating out the starting part with no intereference

[c, lags] = xcorr(rec(1:len), base);%cross-correlating it with base input signal

[M, I] = max(c);
I = abs(lags(I));%finding out the time lag

sub = zeros([I 1]);

TEMP = rec(I+1:I+length(base));

sub = [sub;TEMP];
while(length(sub)<length(rec))
    sub = [sub; TEMP];
end
sub = sub(1:length(rec));
final = rec-sub;
output_signal_name = input('Specify the name of output you would like (along with extension)- \n', 's');
while isempty(output_signal_name)
   output_signal_name = input('Please Specify the name of output you would like (along with extension)- \n', 's');
end 
audiowrite(output_signal_name, final, fs);

tiledlayout(2,2);
nexttile;
plot(base);
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