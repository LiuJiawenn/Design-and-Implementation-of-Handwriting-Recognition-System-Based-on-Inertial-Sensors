dbstop if error %�����Զ�ͣ�ڳ����У���������ز���
path='C:\Users\Hong\Desktop\a\';
addpath('C:\Users\Hong\Desktop\ʵ����\��д��ĸ����\CRecognition - ����\ReadFile\');
addpath('C:\Users\Hong\Desktop\ʵ����\��д��ĸ����\CRecognition - ����\Pretreat\');
addpath('C:\Users\Hong\Desktop\ʵ����\��д��ĸ����\CRecognition - ����\CutSignal\');
%% ��ȡ�ļ����洢Ϊ����
[SensorData] = SensorRead(path);       %20������ 0+����ʱ��+���ٶ�xyz+������xyz+������xyz+ѹ����xyz+�������ٶ�xyz+���Լ��ٶ�xyz

%% Ԥ����
[SensorData] = CutOutliers(SensorData); % ȥ����ʼ����NAN�����㣬�Լ�ԶԶ�߳���Χ����ֵ���쳣��

%% �ָ�����
%��ȡ����������
for i=1:length(SensorData)
  gyrodata{i} =SensorData{i}(:,6:8);
end
%��ȡ���Լ��ٶ�����
for i=1:length(SensorData)
  lineardata{i} =SensorData{i}(:,18:20);
end

%% ������������ͣ���Ϊ�и�����
[SmoothEner] = Sumgyro( gyrodata );
%% ��һ���и ���������г����ʣ���x����ˮƽ��нǵ�һ�׵���ͨ����ʱ����Ҷ�任������Ƶ���ҵ��и��
[Letters_cutSignal]=CutLetters(SmoothEner,gyrodata);
%% ȡ������
[Cuted_LettersEner,Cuted_Lettersgyro,Cuted_Letterslinear] = StorLetters(SmoothEner,gyrodata,lineardata,Letters_cutSignal );
%% �ڶ����и�ӵ������г���ĸ���� ���������ǵ�ת�Ǻ�ͨ����ʱ����Ҷ�任�����ݲ����г�������ʼ�㣬ȡ��������ĸ������
[Strokes_cutSignal]=CutStrokes(Cuted_LettersEner,Cuted_Lettersgyro);
%% ��ȡ������ĸ������
 [ outgyroData,outlinearData,outSmoothEner] = StorStrokes(Cuted_LettersEner,Cuted_Lettersgyro,Cuted_Letterslinear,Strokes_cutSignal );
%% �������и����д���뾲ֹ�Ĳ��죬��ȡ��ĸ�ı߽�� l �����ϸ�и�ıʻ�
[outgyroData,outlinearData]=MeticulousCut(outSmoothEner,outgyroData,outlinearData);
%% stm������������ĸ���ȣ�gyrolinear�����Ǻ����Լ��ٶ�ƴ�ӳɵ�6ά
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

