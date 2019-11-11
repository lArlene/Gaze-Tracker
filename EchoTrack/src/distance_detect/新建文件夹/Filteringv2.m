clear;
clc;
FS=48000;
fileId = fopen('Null20191110172118.pcm','r');
sampledata = fread(fileId,inf,'int16');
% [sampledata,FS] = audioread('htc_rec_480.wav');
T = length(sampledata)/FS;
x = 0:1/FS:T - 1/FS;
figure(1),
% 原始信号
plot(sampledata);
title('raw data');

% here is to read respond data, notice we use roughly 8 times the
% sampling frequency higher than paper

s = sampledata;
% s = sampledata(:,1) + sampledata(:,2); %cobine double channel
s = s';
% shift 是在干嘛
N = length(s);
f = (0:N-1)/N;
f = f*FS;
figure(2),
subplot(2,1,2),
plot(f,abs(fft(s))),
xlabel('\omega/hz'),
% axis([1,3.5,-0.1,0.1]),
subplot(2,1,1),
plot(x,s),
xlabel('t-s'),
xlim([0,8]);

r = s;
% design filter, 6 order butterworth filter with frequency domain 
% in 16khz to 23khz
% !!! noticed that we should framming before filtering ?
[b,a] = butter(8,[16000 23000]/(FS/2));
r = filter(b,a,r);
figure(3)
plot(x,r),
xlabel('t-s'),
xlim([0,8]);
% r = r(57880:length(r));

%generate dechirp reference
t = 0: 1/FS :0.02 - 1/FS;
ori_up_chirp = chirp(t,16000,0.02,23000);
ori_down_chirp = chirp(t,23000,0.02,16000);
ori_up_chirp = ori_up_chirp .* 100 .* sin(50*pi*t);
ori_down_chirp = ori_down_chirp .* 100 .* sin(50*pi*t);

%line up
% ori_up = [ori_up_chirp,zeros(1,length(r) - length(ori_up_chirp))];
% mat_r = matchFilter(r,ori_up);
% [pks,locs] = findpeaks(mat_r,'minpeakheight',5000000);
% r = r(locs(1) : length(r)); % if need half period shift   - FS * 0.01

start_t = lineUpDec(r,ori_up_chirp);
r = r((start_t * FS) : length(r));


%deal single period with 10% overlap
delay_up = [];
delay_down = [];
while(length(r) >= 0.066 * FS)
    single_period = r(1: 0.066 * FS);  %always get the initial period
    % remove the multi-path noise
    single_period = single_period(1: 0.046 * FS);
    
    chirp_length = 0.02 * FS;
    up_ref = [ori_up_chirp, zeros(1,length(single_period) - chirp_length)];
    down_ref = [zeros(1,chirp_length), ori_down_chirp, zeros(1,length(single_period) - 2 * length(ori_down_chirp))];
    dec_up = single_period .* up_ref;
    dec_down = single_period .* down_ref;

    [DU,DD] = echoCheck(dec_up,dec_down);
    delay_up = [delay_up,DU];
    delay_down = [delay_down,DD];
    
    r = r(0.06*FS : length(r)); % shows 10% overlap
end

[distant_d1,distant_d2] = distantCalculate(delay_up,delay_down);


figure(4)
plot(distant_d1)
hold on
plot(distant_d2)


