% PA Initial Visualization:
clc; close all; clearvars

load("data_struct.mat", "data_struct")

%% Components:

% Decompose the Chlorophyll data:
[Chlor_LT, Chlor_ST, Chlor_R] = trenddecomp(data_struct.chlorophyll_data);

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
hold on
plot(Chlor_R)
title("Chlorophyll Residual component")
hold off

% Decompose the Temperature data:
[Temp_LT, Temp_ST, Temp_R] = trenddecomp(data_struct.temperature_data);

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
hold on
plot(Temp_R)
title("Temperature Residual component")
hold off

% Decompose the Turbidity data:
[Turb_LT, Turb_ST, Turb_R] = trenddecomp(data_struct.turbidity_data);

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
hold on
plot(Turb_R)
title("Turbidity Residual component")
hold off

%% Timeseries visualization:

figure;
hold on
plot(data_struct.chlorophyll_date, data_struct.chlorophyll_data)
title("Chlorophyll concetration over time")
xlabel("Time")
ylabel("c (\mug/l)")
hold off

figure;
hold on
plot(data_struct.temperature_date, data_struct.temperature_data)
title("Lake temperature over time")
xlabel("Time")
ylabel("\theta \circC")
hold off

figure;
hold on
plot(data_struct.turbidity_date, data_struct.turbidity_data)
title("Turbidity of the lake over time")
xlabel("Time")
ylabel("FNU")
hold off

%% Check if each of the timeseries contain the same entries:

count = 0;

for i = 1:length(data_struct.temperature_date)
    if (data_struct.temperature_date(i) ~= data_struct.chlorophyll_date(i))
        count = count + 1;
        continue
    end
    if (data_struct.temperature_date(i) ~= data_struct.turbidity_date(i))
        count = count + 1;
        continue
    end
end

disp(count)

%% Check if there are missing values:
sum(isnan(data_struct.temperature_data), 'all')
sum(isnan(data_struct.chlorophyll_data), 'all')
sum(isnan(data_struct.turbidity_data), 'all')

sum(isnat(data_struct.temperature_date), 'all')
sum(isnat(data_struct.chlorophyll_date), 'all')
sum(isnat(data_struct.turbidity_date), 'all')

%% Check if all the timestamps exist:

time = data_struct.temperature_date(1);

missing_times = 0;
missing = datetime();

% Check if all the hours exist that should: 

% while time > data_struct.temperature_date(end)
%     outp = 0;
%     for i = 1:length(data_struct.temperature_date)
%         test = data_struct.temperature_date(i);
%         if ((year(time) == year(test)) && (month(time) == month(test)) ...
%                 && (hour(time) == hour(test)))
%             outp = 1;
%             break
%         end
%     end
%     if (~outp)
%         missing(end+1) = time;
%         missing_times = missing_times + 1;
%     end
%     time = time - hours(1);
% end

% Check if there are measurements that are taken off x:00:000 -times
qmtimes = datetime();

for i = 1:length(data_struct.temperature_date)
    test = data_struct.temperature_date(i);
    if ((minute(test) ~= 0)) % || (second(test) ~= 0))
        qmtimes(end+1) = test;
    end
end

% Check if there are b2b measurements on the same hour:
qmtimes1 = datetime();
qmtimes2 = datetime();
for i = 1:length(data_struct.temperature_date)-1
    test = data_struct.temperature_date(i);
    testn = data_struct.temperature_date(i+1);
    if (hour(test) == hour(testn))
        qmtimes1(end+1) = test;
        qmtimes2(end+1) = testn;
    end
end

%% Plot histograms:

figure;
hold on
title("Temperature distribution")
xlabel("Temperature")
ylabel("Frequency")
histogram(data_struct.temperature_data, 'Normalization', 'probability')
hold off

figure;
hold on
title("Turbidity distribution")
xlabel("Turbidity value")
ylabel("Frequency")
histogram(data_struct.turbidity_data, 'Normalization', 'probability')
hold off

figure;
hold on
title("Chlorophyll distribution")
xlabel("Chlorophyll consentration")
ylabel("Frequency")
histogram(data_struct.chlorophyll_data, 'Normalization', 'probability')
hold off

%% Categorize the values to seasons:

season = strings();
% Categorize the entries to seasons:
for i = 1:length(data_struct.temperature_date)
    test = data_struct.temperature_date(i);
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

norm_turb = normalize(data_struct.turbidity_data, "range");
norm_temp = normalize(data_struct.temperature_data, "range");
norm_chlr = normalize(data_struct.chlorophyll_data, "range");

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

%% Correlation check:

temp_turb_corr = corr(data_struct.turbidity_data, data_struct.temperature_data)
chlr_turb_corr = corr(data_struct.turbidity_data, data_struct.chlorophyll_data)
temp_chlr_corr = corr(data_struct.temperature_data, data_struct.chlorophyll_data)

%% Month distribution plots:

figure;
hold on
title("Turbidity values wrt. months")
xlabel("Turbidity")
ylabel("Month")
plot(month(data_struct.turbidity_date), data_struct.turbidity_data, 'r.')
hold off

figure;
hold on
title("Temperature values wrt. months")
xlabel("Temperature")
ylabel("Month")
plot(month(data_struct.temperature_date), data_struct.temperature_data, 'r.')
hold off

figure;
hold on
title("Chlorophyll values wrt. months")
xlabel("Chlorophyll")
ylabel("Month")
plot(month(data_struct.chlorophyll_date), data_struct.chlorophyll_data, 'r.')
hold off