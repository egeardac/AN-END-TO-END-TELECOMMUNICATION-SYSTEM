function res = simulate_once(srcBytes, compBits, lzMeta, modType, d, repFactor, sigma2)
    txCodedBits = repetition_encode(compBits, repFactor);
    [txSymbols, ~] = digital_modulate(txCodedBits, modType, d);

    noise = sqrt(sigma2/2) * (randn(size(txSymbols)) + 1i*randn(size(txSymbols)));
    rxSymbols = txSymbols + noise;

    rxCodedBits = digital_demodulate(rxSymbols, modType, d);
    rxCodedBits = rxCodedBits(1:numel(txCodedBits));

    rxCompBits = repetition_decode(rxCodedBits, repFactor);
    rxCompBits = rxCompBits(1:numel(compBits));

    try
        rxBytes = lzw_decompress_from_bits(rxCompBits, lzMeta);
    catch
        rxBytes = uint8([]);
    end

    [sourceSER, runningSER, correctBits] = source_metrics(srcBytes, rxBytes);

    res.sourceSER    = sourceSER;
    res.runningSER   = runningSER;
    res.correctBits  = correctBits;
    res.numTxSymbols = numel(txSymbols);
    res.nominalRate  = 8*numel(srcBytes) / numel(txSymbols);
    res.reliableRate = correctBits / numel(txSymbols);
    res.rxBytes      = rxBytes;
end