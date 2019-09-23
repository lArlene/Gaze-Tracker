clear;
clc;
A = 1;
Fs = 400000;  %sampling rate 400KHZ
t = 0:1/Fs:0.001-1/Fs; %1ms each
x = 0:1/Fs:0.02 - 1/Fs; %20ms

ya = chirp(t,16000,0.001,23000);
yb = chirp(t,23000,0.001,16000);
ya = ya .* A.*sin(1000*pi*t);
yb = yb .* A.*sin(1000*pi*t);
ya = [ya,zeros(1,7600)];
yb = [zeros(1,400),yb,zeros(1,7200)];

YA = ya;
YB = yb;

for(a= 1:99)
    YA = [YA,ya];
    YB = [YB,yb];
end


figure(1),
subplot(2,1,1),
plot(x,ya),
axis([0,0.02,-2,2]),
xlabel('t/s'),
title('FMCW with 2 chirps of 16Khz to 23Khz'),
subplot(2,1,2),
plot(x,yb),
xlabel('t/s')
axis([0,0.02,-2,2]);
y = [YA',YB'];

audiowrite('doublechannel1.wav',y,Fs);
figure(2),
plot(y),
axis([0,80000,-1,1]);
% yad200 = ya(1:200:end);
% ybd200 = yb(1:200:end);
% yd200 = [ya,yb];
% figure(2)
% plot(yd200);