function [ record ] = recordSim( chirp_l,chirp_r)
%������������chirp�źţ�������յ�����ģ��
%   chirp_l: ������chirp
%   chirp_r: ������chirp
%   left receieve: delay 0.45ms
%   right receieve: delay 0.06ms(0.01+0.06=0.07ms)
%   right echo: 1.21ms
%   left echo: 1.65ms
%   ����ģ������Լ���Ӱ�����ģ�⻷������
RATE = 48000;
[echo_l,echo_r]= chirpGeneration(RATE,0.001,0.02,1,0.2,1);
record = [zeros(1,0.07.*RATE),chirp_r,zeros(1,0.18*RATE),chirp_l,zeros(1,0.56.*RATE),echo_r,zeros(1,0.24.*RATE),echo_l];
record = record + rand([1,length(record)]).*0.2;
plot(record);
end

