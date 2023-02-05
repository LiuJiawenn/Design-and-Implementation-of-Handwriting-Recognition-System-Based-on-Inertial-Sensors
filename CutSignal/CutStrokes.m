function [cutSignal]=StrokesSeparate(Cuted_LettersEner,gyrodata)
%% �ڵ�������ǰ�油200��0�����油200��0��ʹ��һ����ĸǰ�����г�һ����

for i= 1:length(Cuted_LettersEner) 
for k=1:length(Cuted_LettersEner{i})
%% ��������
s{i}{k} = Cuted_LettersEner{i}{k};
gyro{i}{k}=gyrodata{i}{k};
fs = 200;%����Ƶ��
L = length(s{i}{k});
t = (0:L-1)/fs;
Win = 150;                % number of section  
step = 4;
nff = Win;                % number of fft   ��ʱ����Ҷ�任�ĸ���
threshold = 0.13      % ��ֵ
h = hamming(Win, 'periodic');   % Hamming weight function
ncl = fix( (L-Win)/step ) + 1;   % % fix��ָ����0ȡ����Number of CoLum  ���ܳ�-��������/����+1=����
Ps{i}{k} = zeros(Win,ncl); % ����Ϊ���������洢��ÿ�����������������������ncl������
fposition = 2  %Ƶ����λ��
%% Ԥ���� ��һ��
sNorm{i}{k} = mapminmax(s{i}{k}',0,1); % mapminmaxͨ����ÿһ�е���Сֵ�����ֵ��׼��Ϊ[0, 1]���������

%% ��ʱ����Ҷ�任
for n = 1:ncl                   % Ps means Processed Signal  ��������ź�
    Ps{i}{k}(:,n) = sNorm{i}{k}( (n-1)*step+1 : (n-1)*step+Win ).*h';%���ݰ��д洢
end                            

%% ��ʱ����Ҷ�任
STFT0{i}{k} = fft(Ps{i}{k},nff);
S{i}{k} = abs(STFT0{i}{k});
fax{i}{k} = fs*(0:(nff/2))/nff;                           % Ƶ���ᣬFrequency axis setting
tax{i}{k} = ( .5*Win : step : step*(ncl-1)+.5*Win ) / fs;   % ʱ���ᣬTime axis generating

[ttax{i}{k},ffax{i}{k}] = meshgrid(tax{i}{k},fax{i}{k});                    % Generating grid of figure
% Output
W1{i}{k} = ffax{i}{k};
T1{i}{k}= ttax{i}{k}; 
STFT1{i}{k} = abs(S{i}{k}/nff);
STFT2{i}{k} = STFT1{i}{k}(1:nff/2+1,:);             % Symmetric(�ԳƵ�) results of FFT��ȡһ������
STFT2{i}{k}(2:end-1,:) = 2*STFT2{i}{k}(2:end-1,:);  % Add the value of the other half   ����ֵ��2��Ϊʲô��һ�����ݲ�����2��
%����Ƶ�ʺ�ʱ����

%% Ƶ��ͼ���ò��ţ�
%{
figure;
my_pcolor(T1{i}{k}(1:10,:),W1{i}{k}(1:10,:),STFT2{i}{k}(1:10,:));
title('Time - frequency Map','FontSize',28);
xlabel('Time(s)','FontSize',28,'Fontname', 'Times New Roman');
ylabel(' Frequency(Hz) ','FontSize',28,'Fontname', 'Times New Roman');
set(gca,'FontSize',28);
%}
%% ��һ�׽��Ƶ���
%���֣���ֵ���������Ϊ1
% ��ּ��Ϊ1��ʱ��Ч����4��ʱ��ã��и������ĸ�������ƶ����ָ��٣�
[m, n] = size(S{i}{k});
sPart1{i}{k} = S{i}{k}(:,1:n - 2);
sPart2{i}{k} = S{i}{k}(:,3:n);
radio{i}{k} = sPart2{i}{k} - sPart1{i}{k};
radioNorm{i}{k} = mapminmax(radio{i}{k},0.25,0.75);%��һ��

%% ѡȡ0.4HzƵ����
e{i}{k} = radioNorm{i}{k}(fposition,:);%ѡ���1������
S{i}{k}(fposition,:) = mapminmax(S{i}{k}(fposition,:),0,1);
%{
figure;
subplot(1,1,1);
title("��ĸ��A��ԭʼ�������ź� ",'FontSize',30);
axis tight;set(gca,'FontSize',30);set(gca, 'LineWidth',1);
xlabel('Sampling point','FontSize',30,'Fontname', 'Times New Roman');ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');
set(gca,'FontSize',30);
set(gca, 'LineWidth',1.25);
% ��ԭʼ������
hold on;p5=plot(S{i}{k}(fposition,:));%����������
%}
%% �ҵ���ֵ���г����еĲ���Ͳ��ȣ�ȥ�����࣬����ȱʧ
eIndexTime{i}{k} = [];
eIndexNum{i}{k} = [];
jval{i}{k} = [];
% %���˼��Ƿ�ֵ�ִ�����ֵ�ĵ�
for j = 2:(length(e{i}{k})-1)
    if e{i}{k}(j) > e{i}{k}(j-1) && e{i}{k}(j) > e{i}{k}(j+1) 
        jval{i}{k} = [jval{i}{k} j];
        eIndexTime{i}{k} = [eIndexTime{i}{k} tax{i}{k}(j)];%ʱ��
        eIndexNum{i}{k} = [eIndexNum{i}{k} fix(tax{i}{k}(j)*fs)];%������
    elseif  (e{i}{k}(j) < e{i}{k}(j-1)) && (e{i}{k}(j) < e{i}{k}(j+1))  
        jval{i}{k} = [jval{i}{k} j];
        eIndexTime{i}{k} = [eIndexTime{i}{k} tax{i}{k}(j)];%ʱ��
        eIndexNum{i}{k} = [eIndexNum{i}{k} fix(tax{i}{k}(j)*fs)];%������
    end
end

Timeline{i}{k} = [];
Numline{i}{k} = [];
max_e = max(e{i}{k});
min_e = min(e{i}{k});
mean_e =  0.4;%(max_e + min_e)/2;
j = 1;
% while j< length(eIndexNum{i}{k})
%     if e{i}{k}(jval{i}{k}(j))>mean_e && S{i}{k}(fposition,fix((jval{i}{k}(j)+jval{i}{k}(j+1))/2))> threshold
%         temp = S{i}{k}(fposition,fix((jval{i}{k}(j)+jval{i}{k}(j+1))/2));
%         if (j+2)<length(eIndexNum{i}{k})
%             if (  S{i}{k}(fposition,fix((jval{i}{k}(j+1)+jval{i}{k}(j+2))/2)) <temp*0.65)
%                 Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j)];
%                 Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j+1)+40/fs];
%                 Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j)];
%                 Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j+1)+40];
%                 j = j+2;
%             else
%                 Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j)];
%                 Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j+3)+40/fs];
%                 Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j)];
%                 Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j+3)+40];
%                 j = j+4;
%             end            
%         else
%             Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j)];
%             Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j+1)+40/fs];
%             Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j)];
%             Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j+1)+40];
%             j = j+2;            
%         end
%     else
%         j =j+2;
%     end
% end
 if e{i}{k}(jval{i}{k}(j))<=mean_e 
        j =j+1;
    end
while j< length(eIndexNum{i}{k})
   
    if e{i}{k}(jval{i}{k}(j))>mean_e && S{i}{k}(fposition,fix((jval{i}{k}(j)+jval{i}{k}(j+1))/2))> threshold
        temp = S{i}{k}(fposition,fix((jval{i}{k}(j)+jval{i}{k}(j+1))/2));
        if (j+2)<length(eIndexNum{i}{k})
             if  abs(    temp - S{i}{k}(fposition,fix((jval{i}{k}(j+2)+jval{i}{k}(j+3))/2))        )>0.4
                Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j)];
                Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j+1)+40/fs];
                Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j)];
                Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j+1)+40];
                j = j+2;
             else
                 if (  S{i}{k}(fposition,fix((jval{i}{k}(j+1)+jval{i}{k}(j+2))/2)) <temp*0.7)
                    Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j)];
                    Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j+1)+40/fs];
                    Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j)];
                    Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j+1)+40];
                    j = j+2;
                else
                    Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j)];
                    Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j+3)+40/fs];
                    Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j)];
                    Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j+3)+40];
                    j = j+4;
                end            
             end
        else
            Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j)];
            Timeline{i}{k} = [Timeline{i}{k} eIndexTime{i}{k}(j+1)+40/fs];
            Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j)];
            Numline{i}{k} = [Numline{i}{k} eIndexNum{i}{k}(j+1)+40];
            j = j+2;            
        end
    else
        j =j+2;
    end
end
                

%% �洢ÿ�����ʵ���ĸ���и��
for m = 1:4:(length(Numline{i}{k}) - 1)
    cutSignal{i}{k}((m+3)/4,:)= Numline{i}{k}(m:m + 1);
end  


%% ��ͼ
%{
figure;

subplot(2,1,1);
titlename = strcat("(",num2str(i),"Word",num2str(k),")");
% title("Normalized Signal and Frequency Line "+titlename,'FontSize',18,'fontname','Times New Roman');
set(gca, 'LineWidth',1.25);
set(gca,'FontSize',30)
xlabel('(a)Time(s)','FontSize',30,'Fontname', 'Times New Roman');
ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');
% ����0.4HzƵ����
freLine{i}{k} = mapminmax(S{i}{k}(fposition,:),0,1);
hold on;p2=plot(tax{i}{k},freLine{i}{k},'b','LineWidth',2);
% ���Ƶ�����
hold on;p3=plot(tax{i}{k}(1:n-2),radioNorm{i}{k}(fposition,:),':k','LineWidth',2);axis tight;%�ڶ���
hold on;p4=line([0 t(end)],[threshold threshold],'Color','g','LineStyle','--','LineWidth',2);
% �����и���
hold on;hh = axis;
for j = Timeline{i}{k}
    plot([j,j], [hh(3),hh(4)],'r','LineWidth',2);%��ĸ�и���
end
% lgd1=legend([p2,p3],'1.56Hz Frequency Line','First Derivative of 1.56HZ Frequency Line');
% lgd1.FontSize = 15;
% lgd1.Location = 'southeast';

subplot(2,1,2);
titlename = strcat("Letter" + char(k+64));
title("Gyroscope Data "+titlename,'FontSize',30);
axis tight;set(gca,'FontSize',30);set(gca, 'LineWidth',1);
xlabel('Sampling point','FontSize',30,'Fontname', 'Times New Roman');ylabel('Amplitude','FontSize',18,'Fontname', 'Times New Roman');
set(gca,'FontSize',30)
set(gca, 'LineWidth',1.25)
% ��ԭʼ������
hold on;p5=plot(gyro{i}{k}(:,1:3),'LineWidth',2);%����������
% % �����и���
hh = axis;hold on;
for j =Numline{i}{k}
    plot([j,j], [hh(3),hh(4)],'r','LineWidth',2);%��ĸ�и���
end
%
%}

end %% kѭ��
end %% iѭ��
end