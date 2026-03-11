function srcBytes = read_text_bytes(fileName, makeFallbackFile)
    if ~isfile(fileName)
        if makeFallbackFile
            baseText = [ ...
                'This is a fallback large text file for the end-to-end telecommunication ', ...
                'system simulation. It is intentionally repetitive so that the Lempel-Ziv ', ...
                'compressor has visible gain. The quick brown fox jumps over the lazy dog. ', ...
                'MATLAB physical layer simulation with QPSK, 16-QAM, repetition coding, ', ...
                'and complex AWGN channel. '];
            txt = repmat(baseText, 1, 400);
            fid = fopen(fileName, 'w');
            fwrite(fid, txt, 'char');
            fclose(fid);
        else
            error('Text file not found.');
        end
    end

    fid = fopen(fileName, 'r');
    srcBytes = fread(fid, Inf, '*uint8');
    fclose(fid);

    if isempty(srcBytes)
        error('Input text file is empty.');
    end
end