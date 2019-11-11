clc
clear
% chirp����ҵ���ֵ��chirp��ֵ�Ĺ�ϵ
f0 = 16000;
f1 = 23000;
u0 = (f1 - f0) / 0.02;
RATE = 48000;
t = 0: 1/RATE: 0.02; 
phase_l = f0 * t + 0.5 * u0 * t .* t;
phase_r = f1 * t - 0.5 * u0 * t .* t;
chirp_l = cos(2 * pi * phase_l);
chirp_r = cos(2 * pi * phase_r);
% modulate in time domain
chirp_l = chirp_l .* 100 .* sin(50*pi*t);
chirp_r = chirp_r .* 100 .* sin(50*pi*t);
% ��ȡchirp���


% ƫ����˻�ȡ����ֵ������飬ÿ��ƫ��1/RATE ms ��1��������
% len = length(chirp_l)
% diff = zeros(1,300);
% shift = 100;
% chirp_ori = [chirp_l,zeros(1,shift)];% ����chirp���
% chirp_shift = [zeros(1,shift),chirp_l];
% res = chirp_ori.*chirp_shift;
% N = length(res);
% f_res = fftshift(fft(res).*N);
% abs_f_res = abs(f_res);
% [a,location] = findpeaks(abs_f_res,'SortStr','descend','NPeaks',2);
diff = zeros(1,300);

for shift = 1:300
    chirp_ori = [chirp_l,zeros(1,shift)];% ����chirp���
    chirp_shift = [zeros(1,shift),chirp_l];
    res = chirp_ori.*chirp_shift;
    N = length(res);
    f_res = fftshift(fft(res).*N);
    abs_f_res = abs(f_res);
    [a,location]=findpeaks(abs_f_res,'SortStr','descend','NPeaks',2);
    if(abs(a(1)-a(2))<1000)
        diff(shift)=abs(location(1)-location(2));
    end
end
stem(diff);
