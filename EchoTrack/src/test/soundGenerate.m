clc;
clear;
RATE = 48000;
[sound_r,sound_l] = chirpGeneration(48000,0.001,0.02,1000,1,0);
write = [sound_l',sound_r'];
plot(write)
audiowrite('doublechannel.wav',write,RATE);