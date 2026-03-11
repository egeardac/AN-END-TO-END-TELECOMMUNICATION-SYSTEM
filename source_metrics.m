function [ser, runningSER, correctBits] = source_metrics(srcBytes, rxBytes)
    srcBytes = srcBytes(:);
    rxBytes  = rxBytes(:);

    N = numel(srcBytes);
    L = min(numel(srcBytes), numel(rxBytes));

    errVec = true(N,1);
    if L > 0
        errVec(1:L) = (srcBytes(1:L) ~= rxBytes(1:L));
    end

    ser = mean(errVec);
    runningSER = cumsum(double(errVec)) ./ (1:N).';

    if L == 0
        correctBits = 0;
        return;
    end

    xorv = bitxor(srcBytes(1:L), rxBytes(1:L));
    bitErrors = 0;
    for b = 1:8
        bitErrors = bitErrors + sum(bitget(xorv, b));
    end
    correctBits = 8*L - bitErrors;
end