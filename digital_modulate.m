function [symbols, padBits] = digital_modulate(bitsIn, modType, d)
    bitsIn = uint8(bitsIn(:));

    switch upper(modType)
        case 'QPSK'
            k = 2;
            padBits = mod(-numel(bitsIn), k);
            bitsPad = [bitsIn; zeros(padBits,1,'uint8')];
            B = reshape(bitsPad, 2, []).';
            a = d/2;
            symbols = zeros(size(B,1),1);

            for i = 1:size(B,1)
                b1 = B(i,1); b2 = B(i,2);
                if b1==0 && b2==0
                    symbols(i) =  a + 1i*a;
                elseif b1==0 && b2==1
                    symbols(i) = -a + 1i*a;
                elseif b1==1 && b2==1
                    symbols(i) = -a - 1i*a;
                else
                    symbols(i) =  a - 1i*a;
                end
            end

        case '16QAM'
            k = 4;
            padBits = mod(-numel(bitsIn), k);
            bitsPad = [bitsIn; zeros(padBits,1,'uint8')];
            B = reshape(bitsPad, 4, []).';
            symbols = zeros(size(B,1),1);

            for i = 1:size(B,1)
                I = pam4_bits_to_level(B(i,1), B(i,2), d);
                Q = pam4_bits_to_level(B(i,3), B(i,4), d);
                symbols(i) = I + 1i*Q;
            end

        otherwise
            error('Unsupported modulation type.');
    end
end