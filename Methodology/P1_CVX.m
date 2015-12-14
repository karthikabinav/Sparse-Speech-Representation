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
XX = [];
for i = 1:size(U,2)
    i
    %insert code here to get sparse 'x' which solves U(:,i) = dict*x
    z = U(:,i);
    cvx_begin quiet
        variable x(80,39)
        minimize sum(norms(x))
        subject to
             norm(z-dict*(reshape(x,[],1)),2) <= 0.1;
    cvx_end
    x = x(:);
    U_hat(:,i) = dict*x;
    error(i) = norm(U(:,i)-U_hat(:,i),2);
    XX =[XX,x];
end

avgError = mean(error);

figure; imagesc(20*log10(abs(U)));
figure; imagesc(20*log10(abs(U_hat)));
%see if they look similar.

y_hat = SynthesisDCT(M, U_hat, h, o); %to get back speech
y_hat = real(y_hat(1:size(y,2)));

audiowrite('in.wav', y, Fs);
audiowrite('out.wav', y_hat, Fs);
%listen to both, see how good they are.
error = sum(sum((y-y_hat).^2))