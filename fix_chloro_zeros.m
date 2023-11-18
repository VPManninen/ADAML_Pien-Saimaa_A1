%% Chlorophyll 0's treatment
clc; close all; clearvars

load("data_treated.mat");

figure;
plot(data_treated.time, data_treated.chlorophyll)


%% Find the times where the 0's are

ind = find(data_treated.chlorophyll == 0);

% Based on the above, the indiced 13000+ are all 0's

fix_ind = [13000:length(data_treated.time)];

times = data_treated.time(fix_ind);

% Find the same dates on the next year:

indices = zeros(size(data_treated.time));

% Next year
min_time = min(times);
max_time = max(times);

% Reference indices
ref_ind = [4240:8238]; % checked by hand

% Check the times:
fix_times = data_treated.time(fix_ind);
ref_times = data_treated.time(ref_ind);

% Get the data:
Ytrain = data_treated.chlorophyll(ref_ind);
Xtrain = [data_treated.temperature(ref_ind);
    data_treated.turbidity(ref_ind)];

% Make the fix X:
Xfix = [data_treated.temperature(fix_ind);
    data_treated.turbidity(fix_ind)];

%% PLS:
[P , T, Q, U, beta, var, MSE, stats] ...
        = plsregress(Xtrain', Ytrain', 2);


% Fitted values:
Ytrain_fit = [ones(length(Ytrain), 1), Xtrain'] * beta;
Yfix = [ones(length(Ytrain), 1), Xfix'] * beta;

% Plot tests
figure;
hold on
plot(data_treated.time(ref_ind), data_treated.chlorophyll(ref_ind))
plot(data_treated.time(ref_ind), Ytrain_fit, 'r')
title("Measured Chlorophyll vs PLS Chlorophyll")
hold off

% Plot tests

fixed_chloro = data_treated.chlorophyll;
fixed_chloro(fix_ind) = Yfix';

figure;
hold on
plot(data_treated.time, fixed_chloro, 'r')
title("PLS augmented Chlorophyll time-series")
hold off

%% save the data:

data_treated_pls = data_treated;
data_treated_pls.chlorophyll = fixed_chloro;

save("data_treated_pls.mat", "data_treated_pls")