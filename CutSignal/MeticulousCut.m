%% �������и�����ʵ���ĸ����ʱ����Ҷ�任
% ��Ե�����ĸ�����Ż��и
% 1.���ȶԲ����㲻��800����ĸ�����˽��в�0�������Ա�ת����Ƶ���У�д�ֲ�������ھ�ֹ���������ܸ������ԡ��������ȷ��ˣ�
% 2.Ȼ��ʱ���һά����������ͬ��ʱ����Ҷ�任���ҽ�ʱ������ת����ʱƵ��ͨ������������ʱ����Ƶ��֮��Ķ�Ӧ��ϵ
% 3.�۲�۲�ʱƵͼ�����Է��ֵ�1,2,3,4�е�Ƶ���߸��ܿ����뾲ֹ�������ҵ�һ��Ƶ���ǻ��Ƶ�ʣ����ܷ�ӳ��Ϣ��
% 4.������2,3,4��Ƶ�ʶ�Ӧ��ʱ��ͼ�����ֵ�2��Ƶ�ʶ�Ӧ��ʱ��ͼ��ԭʼʱ��ͼ�����ƣ�Ҳ����˵��2��Ƶ�����γ�ʱ��ͼ����ҪƵ�ʡ�
%��ʱ��ͼ���ɶ���Ƶ�ʶ�Ӧ�������ź��ۼ��γɵģ��������Ƶ�һ��Ƶ��������ԭʼʱ��ͼ����Ҫ�ɷ֡����ô�Ƶ���߱�ʾԭʼʱ��ͼ��
% 5.�Ե�2��0.78HZƵ�ʶ�Ӧ��ʱ��ͼ������һ�ײ�֣���Ϊʱ��ͼ�ǡ��͸ߵ͡���״̬��һ�ײ�ֵĲ���Ͳ��ȶ�Ӧ��ʱ��ͼ���ߡ����ֵĿ�ʼ�����
% 6.һ�ײ�ֵĲ��岨�ȵ�λ�ÿ��Զ�Ӧ��ʱ��״̬�У��Ϳ����и��д�ֲ���
% 7. ����ÿ����ĸ������
function [gyroData1,linearData1]=MeticulousCut(outSmoothEner,outgyroData,outlinearData)
%% �Ե�����ĸ������Ԥ����
%��ÿ����ĸ�����˽��в�0����������������䵽800���Ա���ֳ����͸ߵ͡���״̬��һ�ײ�ֵĲ���Ͳ��ȸ��ܷ�ӳ��д�ֵĿ�ʼ�����
% һ����ĸ�Ĳ��������һ����256 ���ڣ�Ϊ�˱�֤���ڴ�СС����ĸ���������������������ӳ��ĸ����Ϣ��������ÿ����ĸ���䵽800
% ��0˼�룺������ĳһ����������������ͬһ������ص�ʸ��������ͬ�ġ�
% ���غ���һ���������ж����Ե����ԣ����������ʸ���ֽ�ͺϳɡ����ԣ����������ص�ʸ���;͵��ں��������ء�
% ���ݼ��ι�ʽ��floor(sum(point_loc{i}{j}{k}.*SmoothEner{i}{j}{k})/sum(SmoothEner{i}{j}{k}))�ҵ����������õ㣬�����õ������������λ�ã��������õ���ǰ����в�0

%% ������ص�
point_loc = cell(size(outSmoothEner));
Centerpoint= cell(size(outSmoothEner));
for i= 1:length(outSmoothEner)
    for j= 1:length(outSmoothEner{i})
        for k= 1:length(outSmoothEner{i}{j})
            %��ȡ��Ӧ�Ĳ�����ֵ
            for k1=1:length(outSmoothEner{i}{j}{k})
            point_loc{i}{j}{k}(k1,1)=k1;
            end
            %������еĺ������õ�
            Centerpoint{i}{j}{k}=floor(sum(point_loc{i}{j}{k}.*outSmoothEner{i}{j}{k})/sum(outSmoothEner{i}{j}{k}));
            %������ת�Ǻ�
            SmoothE{i}{j}{k}(:,1)=outSmoothEner{i}{j}{k}(:,1);
            SmoothEner2{i}{j}{k}(1:400-Centerpoint{i}{j}{k},1)=0;
            SmoothEner2{i}{j}{k}(length(SmoothEner2{i}{j}{k})+1:(length(SmoothEner2{i}{j}{k})+length(SmoothE{i}{j}{k})),1)=SmoothE{i}{j}{k}(:,1);
            SmoothEner2{i}{j}{k}(length(SmoothEner2{i}{j}{k})+1:800,1)=0;
            outSmoothEner{i}{j}{k}=SmoothEner2{i}{j}{k}';
            %������
            outgyroD{i}{j}{k}(:,1:3)=outgyroData{i}{j}{k}(:,1:3);
            outgyroData1{i}{j}{k}(1:400-Centerpoint{i}{j}{k},1:3)=0;
            outgyroData1{i}{j}{k}(length(outgyroData1{i}{j}{k})+1:(length(outgyroData1{i}{j}{k})+length(outgyroD{i}{j}{k})),1:3)=outgyroD{i}{j}{k}(:,1:3);
            outgyroData1{i}{j}{k}(length(outgyroData1{i}{j}{k})+1:800,1:3)=0;
            outgyroData{i}{j}{k}=outgyroData1{i}{j}{k};
            %���Լ��ٶ�
            outlinearoD{i}{j}{k}(:,1:3)=outlinearData{i}{j}{k}(:,1:3);
            outlinearData1{i}{j}{k}(1:400-Centerpoint{i}{j}{k},1:3)=0;
            outlinearData1{i}{j}{k}(length(outlinearData1{i}{j}{k})+1:(length(outlinearData1{i}{j}{k})+length(outlinearoD{i}{j}{k})),1:3)=outlinearoD{i}{j}{k}(:,1:3);
            outlinearData1{i}{j}{k}(length(outlinearData1{i}{j}{k})+1:800,1:3)=0;
            outlinearData{i}{j}{k}=outlinearData1{i}{j}{k};
        end
    end
end

%% ��������
for i= 1:length(outSmoothEner)
for j= 1:length(outSmoothEner{i})
for k= 1:length(outSmoothEner{i}{j})
s{i}{j}{k} = outSmoothEner{i}{j}{k};
gyroData{i}{j}{k}=outgyroData{i}{j}{k};
linearData{i}{j}{k}=outlinearData{i}{j}{k};
fs = 200;%����Ƶ��
L = length(s{i}{j}{k});
t = (0:L-1)/fs;
Win = 200;                % number of section  ��һ��̧�۶������²��������
step = 8;
nff = Win;                % number of fft   ��ʱ����Ҷ�任�ĸ���
h = hamming(Win, 'periodic');   % Hamming weight function
ncl = fix( (L-Win)/step ) + 1;   % fix��ָ����0ȡ���� �ܳ�-��������/����+1=����
Ps{i}{j}{k} = zeros(Win,ncl); % ����Ϊ���������洢��ÿ�����������������������ncl������
highthreshold = 0.999
lowthreshold = 0.00004
%% Ԥ���� ��һ��
sNorm{i}{j}{k} = mapminmax(s{i}{j}{k},0,1); % mapminmaxͨ����ÿһ�е���Сֵ�����ֵ��׼��Ϊ[0, 1]���������

%% ��ʱ����Ҷ�任
Ps{i}{j}{k} = zeros(Win,ncl); % ����Ϊ���������洢��ÿ�����������������������ncl������
for n = 1:ncl                   % Ps means Processed Signal  ��������ź�
    Ps{i}{j}{k}(:,n) = sNorm{i}{j}{k}( (n-1)*step+1 : (n-1)*step+Win).*h';%���ݰ��д洢
end   

%% ��ʱ����Ҷ�任
% Short-time Fourier transform
STFT0{i}{j}{k} = fft(Ps{i}{j}{k},nff);
%  ��fft�任���ģֵת����ԭ���ķ�ֵ��
S{i}{j}{k} = abs(STFT0{i}{j}{k});%ȡģ������n(���������)
fax{i}{j}{k} = fs*(0:(nff/2))/nff;                           % Ƶ����
tax{i}{j}{k} = (  .5*Win : step : L- .5*Win) / fs;   % ʱ����

%% ��һ�׽��Ƶ���
%���֣���ֵ���������Ϊ1
% ��ּ��Ϊ1��ʱ��Ч����4��ʱ��ã��и������ĸ�������ƶ����ָ��٣�
[m, n] = size(S{i}{j}{k});
sPart1{i}{j}{k} = S{i}{j}{k}(:,1:n - 1);
sPart2{i}{j}{k} = S{i}{j}{k}(:,2:n);  
radio{i}{j}{k} = sPart2{i}{j}{k} - sPart1{i}{j}{k};
radioNorm{i}{j}{k} = mapminmax(radio{i}{j}{k},0,1);%��һ��һ�׵���

%% ѡȡ0.4HzƵ���ߵ�һ�׵���
e{i}{j}{k} = radioNorm{i}{j}{k}(2,:);%ѡ��ڶ�������
eIndexTime{i}{j}{k} = [];
eIndexNum{i}{j}{k} = [];
for n = 2:(length(e{i}{j}{k})-1)
% % %     %���˼��Ƿ�ֵ�ִ�����ֵ�ĵ�
    if((e{i}{j}{k}(n) > e{i}{j}{k}(n-1)) && (e{i}{j}{k}(n) > e{i}{j}{k}(n+1)) && e{i}{j}{k}(n) > highthreshold)||((e{i}{j}{k}(n) < e{i}{j}{k}(n-1)) && (e{i}{j}{k}(n) < e{i}{j}{k}(n+1)) && e{i}{j}{k}(n) <lowthreshold)
        eIndexTime{i}{j}{k} = [eIndexTime{i}{j}{k} tax{i}{j}{k}(n+1)];
        eIndexNum{i}{j}{k} = [eIndexNum{i}{j}{k} fix(tax{i}{j}{k}(n+1)*fs)];
    end
end

%% �洢�и�õ���ĸ
SmoothEner1{i}{j}{k}(1,:)=outSmoothEner{i}{j}{k}(1,eIndexNum{i}{j}{k}(1):eIndexNum{i}{j}{k}(end));
gyroData1{i}{j}{k}(:,1:3)=outgyroData{i}{j}{k}(eIndexNum{i}{j}{k}(1):eIndexNum{i}{j}{k}(end),1:3);
linearData1{i}{j}{k}(:,1:3)=outlinearData{i}{j}{k}(eIndexNum{i}{j}{k}(1):eIndexNum{i}{j}{k}(end),1:3);
                         
%% ����ʱ���ź�ͼ��
%{
figure;
subplot(2,1,1);
%p1=plot(t,sNorm{i}{j}{k},'Color','[0.5 0.5 1]');
titlename1 = strcat("Letter",char(j+64));
title("Normalized Signal and Frequency Line "+titlename1,'FontSize',30);
set(gca, 'LineWidth',1.25);
xlabel('Time(s)','FontSize',18,'Fontname', 'Times New Roman');
ylabel('Amplitude','FontSize',18,'Fontname', 'Times New Roman');

% ����0.78HzƵ����
freLineNorm{i}{j}{k} = mapminmax(S{i}{j}{k}(2,:),0,1);
hold on;p1=plot(tax{i}{j}{k},freLineNorm{i}{j}{k},'LineWidth',2,'color','blue');
% ���ƽ���һ�׵���
%%�����и����ֵ
hold on;p3=plot(tax{i}{j}{k}(1:length(radioNorm{i}{j}{k}(2,:))),radioNorm{i}{j}{k}(2,:),':k','LineWidth',2);axis tight;
hold on;p4=line([0 t(end)],[highthreshold highthreshold],'Color','g','LineStyle','--','LineWidth',2);
hold on;p5=line([0 t(end)],[lowthreshold lowthreshold],'Color','g','LineStyle','--','LineWidth',2);
%�����и��ߣ��������
hold on;hh = axis;
for m = eIndexTime{i}{j}{k}
    plot([m,m], [hh(3),hh(4)],'r','LineWidth',2);%��ĸ�и���
end

%��������
subplot(2,1,2);
hold on;p6=plot(outgyroData{i}{j}{k}(:,1:3),'LineWidth',2);
titlename1 = strcat("Letter",char(j+64),":","Stroke",num2str(k));
title("Gyroscope Data "+titlename1,'FontSize',30,'fontname','Times New Roman');
axis tight;set(gca,'FontSize',30);set(gca, 'LineWidth',1);
xlabel('Sampling Points','FontSize',30,'Fontname', 'Times New Roman');ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');
set(gca,'FontSize',30)
set(gca, 'LineWidth',1.25)
lgd1=legend(p6([1 2 3]),'Gyro X','Gyro Y','Gyro Z','LineWidth',2);
lgd1.FontSize = 14;
lgd1.Location = 'northeast';
hh = axis;hold on;
for m = eIndexNum{i}{j}{k}
    plot([m,m], [hh(3),hh(4)],'r','LineWidth',2);
%}


%%
%{
%��������
figure;
subplot(2,1,1);
p6=plot(gyroData1{i}{j}{k}(:,1:3));
titlename1 = strcat("(","Word",num2str(j),":",num2str(k),")");
title("Gyroscope Data "+titlename1,'FontSize',18,'fontname','Times New Roman');
axis tight;set(gca,'FontSize',18);set(gca, 'LineWidth',1);
xlabel('Sampling Points','FontSize',18,'Fontname', 'Times New Roman');ylabel('Amplitude','FontSize',18,'Fontname', 'Times New Roman');
set(gca,'FontSize',18)
set(gca, 'LineWidth',1.25)
lgd1=legend(p5([1 2 3]),'Gyro X','Gyro Y','Gyro Z','LineWidth',2);
lgd1.FontSize = 20;
lgd1.Location = 'northeast';

subplot(2,1,2);
p6=plot(linearData1{i}{j}{k}(:,1:3));
titlename1 = strcat("(","Word",num2str(j),":",num2str(k),")");
title("Gyroscope Data "+titlename1,'FontSize',18,'fontname','Times New Roman');
axis tight;set(gca,'FontSize',18);set(gca, 'LineWidth',1);
xlabel('Sampling Points','FontSize',18,'Fontname', 'Times New Roman');ylabel('Amplitude','FontSize',18,'Fontname', 'Times New Roman');
set(gca,'FontSize',18)
set(gca, 'LineWidth',1.25)
%}
end %%kѭ��
end%% jѭ��
end%% iѭ��
end




















