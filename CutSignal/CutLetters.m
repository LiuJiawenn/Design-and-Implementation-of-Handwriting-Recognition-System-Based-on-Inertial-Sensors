function [word_cutSignal]=CutLetters(SmoothEner,gyrodata)
for i= 1:length(SmoothEner)
%% ���в���
s{i} = SmoothEner{i};
gyro{i} = gyrodata{i};
fs = 200;%����Ƶ��
L = length(s{i});
t = (0:L-1)/fs;
Win = 400;                % number of section  ��һ��̧�۶������²������������Ϊ���ڴ�С
step = 8;
nff = Win;                % number of fft   ��ʱ����Ҷ�任�ĸ���
threshold = 0.3           % ��ֵ

h = hamming(Win, 'periodic');   % Hamming weight function
ncl = fix( (L-Win)/step ) + 1;   % % fix��ָ����0ȡ����Number of CoLum  ���ܳ�-��������/����+1=����
Ps{i} = zeros(Win,ncl); % ����Ϊ���������洢��ÿ�����������������������ncl������

%% Ԥ���� ��һ��
sNorm{i} = mapminmax(s{i}',0,1); 

%% ����Ҷ�任
for n = 1:ncl                   % Ps means Processed Signal  ��������ź�
    Ps{i}(:,n) = sNorm{i}( (n-1)*step+1 : (n-1)*step+Win ).*h'; %���ݰ��д洢�����Դ�����
end  

STFT0{i} = fft(Ps{i},nff);
S{i} = abs(STFT0{i});                          %FFT������ÿһλ����������abs��ȡģת��Ϊ��ֵ��Ϣ
fax{i} = fs*(0:(nff))/nff;                     % Ƶ���ᣬFrequency axis setting
tax{i} = ( .5*Win : step : step*(ncl-1)+.5*Win ) / fs;   % ʱ����

%% ��һ�׽��Ƶ���
%���֣���ֵ���������Ϊ1
% ��ּ��Ϊ1��ʱ��Ч����4��ʱ��ã��и������ĸ�������ƶ����ָ��٣�
[m, n] = size(S{i});
sPart1{i} = S{i}(:,1:n - 1);
sPart2{i} = S{i}(:,2:n);
radio{i} = sPart2{i} - sPart1{i};
radioNorm{i} = mapminmax(radio{i},0,1);%��һ��
%% ѡȡ0.4HzƵ����
e{i} = radioNorm{i}(2,:);%ѡ��ڶ�������
S{i}(2,:) = mapminmax(S{i}(2,:),0,1);

eIndexTime{i} = [];
eIndexNum{i} = [];
jval{i} = [];
for j = 2:(length(e{i})-1)%��Ϊ�����õĲ�֣���һ��û���󵼣���˴�2��ʼ
%���˼��Ƿ�ֵ�ִ�����ֵ�ĵ�
    if  ((e{i}(j) > e{i}(j-1))  && (e{i}(j)) > e{i}(j+1))   
        jval{i} = [jval{i} j];
        eIndexTime{i} = [eIndexTime{i} tax{i}(j)];        %ʱ����λ��
        eIndexNum{i} = [eIndexNum{i} fix(tax{i}(j)*fs)];  %������λ��
    elseif ((e{i}(j) < e{i}(j-1)) && (e{i}(j) < e{i}(j+1)))
        jval{i} = [jval{i} j];
        eIndexTime{i} = [eIndexTime{i} tax{i}(j)];        %ʱ����λ��
        eIndexNum{i} = [eIndexNum{i} fix(tax{i}(j)*fs)];  %������λ��
    end
end

Timeline{i} = [];
Numline{i} = [];
for j = 2:(length(eIndexNum{i})-1)
    if e{i}(jval{i}(j))>0 && S{i}(2,fix((jval{i}(j)+jval{i}(j+1))/2))> threshold
        Timeline{i} = [Timeline{i} eIndexTime{i}(j)-15/fs];
        Timeline{i} = [Timeline{i} eIndexTime{i}(j+1)+45/fs];
        Numline{i} = [Numline{i} eIndexNum{i}(j)-15];
        Numline{i} = [Numline{i} eIndexNum{i}(j+1)+45];
        j = j+1;
    end
end
%% �洢���ʵ��и��
for m = 1:length(Numline{i}) - 1
    cutSignal{i}(m,1:2) = Numline{i}(m:m + 1);%%ȱ�ٵ�һ�������һ����ĸ
end  
%%��ӵ�һ�������һ����ĸ��ֵ������ֵ
cutSignal{i} = [[1 Numline{i}(1)];cutSignal{i};[Numline{i}(end) L]];
for j=1:2:length(cutSignal{i})
    word_cutSignal{i}((j+1)/2,:) = cutSignal{i}(j,:);%�������ʲ���
end



%% �����и�ͼ��

figure;

subplot(2,1,1);
title("Normalized Frequency Line ",'FontSize',18,'fontname','Times New Roman');
set(gca, 'LineWidth',1.25);
set(gca,'FontSize',30)
xlabel('(a)Time(s)','FontSize',30,'Fontname', 'Times New Roman');
ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');

% ����0.4HzƵ����
hold on;p2=plot(tax{i},S{i}(2,:),'b','LineWidth',2);

% ����0.4HzƵ���ߵ���
hold on;p3=plot(tax{i}(1:n - 1),radioNorm{i}(2,:),':k','LineWidth',2);axis tight;
% % ������ֵ
hold on;p4=line([0 t(end)],[threshold threshold],'Color','g','LineStyle','--','LineWidth',2);
% �����и���

hold on;hh = axis;           %hh�õ��˵�ǰ����ϵ�ĺ������귶Χ1*4������
for j = Timeline{i}
    plot([j,j], [hh(3),hh(4)],'r','LineWidth',2);%��ĸ�и���
end
lgd=legend([p2],'0.39Hz Frequency Line');
lgd.FontSize = 25;
lgd.Location = 'northeast'; 
% lgd=legend([p2 p3 p4],'0.4HZ Frequency Line','First Derivative of 0.4HZ Frequency Line','The Threshold ');
% lgd.FontSize = 17;
% lgd.Location = 'northeast'; 

%��������
subplot(2,1,2);
hold on;
t=(0:length(gyro{i}(:,1))-1)/200;
%����������
p5=plot(t,gyro{i}(:,1:3),'LineWidth',1.25);

axis tight;set(gca,'FontSize',30);set(gca, 'LineWidth',1);
xlabel('(b)Time(s)','FontSize',30,'Fontname', 'Times New Roman');
ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');
title("Gyro Triaxial Data Image",'FontSize',18,'fontname','Times New Roman');
set(gca,'FontSize',30)
set(gca, 'LineWidth',1.25)

% �����и���
hold on;hh = axis;
for j = Timeline{i}
    plot([j,j], [hh(3),hh(4)],'r','LineWidth',2);%��ĸ�и���
end
lgd1=legend(p5([1 2 3]),'gyrX','gyrY','gyrZ');
lgd1.FontSize = 25;
lgd1.Location = 'northeast';
%}
end %���forѭ����end
end %������end




















