function bitsOut = repetition_decode(bitsIn, repFactor)
    bitsIn = uint8(bitsIn(:));
    usable = floor(numel(bitsIn)/repFactor) * repFactor;
    M = reshape(bitsIn(1:usable), repFactor, []).';
    bitsOut = uint8(sum(M, 2) >= ceil(repFactor/2));
end