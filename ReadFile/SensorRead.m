function [SensorData] = SensorRead(path) % Str
%��ȡ�����ļ��е�����
SensorData = [];
Count=0;
sensorFile = dir([path '*FastAccGyro.txt']);
n = length(sensorFile); %��ȡ���ļ���FastAccGyro.txt�ĸ���
for i = 1:n
    SensorData{Count+i} = dlmread([path sensorFile(i).name]); % ���������ݣ�����txt�ͽ�����cell
end
Count = Count + i;
end