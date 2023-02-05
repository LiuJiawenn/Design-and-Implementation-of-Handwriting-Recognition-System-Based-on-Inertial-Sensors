function [SensorData] = SensorRead(path) % Str
%读取声音文件中的数据
SensorData = [];
Count=0;
sensorFile = dir([path '*FastAccGyro.txt']);
n = length(sensorFile); %获取此文件夹FastAccGyro.txt的个数
for i = 1:n
    SensorData{Count+i} = dlmread([path sensorFile(i).name]); % 传感器数据，几个txt就建几个cell
end
Count = Count + i;
end