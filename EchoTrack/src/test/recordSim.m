function [ record ] = recordSim( chirp_l,chirp_r)
%输入左右声道chirp信号，输出接收的声音模拟
%   chirp_l: 左声道chirp
%   chirp_r: 右声道chirp
%   left receieve: delay 0.45ms
%   right receieve: delay 0.06ms(0.01+0.06=0.07ms)
%   right echo: 1.21ms
%   left echo: 1.65ms
%   产生模拟回声以及添加白噪声模拟环境干扰
RATE = 48000;
[echo_l,echo_r]= chirpGeneration(RATE,0.001,0.02,1,0.2,1);
record = [zeros(1,0.07.*RATE),chirp_r,zeros(1,0.18*RATE),chirp_l,zeros(1,0.56.*RATE),echo_r,zeros(1,0.24.*RATE),echo_l];
record = record + rand([1,length(record)]).*0.2;
plot(record);
end

