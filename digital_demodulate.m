function bitsOut = digital_demodulate(rxSymbols, modType, d)
    rxSymbols = rxSymbols(:);

    switch upper(modType)
        case 'QPSK'
            bitsOut = zeros(2*numel(rxSymbols),1,'uint8');
            idx = 1;
            for i = 1:numel(rxSymbols)
                r = real(rxSymbols(i));
                q = imag(rxSymbols(i));

                if r >= 0 && q >= 0
                    pair = [0;0];
                elseif r < 0 && q >= 0
                    pair = [0;1];
                elseif r < 0 && q < 0
                    pair = [1;1];
                else
                    pair = [1;0];
                end

                bitsOut(idx:idx+1) = uint8(pair);
                idx = idx + 2;
            end

        case '16QAM'
            bitsOut = zeros(4*numel(rxSymbols),1,'uint8');
            idx = 1;
            for i = 1:numel(rxSymbols)
                bI = level_to_pam4_bits(real(rxSymbols(i)), d);
                bQ = level_to_pam4_bits(imag(rxSymbols(i)), d);
                bitsOut(idx:idx+3) = uint8([bI(:); bQ(:)]);
                idx = idx + 4;
            end

        otherwise
            error('Unsupported modulation type.');
    end
end
