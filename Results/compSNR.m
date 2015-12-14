function value=snr(x,y)
%  SNR- Signal/Noise ratio

%%
    value=10*log10(sum(x(:).^2)/sum((x(:)-y(:)).^2));
end
