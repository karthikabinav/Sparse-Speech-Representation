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

A = dict; 
block_size = ;
num_phonemes = ;
g = block_size*ones(num_phonemes);

error = zeros(1,size(U,2));
for i = 1:size(U,2)
    A = dict;
    b = U(:,i);
    %ADMM
    lambda_max = norm(A'*b,'inf');
    lambda = 1;
    [s, history] = group_lasso(A, b, lambda, g, 1.0, 1.0);
    %End ADMM
    cum_part = cumsum(g);
    zsum = g;
    start_ind = 1;
    for l = 1:num_phonemes
        sel = start_ind:cum_part(l);
        zsum(l) = sum(abs(s(sel)));
        start_ind = cum_part(l) + 1;
    end
     [~, index] = max(zsum);
    zsum(index) = -Inf;       
    [~, index2] = max(zsum);
    if index==1
        start_i = 1;
    else start_i = cum_part(index-1)+1;
    end
    end_i = cum_part(index);

    if index2==1
        start_i2 = 1;
    else start_i2 = cum_part(index2-1)+1;
    end
    end_i2 = cum_part(index2);

    xt = zeros(size(s));
    %xt([start_i:end_i,start_i2:end_i2]) = x([start_i:end_i,start_i2:end_i2]);
    D = A(:,[start_i:end_i,start_i2:end_i2]);
    xt([start_i:end_i,start_i2:end_i2]) = D\b;
    s = xt;
    U_hat(:,i) = dict*s;
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

audiowrite('New/example/in.wav', y, Fs);
audiowrite('New/example/out.wav', y_hat, Fs);
figure; plot(y);
title('original signal');
figure; plot(y_hat);
title('estimated signal');
%listen to both, see how good they are.
error = sum(sum((y-y_hat).^2))
SNR = compSNR(y, y_hat)