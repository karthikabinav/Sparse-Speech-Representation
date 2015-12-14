clc; clear; close all;

y = audioread('$audiopath$');
y = y';
M = 320;
h = ones(1, M);
o = 320;
Fs = 16000;
U = AnalysisDCT(y, M, h, o);
dict = $dict_path$;
U_hat = zeros(size(U));

error = zeros(1,size(U,2));
for i = 1:size(U,2)
    x = OMP(dict, U(:,i), 160);
    U_hat(:,i) = dict*x;
    error(i) = norm(U(:,i)-U_hat(:,i),2);
end
avgError = mean(error)
figure; imagesc(20*log10(abs(U)));
title('original spectrogram');
figure; imagesc(20*log10(abs(U_hat)));
title('estimated spectrogram');
%see if they look similar.

y_hat = SynthesisDCT(M, U_hat, h, o); %to get back speech
y_hat = real(y_hat(1:size(y,2)));

audiowrite('OMP/example/in.wav', y, Fs);
audiowrite('OMP/example/out.wav', y_hat, Fs);
figure; plot(y);
title('original signal');
figure; plot(y_hat);
title('estimated signal');
%listen to both, see how good they are.
error = sum(sum((y-y_hat).^2))
SNR = compSNR(y, y_hat)