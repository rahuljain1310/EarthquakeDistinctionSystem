% Defining Constants
signal_duration = 600;
segment_length = 2048; % factor of 24000

% Reading Signal
X=rdsac();
Signal = X.d;
Signal = Signal / 10000;
L = size(Signal,1);
Signal = Signal.';

% Dividing Signal into Multi-Signal of length 1024.
trunc = fix(L/segment_length)*segment_length;
Signal = Signal(1:trunc);
Segment_Signal = reshape(Signal,segment_length,[]);
Segment_Signal = Segment_Signal.';

% Signal Details
Fs = L/signal_duration;    % Sampling frequency
T = 1/Fs;                  % Time period
L = trunc;                 % Length of Signal
t = (0:L-1)*T;             % Time array
tx = (0:segment_length-1)*T;  % Truncated time array

% Taper Cosine Bell
Bell_period = 2*segment_length*T;
Cosine_bell = sin(2*pi*t/Bell_period);
Cosine_bell = Cosine_bell(1:segment_length);
% plot(tx,Cosine_bell);  

%Tapering the Signal
Tapered_signal = Segment_Signal.*Cosine_bell;

% Compiling Signals with Sine Wave and Noise with Full Signal
S1 = 0.7*sin(2*pi*3*t) + 5*sin(2*pi*2*t) + 6*sin(2*pi*1*t);
X = S1 + 2*randn(size(t));    % Noise 
total_signal = S1+Signal;

% Compiling Sine Wave with Segmented Signal
S2 = 0.7*sin(2*pi*3*tx) + 5*sin(2*pi*2*tx) + 6*sin(2*pi*1*tx);
sz = size(Segment_Signal);
x = zeros(sz);
total_segmented_signal = Tapered_signal;

% Taking fft of Full Signal and Segemnted Signal
Y = fft(total_signal);
total_segmented_signal=total_segmented_signal.';
Y2 = fft(total_segmented_signal);
Y2 = Y2.';

% Calculating Signal in frequency Domain
P2 = abs(Y/L);
P1 = P2(1:L/8+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/8))/L;
% plot(f,P1)

n = 2;
% Calculating Segmented Signal in frequency Domain
sP2 = abs(Y2/segment_length);
sP1 = sP2(:,1:segment_length/n+1);
sP1(:,2:end-1) = 2*sP1(:,2:end-1);
sf = Fs*(0:(segment_length/n))/segment_length;
plot(sf,sP1);

% Labeliing Graph
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')

