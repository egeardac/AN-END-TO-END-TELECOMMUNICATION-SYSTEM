clear; clc; close all;
rng(7);

% =========================================================
% END-TO-END PHYSICAL LAYER SIMULATION
% Blocks:
% Tx: Compressor -> ChannelEncoder -> DigitalModulator
% Ch: Complex AWGN Channel
% Rx: DigitalDemodulator/Detector -> ChannelDecoder -> Decompressor
%
% Source symbol = 1 input byte from the text file.
% Reliable data rate = correct recovered source bits / transmitted channel symbols.
%
% Parameters:
% d         : nearest-neighbor constellation distance
% sigma2    : variance of complex AWGN, n ~ CN(0, sigma2)
% repFactor : repetition code length
% modType   : 'QPSK' or '16QAM'
% =========================================================

cfg.fileName         = 'large_text.txt';   % put your file in the same folder
cfg.makeFallbackFile = true;               % creates a large file if none exists
cfg.d                = 2.0;                % constellation spacing
cfg.repFactor        = 3;                  % use odd values
cfg.modList          = {'QPSK','16QAM'};
cfg.sigma2Sweep      = linspace(0,0.60,13);
cfg.numTrialsSweep   = 3;                  % averaging over trials for smoother curves

% ---------------------------------------------------------
% Read source text file
% ---------------------------------------------------------
srcBytes = read_text_bytes(cfg.fileName, cfg.makeFallbackFile);

% ---------------------------------------------------------
% Compress once (same source for all experiments)
% ---------------------------------------------------------
[compBits, lzMeta] = lzw_compress_to_bits(srcBytes);

fprintf('====================================================\n');
fprintf('Source file                : %s\n', cfg.fileName);
fprintf('Source bytes               : %d\n', numel(srcBytes));
fprintf('Compressed bits            : %d\n', numel(compBits));
fprintf('Compression ratio          : %.4f\n', numel(compBits)/(8*numel(srcBytes)));
fprintf('Repetition factor          : %d\n', cfg.repFactor);
fprintf('Constellation spacing d    : %.4f\n', cfg.d);
fprintf('====================================================\n\n');

% ---------------------------------------------------------
% PART I: Verify perfect operation for sigma2 = 0
% Then use a small nonzero sigma2 and show degradation
% ---------------------------------------------------------
for m = 1:numel(cfg.modList)
    modType = cfg.modList{m};

    if strcmpi(modType, 'QPSK')
        sigmaSmall = 0.35;   % chosen to usually show visible degradation
    else
        sigmaSmall = 0.20;   % 16-QAM degrades earlier
    end

    res0 = simulate_once(srcBytes, compBits, lzMeta, modType, cfg.d, cfg.repFactor, 0.0);
    res1 = simulate_once(srcBytes, compBits, lzMeta, modType, cfg.d, cfg.repFactor, sigmaSmall);

    fprintf('%s results:\n', modType);
    fprintf('  sigma^2 = 0       -> source SER = %.6f, reliable rate = %.6f bits/symbol\n', ...
        res0.sourceSER, res0.reliableRate);
    fprintf('  sigma^2 = %.4f -> source SER = %.6f, reliable rate = %.6f bits/symbol\n\n', ...
        sigmaSmall, res1.sourceSER, res1.reliableRate);

    figure('Name', ['Running error frequency - ' modType]);
    plot(1:numel(res0.runningSER), res0.runningSER, 'LineWidth', 1.5); hold on;
    plot(1:numel(res1.runningSER), res1.runningSER, 'LineWidth', 1.5);
    grid on;
    xlabel('Input symbol index (source byte index)');
    ylabel('Running frequency of input symbol errors');
    title(['Running source-symbol error frequency, ' modType]);
    legend('\sigma^2 = 0', sprintf('\\sigma^2 = %.3f', sigmaSmall), 'Location', 'best');
end

% ---------------------------------------------------------
% PART II: Sweep sigma2 and graph
%   i) final source-symbol error rate
%   ii) reliable data rate
% ---------------------------------------------------------
numS = numel(cfg.sigma2Sweep);
numM = numel(cfg.modList);

SER_avg  = zeros(numS, numM);
Rrel_avg = zeros(numS, numM);
Rnom_avg = zeros(numS, numM);

for m = 1:numM
    modType = cfg.modList{m};

    for i = 1:numS
        sigma2 = cfg.sigma2Sweep(i);

        serTrials  = zeros(cfg.numTrialsSweep,1);
        rrelTrials = zeros(cfg.numTrialsSweep,1);
        rnomTrials = zeros(cfg.numTrialsSweep,1);

        for t = 1:cfg.numTrialsSweep
            res = simulate_once(srcBytes, compBits, lzMeta, modType, cfg.d, cfg.repFactor, sigma2);
            serTrials(t)  = res.sourceSER;
            rrelTrials(t) = res.reliableRate;
            rnomTrials(t) = res.nominalRate;
        end

        SER_avg(i,m)  = mean(serTrials);
        Rrel_avg(i,m) = mean(rrelTrials);
        Rnom_avg(i,m) = mean(rnomTrials);
    end
end

figure('Name', 'Source symbol error rate vs noise variance');
hold on;
for m = 1:numM
    plot(cfg.sigma2Sweep, SER_avg(:,m), '-o', 'LineWidth', 1.5, ...
        'DisplayName', cfg.modList{m});
end
grid on;
xlabel('\sigma^2');
ylabel('Final source symbol error rate');
title('Overall system degradation vs AWGN variance');
legend('Location', 'best');

figure('Name', 'Reliable data rate vs noise variance');
hold on;
for m = 1:numM
    plot(cfg.sigma2Sweep, Rrel_avg(:,m), '-o', 'LineWidth', 1.5, ...
        'DisplayName', [cfg.modList{m} ' reliable']);
end
for m = 1:numM
    yline(Rnom_avg(1,m), '--', ['Nominal ' cfg.modList{m}], 'LineWidth', 1.2);
end
grid on;
xlabel('\sigma^2');
ylabel('Rate (correct source bits / channel symbol)');
title('Reliable end-to-end data rate');
legend('Location', 'best');

% ---------------------------------------------------------
% Print nominal rates
% ---------------------------------------------------------
fprintf('Nominal source rate (sigma^2 = 0):\n');
for m = 1:numM
    fprintf('  %s : %.6f bits/symbol\n', cfg.modList{m}, Rnom_avg(1,m));
end