% Defining Constants
signal_duration = 600;

% Reading Signal
X=rdsac();
Signal = X.d;
Signal = Signal / 10000;

% Signal Details
L = size(Signal,1);      % Length of Signal
Fs = L/signal_duration;  % Sampling frequency
T = 1/Fs;                % Time period
t = (0:L-1)*T;           % Time array

% Compiling Signals
S = 0.7*sin(2*pi*3*t) + 5*sin(2*pi*2*t) + 6*sin(2*pi*1*t);
X = S + 2*randn(size(t));
Signal = Signal.';
total_signal = S+Signal;

% Taking fft of Total Signal
Y = fft(total_signal);

% Calculating Signal in frequency Domain
P2 = abs(Y/L);
P1 = P2(1:L/8+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/8))/L;

% Plotting Fourier Analysis
plot(f,P1)
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

