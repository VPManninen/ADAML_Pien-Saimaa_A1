% PA data loading
close all, clear, clc

% Loading the data from internet (provided by Zina-Sabrina Duma)

% chlorophyll data
today = '2023-11-06T00:00:00Z';
lastTime = today(1:end-1);
chlorophyll_data = [];
chlorophyll_date = [];
currentYear = 2023;
while currentYear > 2021
    url         = strcat('https://paikkatieto.ymparisto.fi/proxy/proxy.ashx?https://ehp.tarkkaapi.syke.fi/v2/units/39175/data/?end=',lastTime,'&start2021-01-01T00:00:00.000');
    newData     = webread(url);
    lastTime    = newData.results(end).timestamp(1:end-1);

    chlorophyll_data = [chlorophyll_data; [newData.results.value]'];

    for ii = 1:1000
        chlorophyll_date = [chlorophyll_date; newData.results(ii).timestamp(1:end-1)];
    end

    currentYear = year(datetime(lastTime, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss'));
end
% Plot
chlorophyll_date = datetime(chlorophyll_date, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss');
figure;
plot(chlorophyll_date,chlorophyll_data);
ylabel('Lake Chlorophyll')


% temperature data
lastTime = today(1:end-1);
temperature_data = [];
temperature_date = [];
currentYear = 2023;
while currentYear > 2021
    url         = strcat('https://paikkatieto.ymparisto.fi/proxy/proxy.ashx?https://ehp.tarkkaapi.syke.fi/v2/units/31986/data/?end=',lastTime,'&start2021-01-01T00:00:00.000');
    newData     = webread(url);
    lastTime    = newData.results(end).timestamp(1:end-1);

    temperature_data = [temperature_data; [newData.results.value]'];

    for ii = 1:1000
        temperature_date = [temperature_date; newData.results(ii).timestamp(1:end-1)];
    end

    currentYear = year(datetime(lastTime, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss'));
end
% Plot
temperature_date = datetime(temperature_date, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss');
figure;
plot(temperature_date,temperature_data);
ylabel('Lake Temperature')


% turbidity data
lastTime = today(1:end-1);
turbidity_data = [];
turbidity_date = [];
currentYear = 2023;
while currentYear > 2021
    url         = strcat('https://paikkatieto.ymparisto.fi/proxy/proxy.ashx?https://ehp.tarkkaapi.syke.fi/v2/units/7474/data/?end=',lastTime,'&start2021-01-01T00:00:00.000');
    newData     = webread(url);
    lastTime    = newData.results(end).timestamp(1:end-1);

    turbidity_data = [turbidity_data; [newData.results.value]'];

    for ii = 1:1000
        turbidity_date = [turbidity_date; newData.results(ii).timestamp(1:end-1)];
    end

    currentYear = year(datetime(lastTime, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss'));
end
% Plot
turbidity_date = datetime(turbidity_date, 'InputFormat', 'yyyy-MM-dd''T''HH:mm:ss');
figure;
plot(turbidity_date,turbidity_data);
ylabel('Lake Turbidity')

data_struct = struct();
data_struct.chlorophyll_data = chlorophyll_data;
data_struct.chlorophyll_date = chlorophyll_date;
data_struct.temperature_data = temperature_data;
data_struct.temperature_date = temperature_date;
data_struct.turbidity_data = turbidity_data;
data_struct.turbidity_date = turbidity_date;

save("data_struct.mat", "data_struct")