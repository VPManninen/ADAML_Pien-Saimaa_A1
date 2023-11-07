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

    currentYear = year(datetime(lastTime));
end
% Plot
chlorophyll_date = datetime(chlorophyll_date);
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

    currentYear = year(datetime(lastTime));
end
% Plot
temperature_date = datetime(temperature_date);
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

    currentYear = year(datetime(lastTime));
end
% Plot
turbidity_date = datetime(turbidity_date);
figure;
plot(turbidity_date,turbidity_data);
ylabel('Lake Turbidity')
