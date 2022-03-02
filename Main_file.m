clear
close all
clc

% Type 
% 1 = BPSK
% 2 = QPSK
% 4 = 16 QAM

modtype = 2;
% Symbols
symbols = 100000;
% No of type of bits
M = 2^modtype;
% Gray Map
%gre = (1:M);
gre = [1 2 4 3];
%gre = [12 11 15 16 10 9 13 14 4 3 7 8 2 1 5 6];

% Signal to Noise Ratio
snr = 0:0.1:10;
range_snr = range(snr);
len_snr = length(snr);

%Generating nsymbols random 2 bit symbols to use for BPSK
bits=zeros(symbols,1);
% To estimate error for each SNR value and add it to estimate
perr_estimate = zeros(len_snr,1);
% To estimate error for each SNR value and add it to estimate
sym_error = zeros(len_snr,1);

% Generating bits
for k=1:symbols
    bits(k)= randi([0,(M-1)]);
end

% Modulation
mod = Modulator(bits,M,gre);
eb_NO = zeros(len_snr,1);

for k=1:len_snr
    snr_now = snr(k); 
    % db to decimal
    
    snr_lin = 10^(snr_now/10);
    
    % Variance
    sigma=sqrt(1/(2*snr_lin));

    % Adding 2d Gaussian noise to symbols.
    received = mod + sigma*(randn(symbols,1)+1i*randn(symbols,1));
    
    % Demodulator
    decisions = Demodulator(symbols,received,M,gre);

    sym_error(k) = mean(decisions~=bits);
    num_gray=zeros(symbols,1);
    
    %For gray encoded
    for n=1:symbols
        d_bin=dec2bin(decisions(n),modtype);
        i_bin=dec2bin(bits(n),modtype);  
        biterror=0;
        for t=1:modtype
            if d_bin ~= i_bin(t)
                biterror=biterror+1;
            end
            num_gray(n)=biterror;
        end
    end
    errors_gray = num_gray; 
    perr_estimate(k) = sum(num_gray)/(symbols);
end
ber_error = sym_error/4;

% Plot the BER per symbols with SNR.
semilogy(snr,sym_error);
hold on;
% Plot the BER theoretical using Q-function.
semilogy(snr,ber_error);
semilogy(snr,perr_estimate);
semilogy(snr,3*qfunc(sqrt(0.2*10.^(snr/10))));
semilogy(snr,0.75*qfunc(sqrt(0.2*10.^(snr/10))));
legend("Experimental SER ","Experimental BER ","Theoretical using Q function(SER)","Theoretical using Q function(BER)"); 
xlabel("SNR (dB)");
ylabel("SER (Symbol Error Rate)");