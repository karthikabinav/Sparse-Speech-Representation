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
sparsity = zeros(1,size(U,2));
for i = 1:size(U,2)
    %insert code here to get sparse 'x' which solves U(:,i) = dict*x
    A = dict;
    b = U(:,i);
    lambda_max = norm(A'*b,'inf');
    lambda = 0.05*lambda_max;
    [x, history] = lasso_admm(A, b, lambda, 1.0, 1.0);
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

audiowrite('ADMMLasso/example/in.wav', y, Fs);
audiowrite('ADMMLasso/example/out.wav', y_hat, Fs);
figure; plot(y);
title('original signal');
figure; plot(y_hat);
title('estimated signal');
%listen to both, see how good they are.
error = sum(sum((y-y_hat).^2))
SNR = compSNR(y, y_hat)