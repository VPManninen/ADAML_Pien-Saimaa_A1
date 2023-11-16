% PA Pre-processing:
clc; close all; clearvars

load("data_struct.mat", "data_struct")

%% Check if each of the timeseries contain the same entries:

count = 0;

% note that datetime includes also the time
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

% no missing values (NaN)
%% Check if all the timestamps exist:

time = data_struct.temperature_date(1);

% mark in this vector if some time value is off from even hour
off_time = zeros(size(data_struct.temperature_date));
for i = 1:length(off_time)
    time = data_struct.temperature_date(i);
    if (minute(time) ~= 0) % mark 8 if the minutes are off from 00
        off_time(i) = 8;
    elseif (second(time) ~= 0) % mark 7 if the seconds are off from 00
        off_time(i) = 7;
    else
        off_time(i) = 3; % if minutes and seconds are 00:00
    end
end

% find the indices from the original dataset which are minutes off from even hour
minutes_off_ind = (find(off_time == 8));
% find the original values where the timestamp is wrong by some minutes
minutes_off_og = data_struct.temperature_date(minutes_off_ind);

% index vector to see how many of the 'wrong' timestamp measures are extra
extra_measures = zeros(size(minutes_off_og));

% if there is measurement in the same hour as the minutes off measure, the
% measurement is definetely extra measurement
for j = 1:length(minutes_off_og)
    test = minutes_off_og(j);
    for k = 1:length(off_time)
        time = data_struct.temperature_date(k);
        if (k == minutes_off_ind(j))
            continue
        elseif ((year(test) == year(time)) && (month(test) == month(time)) && (day(test) == day(time)) && (hour(test) == hour(time)))
            extra_measures (j) = 1;
        end
    end
end

% find what are the indices that are extra and delete them
ind_del = minutes_off_ind(find(extra_measures == 1));
% delete the extra measures from the data (datapoint and date)
data_struct.temperature_date(ind_del) = [];
data_struct.temperature_data(ind_del) = [];

data_struct.turbidity_date(ind_del) = [];
data_struct.turbidity_data(ind_del) = [];

data_struct.chlorophyll_date(ind_del) = [];
data_struct.chlorophyll_data(ind_del) = [];

% if the measurement is off +-5 minutes from the even hour, it is
% considered as extra, if not it is considered as the right measurement and
% it is corrected to be hh:00:00 form. Since the data is measured from the
% lake Saimaa, we can say that the values does not change rapidly and we
% can use values that are in 10minutes time frame.
new_time = datetime();
for j = 1:length(data_struct.temperature_date)
    time = data_struct.temperature_date(j);
    if (minute(time) < 30) % if the minute value is in range [0,5]
        new_time(j) = time - seconds(second(time)) - minutes(minute(time));
    elseif (minute(time) >= 30) % if the minute value is in range [55,60]
        new_time(j) = time + seconds(60 - second(time)) + minutes(60 - minute(time));
    end
end
new_time = new_time';
%% Interpolating the missing values to the dataset
% make a vector with all the time values
all_times = (new_time(1):-hours(1):new_time(end));

% interpolate the missing time stamps and measurement values
% this method will work since there are mostly only one missing value at a
% time and it is so small part of the whole dataset
temperature_interp = interp1(new_time, data_struct.temperature_data, all_times, "spline");
turbidity_interp = interp1(new_time, data_struct.turbidity_data, all_times, "spline");
chlorophyll_interp = interp1(new_time, data_struct.chlorophyll_data, all_times, "spline");

% create a new struct for the treated data and save it
data_treated = struct();
data_treated.time = all_times;
data_treated.temperature = temperature_interp';
data_treated.turbidity = turbidity_interp';
data_treated.chlorophyll = chlorophyll_interp';

save('data_treated.mat', "data_treated")
%% 
% plot the figures to see that the interpolated results do not differ from
% the original measurements lot
figure
subplot(3,1,1)
plot(all_times, temperature_interp)
hold on
subplot(3,1,2)
plot(all_times, turbidity_interp)
subplot(3,1,3)
plot(all_times, chlorophyll_interp)








