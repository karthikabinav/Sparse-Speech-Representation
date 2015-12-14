function y = SynthesisDCT(M, V, h, o)
%M: window length
%V: DCT spectrogram
%h: window type
%o: overlap parameter
    W = size(V, 2); %length of the signal
    y((W-1)*o + M) = 0; %initialize, W = L-M+1 => L = W+M-1

    for i = 1:o:(W-1)*o
        y(i:i+(M-1)) = (idct(V(:, (i-1)/o + 1))./h')';
    end

end

