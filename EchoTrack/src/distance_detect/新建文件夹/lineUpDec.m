function [max_t] = lineUpDec(data,chirp_ref)

FS = 48000;
peak_line_up = 9000;
chirp_ref = [chirp_ref, zeros(1,length(data) - length(chirp_ref))];
time_interval = 0.002;
step = FS * time_interval;
t = -time_interval;
max_t = -1;

while(true)
    t = t + time_interval;
    if (t * FS) >= length(data)
        break
    end    

    dec = chirp_ref .* data;
   
    partA = chirp_ref(length(chirp_ref) - step + 1 : length(chirp_ref));
    partB = chirp_ref(1:length(chirp_ref) - step);
    chirp_ref = [partA,partB];
    
    
%     if t  < 1e-7 + 0.002
%         figure(100)
%         plot(chirp_ref)
%     end  
    
    
    freqz = abs(fftshift(fft(dec)));
    [pks,locs] = findpeaks(freqz,'minpeakheight',2000000);
    if (isempty(locs)) %length
        continue
    end
    max_peak = 0;
    max_i = 1;
    for m = 1 : length(pks)
        if pks(m) > max_peak
            max_peak = pks(m);
            max_i = m;
        end
    end
        
    shift = (-length(dec)/2 + 1 : length(dec) / 2) .* (FS / length(dec));
    % if the up dechirp is by down chirp
    if abs(shift(locs(max_i))) > 9000 +10e7
%         peak = pks(max_i)
        continue
    end
    
    crt_x = shift(locs(max_i));
    if abs(crt_x) <= peak_line_up
        peak_line_up = abs(crt_x);
        max_t = t;
    else 
        break
    end   
end