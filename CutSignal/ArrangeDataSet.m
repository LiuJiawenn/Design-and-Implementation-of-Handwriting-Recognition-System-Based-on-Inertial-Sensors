%%  ��ÿ�����ʵĵ�����ĸ���д����Ż��и�
%����Ϊ�и�õĵ��ʵ���ĸ������ת�Ǻͣ�sum(abs(data),2),�ڶ���������ƽ������
%��ת�Ǻͽ��ж�ʱ����Ҷ�仯��ת����Ƶ�����ҵ���ĸ���и�㣬��ȡ����ȷ����ĸ����ͼ

function [maxlength,X_Set,Y_Set,Strokes_lable] = ArrangeDataSet(outgyroData,outlinearData)
%% �Ե�����ĸ������Ԥ����
%��ÿ����ĸ�����˽��в�0����������������䵽�������������㣬���ں���LSTM
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
maxlength= max(length1); %������������
maxlength = 225;

% �������ǣ����Լ��ٶȷ�����ϳ�6ά
for i= 1:length(outgyroData)
    for j= 1:length(outgyroData{i})
        for k= 1:length(outgyroData{i}{j})
            if(length(outgyroData{i}{j}{k})<maxlength)    %%С��ͳһ���Ȳ�0   
                outgyroData{i}{j}{k}(length(outgyroData{i}{j}{k})+1:maxlength,1:3)=0;
                outlinearData{i}{j}{k}(length(outlinearData{i}{j}{k})+1:maxlength,1:3)=0;
            else                                          %%����ͳһ���Ƚ�ȡ
                gyroData2{i}{j}{k}(:,1:3)=outgyroData{i}{j}{k}(1:maxlength,1:3);
                outgyroData{i}{j}{k}=gyroData2{i}{j}{k};
                linearData2{i}{j}{k}(:,1:3)=outlinearData{i}{j}{k}(1:maxlength,1:3);
                outlinearData{i}{j}{k}=linearData2{i}{j}{k};
            end
            Strokes_gyrolinear{i}{j}{k}(:,1:3)=outgyroData{i}{j}{k}(:,1:3);%�������������Լ��ٶ�ƴ���������6ά
            Strokes_gyrolinear{i}{j}{k}(:,4:6)=outlinearData{i}{j}{k}(:,1:3);
            Strokes_lable{i}{j}{k}(1)=j;%�ڼ�������
            Strokes_lable{i}{j}{k}(2)=k;%���ʵĵڼ�����ĸ
        end
    end
end

%%�������ݼ�
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


