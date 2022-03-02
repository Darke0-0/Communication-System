function mod = Modulator(bits,M,gre)

    % Vector of Points
    alphaRe = [-(2*sqrt(M)/2-1):2:-1 1:2:2*sqrt(M)/2-1];
    alphaIm = 1i*[-(2*sqrt(M)/2-1):2:-1 1:2:2*sqrt(M)/2-1];
    amp = 0;
    for i=1:log2(M)
        amp = amp + alphaRe(i)^2;
    end
    amp = 2*amp/log2(M);

    if M == 2
        % BPSK constellation
        a=[zeros(1,1) ones(1,1)];
        constellation = exp(1i*2*pi.*a/2);

    else
        % 16-QAM/QPSK constellation
        constellation = reshape(bsxfun(@plus,alphaRe,alphaIm'),1,[]);
        constellation = constellation(gre);
        constellation = constellation/sqrt(amp);
    end
    % Constellation symbols
    mod = constellation(bits(:)+1);
    mod = mod.';
end