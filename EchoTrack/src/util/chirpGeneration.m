function [ signal_r,signal_l ] = chirpGeneration( RATE,duration_t,period,N,amplitude,modulation )
%chirpGeneration generate 2 signal during a period
%   左右chirp持续时间为duration_t,其他用0补齐
%   左chirp先出现，右chirp在左chirp后
%   RATE: 采样频率
%   duration_t: chirp持续时间
%   period: 一个信号的周期
%   N: 重复N个周期
%   amplitude: 生成chirp信号的幅值
%   modulation=0 默认不进行调制

if nargin < 5, amplitude = 1; end
if nargin < 6, modulation = 0; end


STEP = 1/RATE; %step
t_chirp = 0:STEP:duration_t;%chirp 持续时间采样
t = 0:STEP:period;% t为一个周期时间采样
% 左chirp是up-chirp,右chirp是down-chirp
% 左chirp emit first
chirp_l = amplitude.*chirp(t_chirp,16000,duration_t,23000);
chirp_r = flip(chirp_l);
% 如果需要调制
if(modulation)
    chirp_l = chirp_l.*sin(1000.*pi.*t_chirp);
    chirp_r = chirp_r.*sin(1000.*pi.*t_chirp);
end

%合成为左右声道输出信号
signal_lt = [chirp_l,zeros(1,length(t)-length(chirp_r))];
signal_rt = [zeros(1,length(chirp_r)),chirp_r,zeros(1,length(t)-2.*length(chirp_r))];
% 重复N个周期
signal_l = [];
signal_r = [];

for times = (1:N)
    signal_l = [signal_l,signal_lt];
    signal_r = [signal_r,signal_rt];
end


end

