function [X,Y] = distantCalculate(delay_up,delay_down)
% distance = frequency / 350000(hz/s) * 340m/s
distant_d1 = delay_up * 34 / 35000;
distant_d2 = delay_down * 34 / 35000;
dSlM = 0.135;
dSrM = 0.035;
dSlHM = distant_d1 + dSlM;
dSrHM = distant_d2 + dSrM;

dSrH = dSrHM .* dSrHM - dSrM * dSrM;
dSrH = dSrH * 0.5 ./ dSrHM;

dSlH = dSlHM - dSrHM;
dSlH = dSlH + dSrH;

X = dSrH;
Y = dSlH;

    for j = 2 : length(X)
        if abs(X(j)) > 1 || (X(j)) < 0.001
            X(j) = X(j-1);
        end
        if abs(Y(j)) > 1 || abs(Y(j)) < 0.001
            Y(j) = Y(j-1);
        end
    end
end
