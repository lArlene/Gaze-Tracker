% 采样和频谱分析测试

FS = 48000;
step = 1/FS;

t = 0:step:1;

x = cos(16000*t);

figure(1)
stem(t,x);
axis([0,2*pi/16000,-1,1])

frame = x(1:floor((2*pi/16000)*FS));
FRAME = fft(frame);
figure(2)
stem(fftshift(abs(FRAME)));