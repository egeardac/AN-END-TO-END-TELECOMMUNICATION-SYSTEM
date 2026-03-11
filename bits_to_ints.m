function vals = bits_to_ints(bits, width, numVals)
    if numVals == 0
        vals = [];
        return;
    end
    bits = bits(:);
    needed = width * numVals;
    bits = bits(1:needed);
    bitMat = reshape(char(double(bits) + 48), width, []).';
    vals = bin2dec(bitMat);
end