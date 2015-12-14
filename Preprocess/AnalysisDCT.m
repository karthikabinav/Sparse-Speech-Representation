function U = AnalysisDCT(x, M, h, o)
%x: input speech signal
%M: window length
%h: window type
%o: overlap parameter
    L = size(x, 2); %length of the signal
    U(M, floor((L-1)/o) + 1) = 0; %initialize for given 'o'
    x = [x zeros(1, M - (L - floor((L-1)/o)*o))]; %pad zeros for given 'M' and 'o'
    for i = 1:o:L
        U(:, (i-1)/o + 1) = dct((x(i:i+(M-1)).*h)');
    end
end

