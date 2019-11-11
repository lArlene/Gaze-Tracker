% ---------------------------------------------
% 正确的chirp信号生成
% Author: wangberlin
% Time: 2019.10.18
% plot spectorgram to analysis
clear;
clc;
% ---------------------------------------------

% set sampling rate and define sampling step
RATE = 48000;  %sampling rate 400KHZ
STEP = 1/RATE; %step
T = 0.02; % a period time
% ---------------------------------
%generate left and right chirp signal
t_chirp = 0:STEP:0.001; %1ms each
chirp_r = chirp(t_chirp,16000,0.001,23000);
chirp_l = chirp_r;
%whole signal during time t = 20ms
t = 0:STEP:T;
R_signal = [chirp_r,zeros(1,length(t)-length(chirp_r))];
L_signal = [zeros(1,length(chirp_r)),chirp_l,zeros(1,length(t)-2.*length(chirp_r))];

figure(1)
plot(t,R_signal,'r')
ylim([-2,2])
hold on
plot(t,L_signal,'g')
ylim([-2,2]);
xlabel('t - s')
figure(2)
spectrogram(R_signal,256,250,256,1E3);

% dechirp test------------------------
% chirpmul = chirp_r.*chirp_r;
% len = length(chirp_r);
% f_chirpmul = abs(fft(chirpmul)/len);
% plot(fftshift(f_chirpmul));
% 
% offset = 300;
% chirp_rt0 = [zeros(1,offset),chirp_r(offset+1:end)];
% figure(3)
% plot(chirp_rt0)
% chirpmul_t0 = chirp_r.*chirp_rt0;
% len = length(chirp_rt0);
% f_chirpmul_t0 = abs(fft(chirpmul_t0)/len);
% figure(4)
% plot(fftshift(f_chirpmul_t0));
% ----------------------------------------------
% correlation test
% decrease coefficient a = 0.5
a = 0.5;
echo = chirp_r.*a;
% receive offset
offset = 0.001;
point_off = offset.*RATE;
% time - point transfrom
time = 0.004;
point = time.*RATE;
echo_t = [zeros(1,point),echo,zeros(1,length(R_signal)-length(echo)-point)];
modulate_signal = [zeros(1,point_off),R_signal(point_off+1:end)] + echo_t;
figure(3)
plot(t,modulate_signal)
