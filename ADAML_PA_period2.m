% PA data loading
close all, clear, clc

addpath('data/')

% Read each data file into a struct form:
filename = 'chlorophyll_data_2023_06_11-2022_10_28.txt';
fid = fopen(filename);
raw = fread(fid,inf);
str = char(raw');
fclose(fid);
data_chlorophyll = jsondecode(str);

filename2 = 'temperature_data_2023_06_11-2022_10-28';
[filename2, pathname2] = uigetfile('temperature_data_2023_06_11-2022_10-28.txt');
fid2 = fopen(fullfile(pathname2,filename2),'r');
raw2 = fread(fid2,inf);
str2 = char(raw2');
fclose(fid2);
data_temperature = jsondecode(str2);

filename3 = 'turbidity_data_2023_06_11-2022_10_28.txt';
fid3 = fopen(filename3);
raw3 = fread(fid3,inf);
str3 = char(raw3');
fclose(fid3);
data_turbidity = jsondecode(str3);
