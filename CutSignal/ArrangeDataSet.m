%%  对每个单词的单个字母进行处理，优化切割
%输入为切割好的单词的字母，先求转角和：sum(abs(data),2),在对能量进行平滑操作
%将转角和进行短时傅里叶变化，转换到频域，来找到字母的切割点，获取更精确地字母曲线图

function [maxlength,X_Set,Y_Set,Strokes_lable] = ArrangeDataSet(outgyroData,outlinearData)
%% 对单个字母的数据预处理
%对每个字母的两端进行补0，将采样点个数扩充到样本中最大采样点，用于后续LSTM
length1=[];

Strokes_gyrolinear = cell(1,length(outgyroData));
Strokes_lable = cell(1,length(outgyroData));
for i= 1:length(outgyroData)    
    for j= 1:length(outgyroData{i})
        for k= 1:length(outgyroData{i}{j})
            length1=[length1 length(outgyroData{i}{j}{k})];  
        end
    end
end
maxlength= max(length1); %求最大采样点数
maxlength = 225;

% 将陀螺仪，线性加速度放在组合成6维
for i= 1:length(outgyroData)
    for j= 1:length(outgyroData{i})
        for k= 1:length(outgyroData{i}{j})
            if(length(outgyroData{i}{j}{k})<maxlength)    %%小于统一长度补0   
                outgyroData{i}{j}{k}(length(outgyroData{i}{j}{k})+1:maxlength,1:3)=0;
                outlinearData{i}{j}{k}(length(outlinearData{i}{j}{k})+1:maxlength,1:3)=0;
            else                                          %%大于统一长度截取
                gyroData2{i}{j}{k}(:,1:3)=outgyroData{i}{j}{k}(1:maxlength,1:3);
                outgyroData{i}{j}{k}=gyroData2{i}{j}{k};
                linearData2{i}{j}{k}(:,1:3)=outlinearData{i}{j}{k}(1:maxlength,1:3);
                outlinearData{i}{j}{k}=linearData2{i}{j}{k};
            end
            Strokes_gyrolinear{i}{j}{k}(:,1:3)=outgyroData{i}{j}{k}(:,1:3);%将陀螺仪与线性加速度拼起来，组成6维
            Strokes_gyrolinear{i}{j}{k}(:,4:6)=outlinearData{i}{j}{k}(:,1:3);
            Strokes_lable{i}{j}{k}(1)=j;%第几个单词
            Strokes_lable{i}{j}{k}(2)=k;%单词的第几个字母
        end
    end
end

%%整理数据集
X_Set = [];
Y_Set = [];
layer =1;
for i= 1:length(Strokes_gyrolinear)
    for j= 1:length(Strokes_gyrolinear{i})
        for k= 1:length(Strokes_gyrolinear{i}{j})
            X_Set{layer} = Strokes_gyrolinear{i}{j}{k};
            layer = layer+1;
        end
    end
end

%m = [10,18,20,   10,11,   1,   10,12,   4,20,20,   10,20,20,   2,   10,10,20,   20,10,20,   3,   10,13,   4,   10,14,   10,18,10,   5,   10,15,   5,18   10,16,   6,   20,10,   17,10   7,   8,   18,10,   18,19,   9]
m =  [10,11,12,   13,14,   1,   13,15,   4,12,12,   13,12,12    2,   13,13,12,   12,13,12,   3,   13,16,   4,   10,17,   13,11,13,   5,   13,18,   5,11,  13,19,   6,   12,13,   20,13,  7,   8,   11,10,   11,21,   9]
%m = [12,13,   13,13,12,   4,12,12,   5,11,   20,13,   12,13,12,   1,   13,16,   13,14,   13,19,   5,   8,   13,11,13,   13,12,12,   5,   11,10,   3,    20,13,   10,17,   13,18,   6,   5,   7,   4,12,12,   13,19,   10,11,12,   4,   10,11,12,   9,    11,21,   13,15,   5,   2];
%m = [20,10,   10,10,20,   4,20,20,   5,18,   17,10,   20,10,20,   1,   10,13,   10,11,   10,16,   5,   8,   10,18,10,   10,20,20,   5,   18,10,   3,    17,10,   10,14,   10,15,   6,   5,   7,   4,20,20,   10,16,   10,18,20,   4,   10,18,20,   9,    18,19,    10,12,   5,   2]
for i= 1:length(Strokes_gyrolinear)
    Y_Set = [Y_Set m];
end


            
            
            
            
 
end


