# End-to-End Physical Layer Telecommunication System Simulation in MATLAB

#### I made this simulation during labratories with help AI tools, clear instructions of my professor and my theoretical knowledge

## Overview

This project implements a discrete-time end-to-end physical-layer simulation of a telecommunication system in MATLAB.

The system includes the following blocks:

### Transmitter
- Compressor
- Channel Encoder
- Digital Modulator

### Channel
- Complex-valued AWGN channel

### Receiver
- Digital Demodulator / Detector
- Channel Decoder
- Decompressor

The implementation uses:

- **Compression / Decompression:** Lempel-Ziv (LZW-style dictionary-based compression)
- **Channel Coding / Decoding:** Repetition codes
- **Digital Modulation / Demodulation:** QPSK and 16-QAM
- **Channel Model:** Complex passband AWGN channel

The input to the system is a large text file. The output performance is evaluated in terms of:
- running frequency of input symbol errors
- final source symbol error rate
- reliable end-to-end data rate

---

# System Model

The equivalent discrete-time complex baseband/passband channel model used is:

y[k] = x[k] + n[k]

where:

- x[k] is the transmitted constellation symbol  
- y[k] is the received symbol  
- n[k] ~ CN(0, σ²) is complex AWGN noise  

---

# System Blocks

## 1. Compressor
The source file is read as a byte stream and compressed using a Lempel-Ziv dictionary-based algorithm.

## 2. Channel Encoder
The compressed bitstream is encoded using a repetition code.

Each bit is repeated **repFactor** times.

## 3. Digital Modulator

Two modulation schemes are implemented:

- QPSK
- 16-QAM

The constellation spacing is controlled by parameter **d**.

## 4. AWGN Channel

The modulated symbols pass through a complex Gaussian noise channel with variance **σ²**.

## 5. Digital Demodulator / Detector

Nearest-region hard decision detection is used to recover coded bits.

## 6. Channel Decoder

Majority voting is applied to decode the repetition code.

## 7. Decompressor

The recovered compressed bitstream is decompressed to reconstruct the original source bytes.

---

# Parameters

Main system parameters:

- **fileName**  
  Input text file.

- **d**  
  Distance between constellation points.

- **σ² (sigma2)**  
  Variance of the complex AWGN noise.

- **repFactor**  
  Repetition code factor.

- **modType**  
  Modulation type: `QPSK` or `16QAM`.

- **sigma2Sweep**  
  Noise variance values used for performance analysis.

- **numTrialsSweep**  
  Number of Monte Carlo trials used for averaging.

---

# Performance Metrics

## Running Frequency of Input Symbol Errors

Running error frequency:

RunningSER(n) = errors up to n / n

This shows how the error frequency evolves during transmission.

---

## Final Source Symbol Error Rate

The total fraction of incorrectly reconstructed source symbols (bytes) after the full system.

---

## Reliable End-to-End Data Rate

Defined as:

R_rel = correct recovered source bits / transmitted channel symbols

This measures how many source bits are successfully delivered per signaling interval.

---

## Nominal Data Rate

Nominal rate:

R_nom = total source bits / transmitted channel symbols

This corresponds to the ideal noise-free case.

---

# Verification Procedure

## Case 1: Zero Noise

Set

sigma² = 0

Expected results:

- Source symbol error rate = 0
- Reconstructed file identical to input

This verifies that the full chain operates correctly.

---

## Case 2: Small Noise

Set

sigma² > 0

Expected behavior:

- Source symbol error rate increases
- Reliable data rate decreases
- Running error frequency grows over time

---

# Expected Behavior

## Noise-Free Case

When σ² = 0:

- Perfect demodulation
- Perfect decoding
- Perfect decompression

Therefore:

Source SER = 0

---

## Noisy Case

As noise variance increases:

- Detection errors increase
- Channel decoding may fail
- Decompression becomes extremely sensitive to bit errors

Because Lempel-Ziv compression is error-sensitive, even a small number of bit errors may cause:

- decompression failure
- error propagation
- large source symbol error rates

---

# File Structure

Example project structure:

```
telecom_physical_layer_sim.m
large_text.txt
README.md
```

If `large_text.txt` is not found, the script can automatically generate a fallback file.

---

# How to Run

1. Place the MATLAB script in a folder.

2. Add a large text file named

```
large_text.txt
```

3. Open MATLAB in that folder.

4. Run:

```
telecom_physical_layer_sim
```

---

# Output

The script prints:

- Source file size
- Compressed bit count
- Compression ratio
- Repetition factor
- Constellation spacing
- Source symbol error rate
- Reliable data rate
- Nominal data rate

It also generates the following plots:

1. Running error frequency (QPSK)
2. Running error frequency (16QAM)
3. Source symbol error rate vs noise variance
4. Reliable data rate vs noise variance

---

# Interpretation of Results

Typical observations:

- When σ² = 0, both QPSK and 16QAM have zero source error rate.
- 16QAM achieves higher nominal data rate because it carries more bits per symbol.
- As noise increases, reliable data rate decreases.
- Due to decompression sensitivity, source-level error rates may increase rapidly even when modulation-level errors are moderate.

---

# Notes

- One **source symbol** corresponds to **one input byte**.
- The error metric is therefore a **byte error rate**.
- Because compression is used, results represent **end-to-end system performance**, not only raw modulation performance.

---

# Possible Extensions

Possible improvements:

- Hamming or convolutional coding
- Soft-decision detection
- BER and SER analysis before decompression
- Eb/N0 based performance curves
- OFDM transmission
- Rayleigh fading channels
- Interleaving for burst error mitigation

---

# Summary

This MATLAB project simulates a complete digital communication chain including:

- source compression
- channel coding
- digital modulation
- AWGN channel
- demodulation
- decoding
- source reconstruction

It illustrates the trade-off between:

- reliability
- data rate
- modulation order
- channel noise
- source coding sensitivity
