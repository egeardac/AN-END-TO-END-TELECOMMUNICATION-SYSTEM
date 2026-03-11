function srcBytes = lzw_decompress_from_bits(bits, meta)
    codes = bits_to_ints(bits, meta.codeWidth, meta.numCodes);

    if isempty(codes)
        srcBytes = uint8([]);
        return;
    end

    dict = containers.Map('KeyType', 'double', 'ValueType', 'any');
    for k = 0:255
        dict(k) = uint8(k);
    end

    nextCode = 256;
    prevEntry = dict(codes(1));
    out = prevEntry(:).';

    for i = 2:numel(codes)
        code = codes(i);

        if isKey(dict, code)
            entry = dict(code);
        elseif code == nextCode
            entry = [prevEntry prevEntry(1)];
        else
            error('Invalid LZW stream after channel decoding.');
        end

        out = [out entry]; %#ok<AGROW>
        dict(nextCode) = [prevEntry entry(1)];
        nextCode = nextCode + 1;
        prevEntry = entry;
    end

    srcBytes = uint8(out(:));
end