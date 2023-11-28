clc; close all; clearvars
% This function removes the outliers and performs the normalization:
load('data_treated_pls.mat');

% Data extraction:
trueTime = data_treated_pls.time;
turb = data_treated_pls.turbidity;
temp = data_treated_pls.temperature;
chlr = data_treated_pls.chlorophyll;

% Normalization:
turbN = normalize(turb);
tempN = normalize(temp);
chlrN = normalize(chlr);

% Extract the residual components:
[Ttu, Stu, Rtu] = trenddecomp(turbN);
[Tte, Ste, Rte] = trenddecomp(tempN);
[Tch, Sch, Rch] = trenddecomp(chlrN);

% Compute the 3std limits:
stdTu = 3 * std(Rtu);
stdTe = 3 * std(Rte);
stdCh = 3 * std(Rch);

%% Plot:
figure;
hold on
title("Turbidity")
plot([0, length(trueTime)], [stdTu, stdTu], 'r')
plot([0, length(trueTime)], [-stdTu, -stdTu], 'r')
plot(Rtu, 'b.')
hold off

figure;
hold on
title("Temperature")
plot([0, length(trueTime)], [stdTe, stdTe], 'r')
plot([0, length(trueTime)], [-stdTe, -stdTe], 'r')
plot(Rte, 'b.')
hold off

figure;
hold on
title("Chlorophyll")
plot([0, length(trueTime)], [stdCh, stdCh], 'r')
plot([0, length(trueTime)], [-stdCh, -stdCh], 'r')
plot(Rch, 'b.')
hold off

%% Find the extreme point-wise residuals:

ext_tu = (Rtu > stdTu) | (Rtu < -stdTu);
ext_te = (Rte > stdTe) | (Rte < -stdTe);
ext_ch = (Rtu > stdCh) | (Rtu < -stdCh);

ext_tu_pw = zeros(size(ext_tu));
ext_ch_pw = zeros(size(ext_ch));
ext_te_pw = zeros(size(ext_te));

for i = 1:length(ext_tu_pw)
    switch (i)
        case 1
            ext_tu_pw(i) = (ext_tu(i) & ~ext_tu(i+1));
            ext_te_pw(i) = (ext_te(i) & ~ext_te(i+1));
            ext_ch_pw(i) = (ext_ch(i) & ~ext_ch(i+1));
        case length(ext_ch_pw)
            ext_tu_pw(i) = (ext_tu(i) & ~ext_tu(i-1));
            ext_te_pw(i) = (ext_te(i) & ~ext_te(i-1));
            ext_ch_pw(i) = (ext_ch(i) & ~ext_ch(i-1));
        otherwise
            ext_tu_pw(i) = (ext_tu(i) & (~ext_tu(i+1) & ~ext_tu(i-1)));
            ext_te_pw(i) = (ext_te(i) & (~ext_te(i+1) & ~ext_te(i-1)));
            ext_ch_pw(i) = (ext_ch(i) & (~ext_ch(i+1) & ~ext_ch(i-1)));
    end
end

[ext_tu_2] = find(ext_tu_pw == 1);
[ext_te_2] = find(ext_te_pw == 1);
[ext_ch_2] = find(ext_ch_pw == 1);

%% Interpolate:

% Time vectors:
cutTimeTu = trueTime;
cutTimeTe = trueTime;
cutTimeCh = trueTime;

cutTimeTu(ext_tu_2) = [];
cutTimeTe(ext_te_2) = [];
cutTimeCh(ext_ch_2) = [];

% Data vectors:
cutTurb = turb;
cutTurb(ext_tu_2) = [];
cutTemp = temp;
cutTemp(ext_te_2) = [];
cutChlr = chlr;
cutChlr(ext_ch_2) = [];

% Interpolate:
newTurb = interp1(cutTimeTu, cutTurb, trueTime);
newTemp = interp1(cutTimeTe, cutTemp, trueTime);
newChlr = interp1(cutTimeCh, cutChlr, trueTime);

%% Check the residuals:

% normalize:
newTurbN = normalize(newTurb);
newTempN = normalize(newTemp);
newChlrN = normalize(newChlr);

% Extract the residual components:
[Ttu2, Stu2, Rtu2] = trenddecomp(newTurbN);
[Tte2, Ste2, Rte2] = trenddecomp(newTempN);
[Tch2, Sch2, Rch2] = trenddecomp(newChlrN);

%%
% Compute the 3std limits:
stdTu2 = 3 * std(Rtu2);
stdTe2 = 3 * std(Rte2);
stdCh2 = 3 * std(Rch2);

figure;
hold on
title("Turbidity")
plot([0, length(trueTime)], [stdTu2, stdTu2], 'r')
plot([0, length(trueTime)], [-stdTu2, -stdTu2], 'r')
plot(Rtu2, 'b.')
hold off

figure;
hold on
title("Temperature")
plot([0, length(trueTime)], [stdTe2, stdTe2], 'r')
plot([0, length(trueTime)], [-stdTe2, -stdTe2], 'r')
plot(Rte2, 'b.')
hold off

figure;
hold on
title("Chlorophyll")
plot([0, length(trueTime)], [stdCh2, stdCh2], 'r')
plot([0, length(trueTime)], [-stdCh2, -stdCh2], 'r')
plot(Rch2, 'b.')
hold off

%% New datasets:

% Save the variables:
data_vectors_final = struct();
data_vectors_final.time = trueTime;
data_vectors_final.temperature_orig = temp;
data_vectors_final.temperature_remOut = newTemp;
data_vectors_final.turbidity_orig = turb;
data_vectors_final.turbidity_remOut = newTurb;
data_vectors_final.chlorophyll_orig = chlr;
data_vectors_final.chlorophyll_remOut = newChlr;
save("data_vectors_final.mat", "data_vectors_final");

% X and Y conversion:
X = [temp(1:end-1);
     turb(1:end-1);
     chlr(1:end-1)];
Y = chlr(2:end);

Xn = [newTemp(1:end-1);
     newTurb(1:end-1);
     newChlr(1:end-1)];
Yn = newChlr(2:end);

% Non-normalized origina data:
data_orig = struct();
data_orig.X = X;
data_orig.Y = Y;
data_orig.time = trueTime;
data_orig.info = 'Non-normalized regression X and Y with 1 ahead predictions of chlorophyll values, without outlier removal.';
data_orig.Xinfo = 'temperature, turbidity, chlorophyll, in order by row';
save("data_orig.mat", "data_orig");

% Non-normalized new data: 
data_new = struct();
data_new.X = Xn;
data_new.Y = Yn;
data_new.time = trueTime;
data_new.info = 'Non-normalized regression X and Y with 1 ahead predictions of chlorophyll values, with outlier removal.';
data_orig.Xinfo = 'temperature, turbidity, chlorophyll, in order by row';
save("data_new.mat", "data_new");
