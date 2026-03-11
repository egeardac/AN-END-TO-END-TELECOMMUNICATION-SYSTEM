function [bits, meta] = lzw_compress_to_bits(srcBytes)
    srcBytes = srcBytes(:).';

    dict = containers.Map('KeyType', 'char', 'ValueType', 'double');
    for k = 0:255
        dict(char(k+1)) = k;
    end

    nextCode = 256;
    w = '';
    codes = zeros(1, max(1, numel(srcBytes)));
    nCodes = 0;

    for i = 1:numel(srcBytes)
        c = char(double(srcBytes(i)) + 1);
        wc = [w c];

        if isKey(dict, wc)
            w = wc;
        else
            if ~isempty(w)
                nCodes = nCodes + 1;
                codes(nCodes) = dict(w);
            end
            dict(wc) = nextCode;
            nextCode = nextCode + 1;
            w = c;
        end
    end

    if ~isempty(w)
        nCodes = nCodes + 1;
        codes(nCodes) = dict(w);
    end

    codes = codes(1:nCodes).';
    maxCode = max(codes);
    codeWidth = max(8, ceil(log2(double(maxCode) + 1)));

    bits = ints_to_bits(codes, codeWidth);

    meta.codeWidth = codeWidth;
    meta.numCodes  = nCodes;
end