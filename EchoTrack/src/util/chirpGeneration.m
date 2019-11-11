function [ signal_r,signal_l ] = chirpGeneration( RATE,duration_t,period,N,amplitude,modulation )
%chirpGeneration generate 2 signal during a period
%   ����chirp����ʱ��Ϊduration_t,������0����
%   ��chirp�ȳ��֣���chirp����chirp��
%   RATE: ����Ƶ��
%   duration_t: chirp����ʱ��
%   period: һ���źŵ�����
%   N: �ظ�N������
%   amplitude: ����chirp�źŵķ�ֵ
%   modulation=0 Ĭ�ϲ����е���

if nargin < 5, amplitude = 1; end
if nargin < 6, modulation = 0; end


STEP = 1/RATE; %step
t_chirp = 0:STEP:duration_t;%chirp ����ʱ�����
t = 0:STEP:period;% tΪһ������ʱ�����
% ��chirp��up-chirp,��chirp��down-chirp
% ��chirp emit first
chirp_l = amplitude.*chirp(t_chirp,16000,duration_t,23000);
chirp_r = flip(chirp_l);
% �����Ҫ����
if(modulation)
    chirp_l = chirp_l.*sin(1000.*pi.*t_chirp);
    chirp_r = chirp_r.*sin(1000.*pi.*t_chirp);
end

%�ϳ�Ϊ������������ź�
signal_lt = [chirp_l,zeros(1,length(t)-length(chirp_r))];
signal_rt = [zeros(1,length(chirp_r)),chirp_r,zeros(1,length(t)-2.*length(chirp_r))];
% �ظ�N������
signal_l = [];
signal_r = [];

for times = (1:N)
    signal_l = [signal_l,signal_lt];
    signal_r = [signal_r,signal_rt];
end


end

