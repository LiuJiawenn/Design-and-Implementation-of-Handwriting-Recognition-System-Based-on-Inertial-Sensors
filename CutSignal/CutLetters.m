function [word_cutSignal]=CutLetters(SmoothEner,gyrodata)
for i= 1:length(SmoothEner)
%% 所有参数
s{i} = SmoothEner{i};
gyro{i} = gyrodata{i};
fs = 200;%采样频率
L = length(s{i});
t = (0:L-1)/fs;
Win = 400;                % number of section  即一个抬臂动作大致采样点个数，设为窗口大小
step = 8;
nff = Win;                % number of fft   短时傅里叶变换的个数
threshold = 0.3           % 阈值

h = hamming(Win, 'periodic');   % Hamming weight function
ncl = fix( (L-Win)/step ) + 1;   % % fix是指靠近0取整，Number of CoLum  （总长-样本长）/步伐+1=列数
Ps{i} = zeros(Win,ncl); % 行数为样本数，存储的每个样本包含汉明窗处理过的ncl个数据

%% 预处理 归一化
sNorm{i} = mapminmax(s{i}',0,1); 

%% 傅立叶变换
for n = 1:ncl                   % Ps means Processed Signal  处理过的信号
    Ps{i}(:,n) = sNorm{i}( (n-1)*step+1 : (n-1)*step+Win ).*h'; %数据按列存储，乘以窗函数
end  

STFT0{i} = fft(Ps{i},nff);
S{i} = abs(STFT0{i});                          %FFT结束，每一位都是虚数，abs后取模转化为幅值信息
fax{i} = fs*(0:(nff))/nff;                     % 频率轴，Frequency axis setting
tax{i} = ( .5*Win : step : step*(ncl-1)+.5*Win ) / fs;   % 时间轴

%% 求一阶近似导数
%求差分，差分的样本点间隔为1
% 差分间隔为1的时候效果比4的时候好（切割出的字母包含的移动部分更少）
[m, n] = size(S{i});
sPart1{i} = S{i}(:,1:n - 1);
sPart2{i} = S{i}(:,2:n);
radio{i} = sPart2{i} - sPart1{i};
radioNorm{i} = mapminmax(radio{i},0,1);%归一化
%% 选取0.4Hz频率线
e{i} = radioNorm{i}(2,:);%选择第二行数据
S{i}(2,:) = mapminmax(S{i}(2,:),0,1);

eIndexTime{i} = [];
eIndexNum{i} = [];
jval{i} = [];
for j = 2:(length(e{i})-1)%因为导数用的差分，第一行没有求导，因此从2开始
%过滤既是峰值又大于阈值的点
    if  ((e{i}(j) > e{i}(j-1))  && (e{i}(j)) > e{i}(j+1))   
        jval{i} = [jval{i} j];
        eIndexTime{i} = [eIndexTime{i} tax{i}(j)];        %时间轴位置
        eIndexNum{i} = [eIndexNum{i} fix(tax{i}(j)*fs)];  %采样点位置
    elseif ((e{i}(j) < e{i}(j-1)) && (e{i}(j) < e{i}(j+1)))
        jval{i} = [jval{i} j];
        eIndexTime{i} = [eIndexTime{i} tax{i}(j)];        %时间轴位置
        eIndexNum{i} = [eIndexNum{i} fix(tax{i}(j)*fs)];  %采样点位置
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
%% 存储单词的切割点
for m = 1:length(Numline{i}) - 1
    cutSignal{i}(m,1:2) = Numline{i}(m:m + 1);%%缺少第一个和最后一个字母
end  
%%添加第一个和最后一个字母后负值给返回值
cutSignal{i} = [[1 Numline{i}(1)];cutSignal{i};[Numline{i}(end) L]];
for j=1:2:length(cutSignal{i})
    word_cutSignal{i}((j+1)/2,:) = cutSignal{i}(j,:);%挑出单词部分
end



%% 绘制切割图像

figure;

subplot(2,1,1);
title("Normalized Frequency Line ",'FontSize',18,'fontname','Times New Roman');
set(gca, 'LineWidth',1.25);
set(gca,'FontSize',30)
xlabel('(a)Time(s)','FontSize',30,'Fontname', 'Times New Roman');
ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');

% 绘制0.4Hz频率线
hold on;p2=plot(tax{i},S{i}(2,:),'b','LineWidth',2);

% 绘制0.4Hz频率线导数
hold on;p3=plot(tax{i}(1:n - 1),radioNorm{i}(2,:),':k','LineWidth',2);axis tight;
% % 绘制阈值
hold on;p4=line([0 t(end)],[threshold threshold],'Color','g','LineStyle','--','LineWidth',2);
% 画出切割线

hold on;hh = axis;           %hh得到了当前坐标系的横纵坐标范围1*4的向量
for j = Timeline{i}
    plot([j,j], [hh(3),hh(4)],'r','LineWidth',2);%字母切割线
end
lgd=legend([p2],'0.39Hz Frequency Line');
lgd.FontSize = 25;
lgd.Location = 'northeast'; 
% lgd=legend([p2 p3 p4],'0.4HZ Frequency Line','First Derivative of 0.4HZ Frequency Line','The Threshold ');
% lgd.FontSize = 17;
% lgd.Location = 'northeast'; 

%画陀螺仪
subplot(2,1,2);
hold on;
t=(0:length(gyro{i}(:,1))-1)/200;
%陀螺仪数据
p5=plot(t,gyro{i}(:,1:3),'LineWidth',1.25);

axis tight;set(gca,'FontSize',30);set(gca, 'LineWidth',1);
xlabel('(b)Time(s)','FontSize',30,'Fontname', 'Times New Roman');
ylabel('Amplitude','FontSize',30,'Fontname', 'Times New Roman');
title("Gyro Triaxial Data Image",'FontSize',18,'fontname','Times New Roman');
set(gca,'FontSize',30)
set(gca, 'LineWidth',1.25)

% 画出切割线
hold on;hh = axis;
for j = Timeline{i}
    plot([j,j], [hh(3),hh(4)],'r','LineWidth',2);%字母切割线
end
lgd1=legend(p5([1 2 3]),'gyrX','gyrY','gyrZ');
lgd1.FontSize = 25;
lgd1.Location = 'northeast';
%}
end %最大for循环的end
end %函数的end




















