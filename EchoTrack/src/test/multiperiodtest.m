%�����ھ������
clc;
clear;
RATE = 48000;

[signal_r,signal_l] = chirpGeneration(RATE,0.001,0.02,3,1);
[r,l] = chirpGeneration(RATE,0.001,0.02,1,1);
[echo_r,echo_l] = chirpGeneration(RATE,0.001,0.02,3,0.2);

%����ģ���ź�
%offset=5ms ��������任 �����ź�ʱ��ʱ�䣬����ʵ������ӦΪδ֪��
offset = 0.005.*RATE;
record = [zeros(1,offset),signal_r+signal_l];
e_offset = 0.01.*RATE+offset;

echo = echo_r+echo_l;
k = length(echo) - e_offset;
echo = [zeros(1,e_offset),echo(1:k),zeros(1,length(record)-length(echo))];

%��ӻ��� 34cm 10ms
%after raw signal
record = record+echo;
% ƥ���˲�����
T = 0:1/RATE:(length(record)-1)/RATE;
N = length(T);
%��left chirp ���
match_l = fliplr([r,zeros(1,length(record)-length(r))]);
x_match = fliplr(T*-1);
n_res = x_match(1)+T(1):1/RATE:x_match(end)+T(end);
ex_record = conv(match_l,record);

%ȡ����Ч����
len = length(ex_record);
%len = 2N+1
ex_record = ex_record((len+1)/2:end);

figure(1)
subplot(3,1,1)
plot(T,record),xlabel('t - s')
ylim([-3,3])
subplot(3,1,2)
plot(x_match,match_l),xlabel('t - s')
subplot(3,1,3)
plot(T,ex_record);
ylim([-25,25]);


