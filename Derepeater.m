function derep = Derepeater(bits,reps)
    derep = [];
    new = zeros(reps,1);
    for i=1:length(bits)
        bit = bits(i);
        for j=1:reps
            new(j) = bit;
        end
        derep = [rep new'];
    end
end