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
s = 2; %sparsity
for i = 1:size(dict,2)
    group(i) = ceil(i/50);
end

error = zeros(1,size(U,2));
sparsity = zeros(1,size(U,2));
for i = 1:size(U,2)
    [x, r] = BlockOMP(dict, U(:,i), group, s);
    sparsity(i) = nnz(x); %number of non zero elements in x   
    U_hat(:,i) = dict*x;
    error(i) = norm(U(:,i)-U_hat(:,i),2);
end
avgError = mean(error)
avgSparsity = mean(sparsity)
figure; imagesc(20*log10(abs(U)));
title('original spectrogram');
figure; imagesc(20*log10(abs(U_hat)));
title('estimated spectrogram');
%see if they look similar.

y_hat = SynthesisDCT(M, U_hat, h, o); %to get back speech
y_hat = real(y_hat(1:size(y,2)));

audiowrite('BlockOMP/example/in.wav', y, Fs);
audiowrite('BlockOMP/example/out.wav', y_hat, Fs);
figure; plot(y);
title('original signal');
figure; plot(y_hat);
title('estimated signal');
%listen to both, see how good they are.
error = sum(sum((y-y_hat).^2))
SNR = compSNR(y, y_hat)