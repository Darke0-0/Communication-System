function leav = Interleaver(bits,parts)
    leav = [];
    size = length(bits)/parts;
    for i=1:size
        % Repeats the bits
        for j=1:parts
            leav = [leav bits((j-1)*size + i)];
        end
    end
    leav = leav';
end