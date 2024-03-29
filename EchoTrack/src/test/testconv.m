%卷积测试
clc;
clear;

RATE = 48000;

[signal_r,signal_l] = chirpGeneration(RATE,0.001,0.02,2,1);
[r,l] = chirpGeneration(RATE,0.001,0.02,1,1);
[echo_r,echo_l] = chirpGeneration(RATE,0.001,0.02,1,0.2);

%构造模拟信号
%offset=5ms 进行坐标变换 接受信号时延时间，在真实环境中应为未知量
offset = 0.005.*RATE;
record = [zeros(1,offset),signal_r+signal_l];
e_offset = 0.01.*RATE+offset;
%添加回声 34cm 10ms
%after raw signal
record = record + [zeros(1,e_offset),echo_r+echo_l,zeros(1,length(record)-length(echo_r)-e_offset)];
% % 匹配滤波测试
T = 0:1/RATE:(length(record)-1)/RATE;
N = length(T);
%和left chirp 相关
match_l = fliplr([l,zeros(1,length(record)-length(l))]);
x_match = fliplr(T*-1);
n_res = x_match(1)+T(1):1/RATE:x_match(end)+T(end);
% ex_record = conv(match_l,record);

match_lk = [l,zeros(1,length(record)-length(l))];

fpfs = conj(fft(match_lk)).*(fft(record));
% %function z
% for ele = 1:length(fpfs)
%     if(fpfs(ele)<=0)
%         fpfs(ele)=0;
%      end
% end
% 
ex_record = ifftshift((N.*ifft(fpfs)));


figure(1)
subplot(3,1,1)
plot(T,record),xlabel('t - s')
ylim([-3,3])
subplot(3,1,2)
plot(x_match,match_l),xlabel('t - s')
subplot(3,1,3)
plot(T,ex_record);



