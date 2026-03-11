function bits = ints_to_bits(vals, width)
    if isempty(vals)
        bits = uint8([]);
        return;
    end
    bitMat = dec2bin(vals, width) - '0';
    bits = uint8(reshape(bitMat.', [], 1));
end