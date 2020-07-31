clear

test_signal_name = input('Specify the name of the test input signal here (along with extension) - \n', 's');
if isempty(test_signal_name)
    test_signal_name = 'Source_A/test_signal.mp3';
end
[original_test, fs1] = audioread(test_signal_name);
%specify the name of the test input signal here

recorded_test_signal_name = input('Specify the name of the test recorded signal here (along with extension) - \n', 's');
if isempty(recorded_test_signal_name)
    recorded_test_signal_name = 'Source_A/test_recorded.3gp';
end
[recorded_test, fs2] = audioread(recorded_test_signal_name);
%specify the name of the test recorded signal here

input_signal_name = input('Specify the name of input music signal (along with extension) - \n', 's');
if isempty(input_signal_name)
    input_signal_name = 'Source_A/base_melody_looped.mp3';
end
[input_signal, fs3] = audioread(input_signal_name);
%specify the name of input music signal

rec_signal_name = input('Specify the name of recorded signal (along with extension) - \n', 's');
if isempty(rec_signal_name)
    rec_signal_name = 'Source_A/recording.3gp';
end
[recorded, fs4] = audioread(rec_signal_name);
%specify the name of recorded signal

fs = fs1;       %fs1, fs2, fs3, fs4 all must be equal

if (fs~=fs2) || (fs~=fs3) || (fs~=fs4)
    disp('sampling frequency does not match of all the signals');
    return;
end

original_test = [original_test;zeros([length(recorded_test) - length(original_test) 1])];
%padding the signal to contain same number of elements

ftt_original = fft(original_test);
fft_recorded = fft(recorded_test);
TF = fft_recorded./ftt_original;
f_tf = ifft(TF);
f_tf = f_tf(1:2*fs);

convolution = dsp.Convolver('Method','Frequency Domain');

convoluted = convolution(input_signal, f_tf);
if length(recorded)>length(convoluted)
    convoluted = [convoluted ; zeros([length(recorded)-length(convoluted) 1])];
else
    convoluted = convoluted(1:size(recorded));
end
output = recorded - convoluted;

output_signal_name = input('Specify the name of output you would like (along with extension)- \n', 's');
while isempty(output_signal_name)
   output_signal_name = input('Please Specify the name of output you would like (along with extension)- \n', 's');
end 
audiowrite(output_signal_name, output, fs);

tiledlayout(2,3);
nexttile;
plot(original_test);
title('Input Test Signal');

nexttile;
plot(input_signal);
title('Input Music Signal');

nexttile;
plot(f_tf);
title('Impulse Response Calculated from test signals');

nexttile;
plot(recorded_test);
title('Recorded Test Signal');

nexttile;
plot(recorded);
title('Recorded Mixture');

nexttile;
plot(output);
title('Output Signal From this Approach');
