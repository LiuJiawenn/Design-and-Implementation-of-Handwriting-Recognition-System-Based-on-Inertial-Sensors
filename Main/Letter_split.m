dbstop if error %代码自动停在出错行，并保留相关参数
path='C:\Users\Hong\Desktop\a\';
addpath('C:\Users\Hong\Desktop\实验室\大写字母代码\CRecognition - 副本\ReadFile\');
addpath('C:\Users\Hong\Desktop\实验室\大写字母代码\CRecognition - 副本\Pretreat\');
addpath('C:\Users\Hong\Desktop\实验室\大写字母代码\CRecognition - 副本\CutSignal\');
%% 读取文件，存储为矩阵
[SensorData] = SensorRead(path);       %20列数据 0+采样时间+加速度xyz+陀螺仪xyz+磁力计xyz+压力计xyz+重力加速度xyz+线性加速度xyz

%% 预处理
[SensorData] = CutOutliers(SensorData); % 去掉初始几个NAN采样点，以及远远高出周围点数值的异常点

%% 分割数据
%获取陀螺仪数据
for i=1:length(SensorData)
  gyrodata{i} =SensorData{i}(:,6:8);
end
%获取线性加速度数据
for i=1:length(SensorData)
  lineardata{i} =SensorData{i}(:,18:20);
end

%% 求陀螺仪三轴和，作为切割依据
[SmoothEner] = Sumgyro( gyrodata );
%% 第一步切割： 整体序列切出单词：将x轴与水平面夹角的一阶导数通过短时傅里叶变换，根据频率找到切割点
[Letters_cutSignal]=CutLetters(SmoothEner,gyrodata);
%% 取出单词
[Cuted_LettersEner,Cuted_Lettersgyro,Cuted_Letterslinear] = StorLetters(SmoothEner,gyrodata,lineardata,Letters_cutSignal );
%% 第二步切割：从单词中切出字母序列 ：将陀螺仪的转角和通过短时傅里叶变换，根据波峰切出能量开始点，取出包含字母的序列
[Strokes_cutSignal]=CutStrokes(Cuted_LettersEner,Cuted_Lettersgyro);
%% 获取包含字母的序列
 [ outgyroData,outlinearData,outSmoothEner] = StorStrokes(Cuted_LettersEner,Cuted_Lettersgyro,Cuted_Letterslinear,Strokes_cutSignal );
%% 第三步切割：根据写字与静止的差异，获取字母的边界点 l 输出精细切割的笔划
[outgyroData,outlinearData]=MeticulousCut(outSmoothEner,outgyroData,outlinearData);
%% stm步长：处理字母长度：gyrolinear陀螺仪和线性加速度拼接成的6维
[maxlength,Strokes_gyrolinear,Strokes_lable,sentence_label] = ArrangeDataSet(outgyroData,outlinearData);

%  for i = 1:length(Strokes_gyrolinear)
%      figure;
%      subplot(1,1,1);
%      p6=plot(Strokes_gyrolinear{i}(:,1:3));
%      axis tight;set(gca,'FontSize',18);set(gca, 'LineWidth',1);
%      xlabel('Sampling Points','FontSize',18,'Fontname', 'Times New Roman');ylabel('Amplitude','FontSize',18,'Fontname', 'Times New Roman');
%      set(gca,'FontSize',18);
%      set(gca, 'LineWidth',1.25);
%  end

