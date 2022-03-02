function rep = Repeater(bits,reps)
    rep = [];
    temp = zeros(reps,1);
    for i=1:length(bits)
        % Selects the Bit
        bit = bits(i);
        % Repeats the bits
        for j=1:reps
            temp(j) = bit;
        end
        % Adds the bits
        rep = [rep temp'];
    end
    rep = rep';
end