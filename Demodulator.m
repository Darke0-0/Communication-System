function decisions = Demodulator(received,M,gre)
    decisions=zeros(length(received),1);

    if M == 2
        % BPSK constellation
        a=[zeros(1,1);ones(1,1)];
        constellation = exp(1i*2*pi.*a/2);

    else
        % Vector of Points
        alphaRe = [-(sqrt(M)-1):2:-1 1:2:sqrt(M)-1];
        alphaIm = j*[-(sqrt(M)-1):2:-1 1:2:sqrt(M)-1];
        amp = 0;
        for i=1:log2(M)
            amp = amp + alphaRe(i)^2;
        end
        amp = 2*amp/log2(M);
        % 16 QAM/QPSK constellation
        constellation = reshape(bsxfun(@plus,alphaRe,alphaIm'),1,[]);
        constellation = constellation(gre);
        constellation = constellation/sqrt(amp);
    end

    %Symbol for loop
    for n=1:length(received)
        % Distance from each of the constellation points
        distances = abs(received(n)-constellation);
        % Minimum of those distances
        [~,decisions(n)] = min(distances); 
    end
    %Maps back non gray to gray
    decisions= decisions - 1 ;
end