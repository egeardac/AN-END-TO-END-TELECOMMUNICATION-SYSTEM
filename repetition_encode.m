function bits = repetition_encode(bitsIn, repFactor)
    bitsIn = uint8(bitsIn(:));
    bits = repelem(bitsIn, repFactor);
end