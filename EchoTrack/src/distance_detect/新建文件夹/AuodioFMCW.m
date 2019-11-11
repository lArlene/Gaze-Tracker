clear;
clc;
Fs = 48000;  %sampling rate 48KHZ
t = 0: 1/Fs :0.02 - 1/Fs; %20ms each
x = 0: 1/Fs :0.06 - 1/Fs; %20ms in mid

%generate basic chirp
ya = chirp(t,16000,0.02,23000);
yb = chirp(t,23000,0.02,16000);
ya = ya .* 10 .* sin(50*pi*t);
yb = yb .* 10 .* sin(50*pi*t);
%repetition and reference extracting
yaRef = [ya,ya,ya];
ybRef = [yb,yb,yb];
ya = [ya,zeros(1,2*length(t))];
yb = [zeros(1,length(t)),yb,zeros(1,length(t))];
figure(1),
subplot(2,1,1),
plot(x,ya),
axis([0,0.06,-20,20]),
xlabel('t/s'),
title('FMCW with 2 chirps of 16Khz to 23Khz'),
subplot(2,1,2),
plot(x,yb),
xlabel('t/s')
axis([0,0.06,-20,20]);
YA = 0;
YB = 0;
for i = 1 : 100
    YA = [YA, ya];
    YB = [YB, yb];
end
y = [YA',YB'];
figure(2),
plot(y);


filename = ('DCChirp480.wav');
% audiowrite(filename,y,Fs);

% simulating dechirp on original chirp

deya = dechirp([ya',yb'],yaRef');
figure(3)
plot(x,deya),
xlim([0,0.06]),
xlabel('t/s');

YARef = []; YBRef = [];
for i = 1 : 100
    YARef = [YARef, yaRef];
    YBRef = [YBRef, ybRef];
end
y = y';
y = y(1:1,1:288000) + y(2:2,1:288000);
% y = y(1:2,1:288000);
% deYA = dechirp(y',YARef');
% deYB = dechirp(y',YBRef');
deYA = y.*YARef;
deYB = y.*YBRef;

shift = (-length(deYA)/2 + 1 : length(deYA) / 2) .* (Fs / length(deYA)); 
figure(10),
subplot(3,1,1)
plot(deYA)
subplot(3,1,2)
plot(shift,abs(fftshift(fft(deYA))));
subplot(3,1,3)
plot(YARef)
shift1 = (-length(y)/2 + 1 : length(y) / 2) .* (Fs / length(y)); 
figure(11),
subplot(2,1,1)
plot(y)
subplot(2,1,2)
plot(shift1,abs(fft
shift(fft(y))));

[b,a] = butter(8,[23000 46000]/(48000/2));
deYA = filter(b,a,deYA);
deYB = filter(b,a,deYB);

figure(4)
subplot(3,1,1),
plot(deYA(1:1,:)),
hold on   
plot(deYA(2:2,:))
subplot(3,1,2),
plot(deYB(1:1,:)),
hold on   
plot(deYB(2:2,:))
subplot(3,1,3),
plot(y(1:1,:)),
hold on   
plot(y(2:2,:))