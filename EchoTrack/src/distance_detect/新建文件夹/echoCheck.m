function [delay_up,delay_down] = echoCheck(dec_up,dec_down)

FS = 48000;
freqz_up = abs(fftshift(fft(dec_up)));    
freqz_down = abs(fftshift(fft(dec_down)));

% 18480/48000 = 0.385
L = length(freqz_up) * 0.385;
L = round(L);
freqz_up = [zeros(1,L),freqz_up(L :(length(freqz_up)-L)),zeros(1,L)];
freqz_down = [zeros(1,L),freqz_down(L :(length(freqz_down)-L)),zeros(1,L)];
shift = (-length(freqz_up)/2 + 1 : length(freqz_up) / 2) .* (FS / length(freqz_up));

 [pks1,locs1] = findpeaks(freqz_up,'minpeakheight',1000000);
 [pks2,locs2] = findpeaks(freqz_down,'minpeakheight',1000000);
 
 %plot test -----------------------------------------------   
if length(pks1) >= 4 && length(pks1) <= 10
    figure(100)
    subplot(2,1,2),
    plot(shift,freqz_up),
    xlabel('\omega/hz'),
    subplot(2,1,1),
    plot(dec_up),
    xlabel('t-s'),
end
%plot test -----------------------------------------------

 

 delay_up = 0;
  if length(pks1) < 4
      delay_up = -1;
  elseif length(pks1) == 4
      delay_up = shift(locs1(4)) - shift(locs1(3));
  else 
      %default second highest peak is nearest to highest peak
      %default no peak between highest peak
      first_peak = ceil(length(pks1)/2 + 1);
      second_peak = first_peak + 1;
      second_height = pks1(second_peak);
      for j = first_peak + 1 : length(pks1)
          if pks1(j) > second_height
              second_peak = j;
              second_height = pks1(j);
          end
      end
      delay_up = shift(locs1(second_peak) ) - shift(locs1(first_peak));
  end
          
 delay_down = 0;
  if length(pks2) < 4
      delay_down = -1;
  elseif length(pks2) == 4
      delay_down = shift(locs2(4)) - shift(locs2(3));
  else 
      %default second highest peak is nearest to highest peak
      %default no peak between highest peak
      first_peak = ceil(length(pks2)/2 + 1);
      second_peak = first_peak + 1;
      second_height = pks2(second_peak);
      for j = first_peak + 1 : length(pks2)
          if pks2(j) > second_height
              second_peak = j;
              second_height = pks2(j);
          end
      end
      delay_down = shift(locs2(second_peak) ) - shift(locs2(first_peak));
  end


 

end