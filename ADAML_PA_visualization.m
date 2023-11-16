% PA Initial Visualization:
clc; close all; clearvars

load("data_treated.mat", "data_treated")

%% Components:

% Decompose the Chlorophyll data:
[Chlor_LT, Chlor_ST, Chlor_R] = trenddecomp(normalize(data_treated.chlorophyll));

% Plots
figure;
subplot(3, 1, 1)
hold on
plot(Chlor_LT)
title("Chlorophyll trend component")
hold off

subplot(3, 1, 2)
hold on
plot(Chlor_ST)
title("Chlorophyll Seasonal component")
hold off

subplot(3, 1, 3)
figure
hold on
plot(Chlor_R)
sC = std(Chlor_R);
plot([1, 16998],[2*sC, 2*sC], 'r')
plot([1, 16998], [3*sC, 3*sC], 'g')
plot([1, 16998],[-2*sC, -2*sC], 'r')
plot([1, 16998], [-3*sC, -3*sC], 'g')
title("Chlorophyll Residual component")
hold off

% Decompose the Temperature data:
[Temp_LT, Temp_ST, Temp_R] = trenddecomp(normalize(data_treated.temperature));

% Plots
figure;
subplot(3, 1, 1)
hold on
plot(Temp_LT)
title("Temperature trend component")
hold off

subplot(3, 1, 2)
hold on
plot(Temp_ST)
title("Temperature Seasonal component")
hold off

subplot(3, 1, 3)
figure
hold on
plot(Temp_R)
sT = std(Temp_R);
plot([1, 16998],[2*sT, 2*sT], 'r')
plot([1, 16998], [3*sT, 3*sT], 'g')
plot([1, 16998],[-2*sT, -2*sT], 'r')
plot([1, 16998], [-3*sT, -3*sT], 'g')
title("Temperature Residual component")
hold off

% Decompose the Turbidity data:
[Turb_LT, Turb_ST, Turb_R] = trenddecomp(normalize(data_treated.turbidity));

% Plots
figure;
subplot(3, 1, 1)
hold on
plot(Turb_LT)
title("Turbidity trend component")
hold off

subplot(3, 1, 2)
hold on
plot(Turb_ST)
title("Turbidity Seasonal component")
hold off

subplot(3, 1, 3)
figure
hold on
plot(Turb_R)
sTu = std(Turb_R);
plot([1, 16998],[2*sTu, 2*sTu], 'r')
plot([1, 16998], [3*sTu, 3*sTu], 'g')
plot([1, 16998],[-2*sTu, -2*sTu], 'r')
plot([1, 16998], [-3*sTu, -3*sTu], 'g')
title("Turbidity Residual component")
hold off

%% Timeseries visualization:

figure;
hold on
plot(data_treated.time, data_treated.chlorophyll)
title("Chlorophyll concetration over time")
xlabel("Time")
ylabel("c (\mug/l)")
hold off

figure;
hold on
plot(data_treated.time, data_treated.temperature)
title("Lake temperature over time")
xlabel("Time")
ylabel("\theta \circC")
hold off

figure;
hold on
plot(data_treated.time, data_treated.turbidity)
title("Turbidity of the lake over time")
xlabel("Time")
ylabel("FNU")
hold off

%% Plot histograms:

figure;
hold on
title("Temperature distribution")
xlabel("Temperature")
ylabel("Frequency")
histogram(data_treated.temperature, 'Normalization', 'probability')
hold off

figure;
hold on
title("Turbidity distribution")
xlabel("Turbidity value")
ylabel("Frequency")
histogram(data_treated.turbidity, 'Normalization', 'probability')
hold off

figure;
hold on
title("Chlorophyll distribution")
xlabel("Chlorophyll consentration")
ylabel("Frequency")
histogram(data_treated.chlorophyll, 'Normalization', 'probability')
hold off

%% Categorize the values to seasons:

season = strings();
% Categorize the entries to seasons:
for i = 1:length(data_treated.temperature)
    test = data_treated.time(i);
    if (ismember(month(test), [12, 1, 2]))
        season(i) = 'Winter';
    elseif (ismember(month(test), [3, 4, 5]))
        season(i) = 'Spring';
    elseif (ismember(month(test), [6, 7, 8]))
        season(i) = 'Summer';
    elseif (ismember(month(test), [9, 10, 11]))
        season(i) = 'Autumn';
    end
end

%% Normalized seasons plots:

norm_turb = normalize(data_treated.turbidity, "range");
norm_temp = normalize(data_treated.temperature, "range");
norm_chlr = normalize(data_treated.chlorophyll, "range");

figure;
hold on
title("Turbidity vs Temperature grouped by seasons")
xlabel("Turbidity")
ylabel("Temperature")
gscatter(norm_turb, norm_temp, season', 'bmrk')
hold off

figure;
hold on
title("Turbidity vs Chlorophyll grouped by seasons")
xlabel("Turbidity")
ylabel("Chlorophyll")
gscatter(norm_turb, norm_chlr, season', 'bmrk')
hold off

figure;
hold on
title("Chlorophyll vs Temperature grouped by seasons")
xlabel("Chlorophyll")
ylabel("Temperature")
gscatter(norm_chlr, norm_temp, season', 'bmrk')
hold off

%%
sum(isnan(data_treated.temperature), 'all')
sum(isnan(data_treated.chlorophyll), 'all')
sum(isnan(data_treated.turbidity), 'all')

sum(isnat(data_treated.time), 'all')

%% Correlation check:

temp_turb_corr = corr(data_treated.turbidity', data_treated.temperature')
chlr_turb_corr = corr(data_treated.turbidity', data_treated.chlorophyll')
temp_chlr_corr = corr(data_treated.temperature', data_treated.chlorophyll')

%% Month distribution plots:

figure;
hold on
title("Turbidity values wrt. months")
xlabel("Turbidity")
ylabel("Month")
plot(month(data_treated.time), data_treated.turbidity, 'r.')
hold off

figure;
hold on
title("Temperature values wrt. months")
xlabel("Temperature")
ylabel("Month")
plot(month(data_treated.time), data_treated.temperature, 'r.')
hold off

figure;
hold on
title("Chlorophyll values wrt. months")
xlabel("Chlorophyll")
ylabel("Month")
plot(month(data_treated.time), data_treated.chlorophyll, 'r.')
hold off