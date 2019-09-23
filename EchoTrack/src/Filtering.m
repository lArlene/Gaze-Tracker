clear;
clc;
[sampledata,FS] = audioread('AuodioOut.m4a');
s1=sampledata(:,1); % 抽取第 1 声道
s2=sampledata(:,2); % 抽取第 2 声道
sample = s1+s2;
T = length(sampledata)/FS;
x = 0:1/FS:T - 1/FS;
figure(1),
plot(sample),


% here is to read respond data, notice we use roughly 8 times the
% sampling frequency higher than paper
%176600 - 177600
s = sample(176600:177600);
figure(3),
subplot(2,1,1),
plot(s),
% xlabel('t-s'),
% axis([1,3.5,-0.1,0.1]),
subplot(2,1,2),
plot(real(fft((s)))),
% xlabel('t-s'),
% axis([1,3.5,-0.1,0.1]);

r = sample;
% design filter, 6 order butterworth filter with frequency domain 
% in 19khz to 21khz
[b,a] = butter(6,[16000 23000]/(FS/2));
r = filter(b,a,r);

figure(2),
plot(r);

s = sample(176600:177600);

figure(4),
plot(s);

% remove the multi-path noise
% this parameter has problem in removing echo, need test.
% Respond = [Respond(1:1400),zeros(1,6600)];
%figure(2);
%plot(Respond);
t= 0