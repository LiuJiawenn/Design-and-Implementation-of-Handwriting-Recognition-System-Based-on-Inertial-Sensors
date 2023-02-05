%% Letters_cutSignal只有切割位置标记，这里将切割好的数据放入数组
function [outSmoothEner,outgyroData,outlinearData] = StorLetters(SmoothEner,gyrodata,lineardata,Letters_cutSignal )
%{
figure;
subplot(1,1,1);
title("字母’A‘原始陀螺仪信号 ",'FontSize',30);
axis tight;set(gca,'FontSize',30);set(gca, 'LineWidth',1);
xlabel('Sampling point','FontSize',30,'Fontname', 'Times New Roman');ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');
set(gca,'FontSize',30);
set(gca, 'LineWidth',1.25);
% 画原始陀螺仪
hold on;p5=plot(gyrodata{1}(Letters_cutSignal{1}(1,1):Letters_cutSignal{1}(1,2),1:3));%陀螺仪数据
%}
%% 根据切割点，取出单词序列
outgyroData = cell(length(Letters_cutSignal),1);%陀螺仪
outlinearData= cell(length(Letters_cutSignal),1);%线性加速度
outSmoothEner= cell(length(Letters_cutSignal),1);%陀螺仪三轴转角和
for i=1:length(Letters_cutSignal)
    for j=1:length(Letters_cutSignal{i})
        outgyroData{i}{j} = gyrodata{i}(Letters_cutSignal{i}(j,1):Letters_cutSignal{i}(j,2),:);
        outlinearData{i}{j} = lineardata{i}(Letters_cutSignal{i}(j,1):Letters_cutSignal{i}(j,2),:);
        outSmoothEner{i}{j} = SmoothEner{i}(Letters_cutSignal{i}(j,1):Letters_cutSignal{i}(j,2),:);
    end    
end


%% 每个单词前后各补200个0
for i= 1:length(outSmoothEner)
for j= 1:length(outSmoothEner{i})

    SmoothE{i}{j}(1:200,1)=0;
    SmoothE{i}{j}(201:200+length(outSmoothEner{i}{j}),1)=outSmoothEner{i}{j}(:,1);
    outSmoothEner{i}{j}= SmoothE{i}{j};
    GyroD{i}{j}(1:200,1:3)=0;
    GyroD{i}{j}(201:200+length(outgyroData{i}{j}),1:3)=outgyroData{i}{j}(:,1:3);
    outgyroData{i}{j}=GyroD{i}{j};
    LinearD{i}{j}(1:200,1:3)=0;
    LinearD{i}{j}(201:200+length(outlinearData{i}{j}),1:3)=outlinearData{i}{j}(:,1:3);
    outlinearData{i}{j}=LinearD{i}{j};

    outSmoothEner{i}{j}(length(outSmoothEner{i}{j})+1:length(outSmoothEner{i}{j})+200,1)=0;
    outgyroData{i}{j}(length(outgyroData{i}{j})+1:length(outgyroData{i}{j})+200,1:3)=0;
    outlinearData{i}{j}(length(outlinearData{i}{j})+1:length(outlinearData{i}{j})+200,1:3)=0;   
end
end

end

