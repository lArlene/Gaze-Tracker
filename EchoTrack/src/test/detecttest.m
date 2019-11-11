clc;
clear;
% 实际接受信号处理
% date: 2019/10/28

RATE=48000;
fileId = fopen('Record20cm.pcm','r');
sampledata = fread(fileId,inf,'int16');

%时间坐标---------------
T = length(sampledata)/RATE;
x = 0:1/RATE:T - 1/RATE;
%-------------------------
% figure(1)
% plot(x,sampledata);
% 带通滤波器
record = sampledata';
[b,a] = butter(8,[16000 23000]/(RATE/2));
record = filter(b,a,record);
figure(2),
plot(record);

t_record = record(154500:155600);
plot(t_record)
T = length(t_record)/RATE;
%------------------------------
[r,l] = chirpGeneration(RATE,0.001,0.02,1,1);
%和left chirp 相关
match_l = fliplr([l,zeros(1,length(t_record)-length(l))]);
x_match = fliplr(T*-1);
n_res = x_match(1)+T(1):1/RATE:x_match(end)+T(end);
ex_record = conv(match_l*1000,t_record);
%取出有效部分
len = length(ex_record);
%len = 2N+1
ex_record = ex_record((len+1)/2:end);
 
figure(1)
subplot(2,1,1)
plot(t_record),xlabel('t - s')

subplot(2,1,2)
plot(ex_record);
% plot(x_match,match_l),xlabel('t - s')




