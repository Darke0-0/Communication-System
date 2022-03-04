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
% Repetitions
%rep_value = zeros(3,1);
%for number=1:3
%    rep_value(number) = 2*number-1;
%end
rep_value = [1 3 5];
int_value = [1 2 5];

bits=zeros(symbols,1);
% Generating bits
for k=1:symbols
    bits(k)= randi([0,(M-1)]);
end

% Gray Map
if modtype == 1
    gre = [1 2];
    fctr = 1;
    pts = 1;
    dst = 1;
elseif modtype == 2
    gre = [2 1 4 3];
    fctr = 2;
    pts = 2;
    dst = 1;
elseif modtype == 4
    gre = [12 11 15 16 10 9 13 14 4 3 7 8 2 1 5 6];
    fctr = 2;
    pts = 3;
    dst = 0.2;
end

% Signal to Noise Ratio
snr = 0:1:10;
range_snr = range(snr);
len_snr = length(snr);

for i=1:length(rep_value)
    reps = rep_value(i);
    % To estimate error for each SNR value and add it to estimate
    perr_estimate = zeros(len_snr,1);
    % To estimate error for each SNR value and add it to estimate
    sym_error = zeros(len_snr,1);
    
    % Repeatition
    rep_bits = Repeater(bits,reps);
    interleaved_bits = Interleaver(rep_bits,int_value(1));
    % Modulation
    mod = Modulator(interleaved_bits,M,gre);
    
    for k=1:len_snr
        num_gray=zeros(symbols,1);
    
        snr_now = snr(k); 
        % db to decimal
        snr_lin = 10^(snr_now/10);
        
        % Variance
        sigma=sqrt(1/(fctr*snr_lin));
    
        % Adding 2d Gaussian noise to symbols.
        received = mod + sigma*(randn(reps*symbols,1)+1i*randn(reps*symbols,1));
        
        % Demodulator
        decisions = Demodulator(received,M,gre);
        
        decisions = Deinterleaver(decisions,int_value(1));
        % Derepeater
        decisions = Derepeater(decisions,reps,symbols);
        
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
        sym_error(k) = mean(decisions~=bits);
    end
    
    % Plot the BER per symbols with SNR.
    %semilogy(snr,sym_error);
    % Plot the BER theoretical using Q-function.
    semilogy(snr,perr_estimate,'-or');
    hold on;
    %semilogy(snr,pts*qfunc(sqrt(dst*10.^(snr/10))));
    %semilogy(snr,(pts/modtype)*qfunc(sqrt(dst*10.^(snr/10))));
end
legend("K = 1","K = 3 ","K = 5"); 
%legend("Experimental SER ","Experimental BER ","Theoretical using Q function(SER)","Theoretical using Q function(BER)"); 
xlabel("SNR (dB)");
ylabel("SER (Symbol Error Rate)");
grid on; 