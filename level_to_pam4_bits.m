function bits = level_to_pam4_bits(x, d)
    if x >= d
        bits = [0;0];
    elseif x >= 0
        bits = [0;1];
    elseif x >= -d
        bits = [1;1];
    else
        bits = [1;0];
    end
end
