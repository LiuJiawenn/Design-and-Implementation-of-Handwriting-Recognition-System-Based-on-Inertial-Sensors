function [ SmoothEner ] = Sumgyro( gyrodata )
Ener = cell(size(gyrodata));         %创建和gyrodata规格相同的cell类
SmoothEner = cell(size(gyrodata));
Size =30;   % 单个窗口大小  霍 win30,step10  
Step = 10;
for i=1:length(gyrodata) 
    % judge data size
    if(length(gyrodata{i}(1,:))==3)
        Ener{i} = Energy(gyrodata{i}); %求转角和
    end
% 将size格中的能量求和，每次移动10步。。。步数越大，平滑效果越好。
for k=1:Step:(length(Ener{i})-Size)
     SmoothEner{i}(k:k+Size) = mean(Ener{i}(k:k+Size)); % 
     
end
SmoothEner{i}=SmoothEner{i}';
% SmoothEner{i}=diff(SmoothEner1{i});
end
end


function [Ema] = Energy(data)
Ema = sum(abs(data),2);%2代表行求和，输出一个列向量
end
