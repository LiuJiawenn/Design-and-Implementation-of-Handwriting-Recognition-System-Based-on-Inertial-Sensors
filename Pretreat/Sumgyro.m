function [ SmoothEner ] = Sumgyro( gyrodata )
Ener = cell(size(gyrodata));         %������gyrodata�����ͬ��cell��
SmoothEner = cell(size(gyrodata));
Size =30;   % �������ڴ�С  �� win30,step10  
Step = 10;
for i=1:length(gyrodata) 
    % judge data size
    if(length(gyrodata{i}(1,:))==3)
        Ener{i} = Energy(gyrodata{i}); %��ת�Ǻ�
    end
% ��size���е�������ͣ�ÿ���ƶ�10������������Խ��ƽ��Ч��Խ�á�
for k=1:Step:(length(Ener{i})-Size)
     SmoothEner{i}(k:k+Size) = mean(Ener{i}(k:k+Size)); % 
     
end
SmoothEner{i}=SmoothEner{i}';
% SmoothEner{i}=diff(SmoothEner1{i});
end
end


function [Ema] = Energy(data)
Ema = sum(abs(data),2);%2��������ͣ����һ��������
end
