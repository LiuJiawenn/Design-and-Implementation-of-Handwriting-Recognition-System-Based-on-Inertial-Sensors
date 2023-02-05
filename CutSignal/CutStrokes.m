function [cutSignal]=StrokesSeparate(Cuted_LettersEner,gyrodata)
%% 在单词序列前面补200个0，后面补200个0，使第一个字母前面能切出一条线

for i= 1:length(Cuted_LettersEner) 
for k=1:length(Cuted_LettersEner{i})
%% 参数设置
s{i}{k} = Cuted_LettersEner{i}{k};
gyro{i}{k}=gyrodata{i}{k};
fs = 200;%采样频率
L = length(s{i}{k});
t = (0:L-1)/fs;
Win = 150;                % number of section  
step = 4;
nff = Win;                % number of fft   短时傅里叶变换的个数
threshold = 0.13      % 阈值
h = hamming(Win, 'periodic');   % Hamming weight function
ncl = fix( (L-Win)/step ) + 1;   % % fix是指靠近0取整，Number of CoLum  （总长-样本长）/步伐+1=列数
Ps{i}{k} = zeros(Win,ncl); % 行数为样本数，存储的每个样本包含汉明窗处理过的ncl个数据
fposition = 2  %频率线位置
%% 预处理 归一化
sNorm{i}{k} = mapminmax(s{i}{k}',0,1); % mapminmax通过将每一行的最小值和最大值标准化为[0, 1]来处理矩阵

%% 短时傅里叶变换
for n = 1:ncl                   % Ps means Processed Signal  处理过的信号
    Ps{i}{k}(:,n) = sNorm{i}{k}( (n-1)*step+1 : (n-1)*step+Win ).*h';%数据按列存储
end                            

%% 短时傅里叶变换
STFT0{i}{k} = fft(Ps{i}{k},nff);
S{i}{k} = abs(STFT0{i}{k});
fax{i}{k} = fs*(0:(nff/2))/nff;                           % 频率轴，Frequency axis setting
tax{i}{k} = ( .5*Win : step : step*(ncl-1)+.5*Win ) / fs;   % 时间轴，Time axis generating

[ttax{i}{k},ffax{i}{k}] = meshgrid(tax{i}{k},fax{i}{k});                    % Generating grid of figure
% Output
W1{i}{k} = ffax{i}{k};
T1{i}{k}= ttax{i}{k}; 
STFT1{i}{k} = abs(S{i}{k}/nff);
STFT2{i}{k} = STFT1{i}{k}(1:nff/2+1,:);             % Symmetric(对称的) results of FFT，取一半数据
STFT2{i}{k}(2:end-1,:) = 2*STFT2{i}{k}(2:end-1,:);  % Add the value of the other half   ，幅值乘2，为什么第一行数据不乘以2？
%生成频率和时间轴

%% 频谱图（用不着）
%{
figure;
my_pcolor(T1{i}{k}(1:10,:),W1{i}{k}(1:10,:),STFT2{i}{k}(1:10,:));
title('Time - frequency Map','FontSize',28);
xlabel('Time(s)','FontSize',28,'Fontname', 'Times New Roman');
ylabel(' Frequency(Hz) ','FontSize',28,'Fontname', 'Times New Roman');
set(gca,'FontSize',28);
%}
%% 求一阶近似导数
%求差分，差分的样本点间隔为1
% 差分间隔为1的时候效果比4的时候好（切割出的字母包含的移动部分更少）
[m, n] = size(S{i}{k});
sPart1{i}{k} = S{i}{k}(:,1:n - 2);
sPart2{i}{k} = S{i}{k}(:,3:n);
radio{i}{k} = sPart2{i}{k} - sPart1{i}{k};
radioNorm{i}{k} = mapminmax(radio{i}{k},0.25,0.75);%归一化

%% 选取0.4Hz频率线
e{i}{k} = radioNorm{i}{k}(fposition,:);%选择第1行数据
S{i}{k}(fposition,:) = mapminmax(S{i}{k}(fposition,:),0,1);
%{
figure;
subplot(1,1,1);
title("字母’A‘原始陀螺仪信号 ",'FontSize',30);
axis tight;set(gca,'FontSize',30);set(gca, 'LineWidth',1);
xlabel('Sampling point','FontSize',30,'Fontname', 'Times New Roman');ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');
set(gca,'FontSize',30);
set(gca, 'LineWidth',1.25);
% 画原始陀螺仪
hold on;p5=plot(S{i}{k}(fposition,:));%陀螺仪数据
%}
%% 找到阈值，切出所有的波峰和波谷，去除多余，补充缺失
eIndexTime{i}{k} = [];
eIndexNum{i}{k} = [];
jval{i}{k} = [];
% %过滤既是峰值又大于阈值的点
for j = 2:(length(e{i}{k})-1)
    if e{i}{k}(j) > e{i}{k}(j-1) && e{i}{k}(j) > e{i}{k}(j+1) 
        jval{i}{k} = [jval{i}{k} j];
        eIndexTime{i}{k} = [eIndexTime{i}{k} tax{i}{k}(j)];%时间
        eIndexNum{i}{k} = [eIndexNum{i}{k} fix(tax{i}{k}(j)*fs)];%采样点
    elseif  (e{i}{k}(j) < e{i}{k}(j-1)) && (e{i}{k}(j) < e{i}{k}(j+1))  
        jval{i}{k} = [jval{i}{k} j];
        eIndexTime{i}{k} = [eIndexTime{i}{k} tax{i}{k}(j)];%时间
        eIndexNum{i}{k} = [eIndexNum{i}{k} fix(tax{i}{k}(j)*fs)];%采样点
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
                

%% 存储每个单词的字母的切割点
for m = 1:4:(length(Numline{i}{k}) - 1)
    cutSignal{i}{k}((m+3)/4,:)= Numline{i}{k}(m:m + 1);
end  


%% 画图
%{
figure;

subplot(2,1,1);
titlename = strcat("(",num2str(i),"Word",num2str(k),")");
% title("Normalized Signal and Frequency Line "+titlename,'FontSize',18,'fontname','Times New Roman');
set(gca, 'LineWidth',1.25);
set(gca,'FontSize',30)
xlabel('(a)Time(s)','FontSize',30,'Fontname', 'Times New Roman');
ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');
% 绘制0.4Hz频率线
freLine{i}{k} = mapminmax(S{i}{k}(fposition,:),0,1);
hold on;p2=plot(tax{i}{k},freLine{i}{k},'b','LineWidth',2);
% 绘制导数线
hold on;p3=plot(tax{i}{k}(1:n-2),radioNorm{i}{k}(fposition,:),':k','LineWidth',2);axis tight;%第二行
hold on;p4=line([0 t(end)],[threshold threshold],'Color','g','LineStyle','--','LineWidth',2);
% 画出切割线
hold on;hh = axis;
for j = Timeline{i}{k}
    plot([j,j], [hh(3),hh(4)],'r','LineWidth',2);%字母切割线
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
% 画原始陀螺仪
hold on;p5=plot(gyro{i}{k}(:,1:3),'LineWidth',2);%陀螺仪数据
% % 画出切割线
hh = axis;hold on;
for j =Numline{i}{k}
    plot([j,j], [hh(3),hh(4)],'r','LineWidth',2);%字母切割线
end
%
%}

end %% k循环
end %% i循环
end