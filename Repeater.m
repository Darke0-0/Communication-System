function rep = Repeater(bits,reps)
    rep = [];
    new = zeros(reps,1);
    for i=1:length(bits)
        bit = bits(i);
        for j=1:reps
            new(j) = bit;
        end
        rep = [rep new'];
    end
end