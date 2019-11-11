function  [output] = matchFilter (recievedSig, originalSig)
%notice the length of rSig and oSig is same in 30ms
s = fft(recievedSig);
p = fft(originalSig);
p = real(p) - imag(p); %conjugate
freqZ = p .* s; %reference the formula
% freqZ = [zeros(1,length(freqZ)/2), 2.*freqZ(length(freqZ)/2:length(freqZ))];
% for i = 1 : length(freqZ)
%     try to use Z function however fail
% end

output = ifft(freqZ);
output = real(output);