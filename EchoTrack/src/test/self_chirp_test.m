clear;
clc;
FS = 48000;
t = 0: 1/FS: 0.02; 
% basic chirp parameter with length 20ms
f0 = 16000;
f1 = 23000;
u0 = (f1 - f0) / 0.02;
phase1 = f0 * t + 0.5 * u0 * t .* t;
phase2 = f1 * t - 0.5 * u0 * t .* t;
chirp1 = cos(2 * pi * phase1);
chirp2 = cos(2 * pi * phase2);
% modulate in time domain
chirp1 = chirp1 .* 100 .* sin(50*pi*t);
chirp2 = chirp2 .* 100 .* sin(50*pi*t);
% after channel with time delay 10ms and gauss white noise
chirp_ref = [chirp1,zeros(1,240)];
chirp_rec = [zeros(1,240),chirp1];
% white_noise = wgn(1,length(chirp_rec),30);
% chirp_rec = chirp_rec + white_noise;

% apply dechirp and match filter respectively
de_chirp = chirp_rec.*chirp_ref;
% [b,a] = butter(8,[8000 10000]/(FS/2));
% de_chirp = filter(b,a,de_chirp);
ma_chirp = matchFilter(chirp_rec,chirp_ref);
% plot
shift = (-length(de_chirp)/2 + 1 : length(de_chirp) / 2) .* (FS / length(de_chirp)); 
xt = 0 : 1/FS : length(de_chirp)/FS - 1/FS;
figure(1)
subplot(2,1,1)
plot(xt,chirp_rec)
subplot(2,1,2)
plot(xt,chirp_ref);
figure(2),
subplot(2,1,1)
plot(shift,abs(fftshift(fft(de_chirp))));
subplot(2,1,2)
plot(xt,de_chirp);
figure(3),
subplot(2,1,1)
plot(shift,abs(fftshift(fft(ma_chirp))));
subplot(2,1,2)
plot(xt,ma_chirp)

% Before we reach an acceptable result on single chirp self detection
% now we test when there are 2 chirp, how they work
len = length(chirp1);
chirp_rec = [zeros(1,length(chirp1)),chirp1,chirp2];
chirp1_ref = [chirp1,chirp1,chirp1];
chirp2_ref = [chirp2,chirp2,chirp2];
chirp1_ori = [chirp1,zeros(1,length(chirp_rec) - len)];
chirp2_ori = [zeros(1,len),chirp2, zeros(1,length(chirp_rec) - len * 2)];
figure(10)
subplot(3,1,1), plot(chirp_rec),
subplot(3,1,2), plot(chirp1_ref),
subplot(3,1,3), plot(chirp2_ref);
%match and dechirp
ma_chirp1 = matchFilter(chirp_rec,chirp1_ori);
ma_chirp2 = matchFilter(chirp_rec,chirp2_ori);
de_chirp1 = chirp_rec.*chirp1_ref;
de_chirp2 = chirp_rec.*chirp2_ref;
%plot
shift = (-length(de_chirp1)/2 + 1 : length(de_chirp1) / 2) .* (FS / length(de_chirp1)); 
xt = 0 : 1/FS : length(de_chirp1)/FS - 1/FS;
figure(11),
subplot(2,2,1)
plot(shift,abs(fftshift(fft(de_chirp1))));
subplot(2,2,3)
plot(xt,de_chirp1);
subplot(2,2,2)
plot(shift,abs(fftshift(fft(de_chirp2))));
subplot(2,2,4)
plot(xt,de_chirp2);
figure(12),
subplot(2,2,1)
plot(shift,abs(fftshift(fft(ma_chirp1))));
subplot(2,2,3)
plot(xt,ma_chirp1);
subplot(2,2,2)
plot(shift,abs(fftshift(fft(ma_chirp2))));
subplot(2,2,4)
plot(xt,ma_chirp2);

% simulate = [chirp1,chirp2,zeros(1,length(t))];
% simulate = [simulate,simulate,simulate,simulate,simulate];
% simulate = [zeros(1,(length(t)-1)/2), simulate];
% chirp_ref1 = [];chirp_ref2 = [];
% while(true)
%     if (length(chirp_ref1) >= length(simulate))
%           break
%     else 
%         chirp_ref1 = [chirp_ref1,chirp1];
%         chirp_ref2 = [chirp_ref2,chirp2];
%     end
% end
% chirp_ref1 = chirp_ref1(1 : length(simulate));
% chirp_ref2 = chirp_ref2(1 : length(simulate));
% dec1 = simulate .* chirp_ref1;
% dec2 = simulate .* chirp_ref2;
% % dec1 = dechirp(simulate', chirp_ref1');
% % dec2 = dechirp(simulate', chirp_ref2');
% [b,a] = butter(8,[16000 23000]/(48000/2));
% r1 = filter(b,a,dec1);
% r2 = filter(b,a,dec2);
% figure(2)
% subplot(2,1,1)
% plot(r1)
% subplot(2,1,2)
% plot(chirp_ref1);
% 
% figure(3)
% subplot(3,1,1)
% plot(r1)
% subplot(3,1,2)
% plot(r2);
% subplot(3,1,3)
% plot(simulate);

