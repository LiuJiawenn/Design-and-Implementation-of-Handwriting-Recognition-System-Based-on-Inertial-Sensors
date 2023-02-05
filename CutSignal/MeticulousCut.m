%% 第三步切割：处理单词的字母：短时傅里叶变换
% 针对单个字母进行优化切割。
% 1.首先对采样点不满800的字母的两端进行补0操作，以便转换到频域中，写字部分相对于静止部分能量很高且明显。（结果的确如此）
% 2.然后将时域的一维能量和数据同短时傅里叶变换，且将时域数据转换到时频域，通过窗口来建立时间与频率之间的对应关系
% 3.观察观察时频图，可以发现第1,2,3,4行的频率线更能看出与静止的区别，且第一行频率是混合频率，不能反映信息。
% 4.画出第2,3,4行频率对应的时域图，发现第2行频率对应的时域图与原始时域图更相似，也就是说第2行频率是形成时域图的主要频率。
%（时域图是由多种频率对应的正弦信号累加形成的，而最相似的一条频率线则是原始时域图的主要成分。可用此频率线表示原始时域图）
% 5.对第2行0.78HZ频率对应的时域图进行求一阶差分，因为时域图是“低高低”的状态，一阶差分的波峰和波谷对应着时域图“高”部分的开始与结束
% 6.一阶差分的波峰波谷的位置可以对应到时域状态中，就可以切割出写字部分
% 7. 保存每个字母的数据
function [gyroData1,linearData1]=MeticulousCut(outSmoothEner,outgyroData,outlinearData)
%% 对单个字母的数据预处理
%对每个字母的两端进行补0，将采样点个数扩充到800，以便呈现出“低高低”的状态，一阶差分的波峰和波谷更能反映出写字的开始与结束
% 一个字母的采样点个数一般在256 以内，为了保证窗口大小小于字母采样点个数，且能完整反映字母的信息，决定将每个字母扩充到800
% 补0思想：合力对某一点的力矩与各分力对同一点的力矩的矢量和是相同的。
% 力矩和力一样，都具有独立性叠加性，可以任意的矢量分解和合成。所以，分力的力矩的矢量和就等于合力的力矩。
% 根据几何公式：floor(sum(point_loc{i}{j}{k}.*SmoothEner{i}{j}{k})/sum(SmoothEner{i}{j}{k}))找到合力的作用点，将作用点放在序列中心位置，根据作用点在前后进行补0

%% 求合力矩点
point_loc = cell(size(outSmoothEner));
Centerpoint= cell(size(outSmoothEner));
for i= 1:length(outSmoothEner)
    for j= 1:length(outSmoothEner{i})
        for k= 1:length(outSmoothEner{i}{j})
            %获取对应的采样点值
            for k1=1:length(outSmoothEner{i}{j}{k})
            point_loc{i}{j}{k}(k1,1)=k1;
            end
            %求出序列的合力作用点
            Centerpoint{i}{j}{k}=floor(sum(point_loc{i}{j}{k}.*outSmoothEner{i}{j}{k})/sum(outSmoothEner{i}{j}{k}));
            %陀螺仪转角和
            SmoothE{i}{j}{k}(:,1)=outSmoothEner{i}{j}{k}(:,1);
            SmoothEner2{i}{j}{k}(1:400-Centerpoint{i}{j}{k},1)=0;
            SmoothEner2{i}{j}{k}(length(SmoothEner2{i}{j}{k})+1:(length(SmoothEner2{i}{j}{k})+length(SmoothE{i}{j}{k})),1)=SmoothE{i}{j}{k}(:,1);
            SmoothEner2{i}{j}{k}(length(SmoothEner2{i}{j}{k})+1:800,1)=0;
            outSmoothEner{i}{j}{k}=SmoothEner2{i}{j}{k}';
            %陀螺仪
            outgyroD{i}{j}{k}(:,1:3)=outgyroData{i}{j}{k}(:,1:3);
            outgyroData1{i}{j}{k}(1:400-Centerpoint{i}{j}{k},1:3)=0;
            outgyroData1{i}{j}{k}(length(outgyroData1{i}{j}{k})+1:(length(outgyroData1{i}{j}{k})+length(outgyroD{i}{j}{k})),1:3)=outgyroD{i}{j}{k}(:,1:3);
            outgyroData1{i}{j}{k}(length(outgyroData1{i}{j}{k})+1:800,1:3)=0;
            outgyroData{i}{j}{k}=outgyroData1{i}{j}{k};
            %线性加速度
            outlinearoD{i}{j}{k}(:,1:3)=outlinearData{i}{j}{k}(:,1:3);
            outlinearData1{i}{j}{k}(1:400-Centerpoint{i}{j}{k},1:3)=0;
            outlinearData1{i}{j}{k}(length(outlinearData1{i}{j}{k})+1:(length(outlinearData1{i}{j}{k})+length(outlinearoD{i}{j}{k})),1:3)=outlinearoD{i}{j}{k}(:,1:3);
            outlinearData1{i}{j}{k}(length(outlinearData1{i}{j}{k})+1:800,1:3)=0;
            outlinearData{i}{j}{k}=outlinearData1{i}{j}{k};
        end
    end
end

%% 参数设置
for i= 1:length(outSmoothEner)
for j= 1:length(outSmoothEner{i})
for k= 1:length(outSmoothEner{i}{j})
s{i}{j}{k} = outSmoothEner{i}{j}{k};
gyroData{i}{j}{k}=outgyroData{i}{j}{k};
linearData{i}{j}{k}=outlinearData{i}{j}{k};
fs = 200;%采样频率
L = length(s{i}{j}{k});
t = (0:L-1)/fs;
Win = 200;                % number of section  即一个抬臂动作大致采样点个数
step = 8;
nff = Win;                % number of fft   短时傅里叶变换的个数
h = hamming(Win, 'periodic');   % Hamming weight function
ncl = fix( (L-Win)/step ) + 1;   % fix是指靠近0取整， 总长-样本长）/步伐+1=列数
Ps{i}{j}{k} = zeros(Win,ncl); % 行数为样本数，存储的每个样本包含汉明窗处理过的ncl个数据
highthreshold = 0.999
lowthreshold = 0.00004
%% 预处理 归一化
sNorm{i}{j}{k} = mapminmax(s{i}{j}{k},0,1); % mapminmax通过将每一行的最小值和最大值标准化为[0, 1]来处理矩阵

%% 短时傅里叶变换
Ps{i}{j}{k} = zeros(Win,ncl); % 行数为样本数，存储的每个样本包含汉明窗处理过的ncl个数据
for n = 1:ncl                   % Ps means Processed Signal  处理过的信号
    Ps{i}{j}{k}(:,n) = sNorm{i}{j}{k}( (n-1)*step+1 : (n-1)*step+Win).*h';%数据按列存储
end   

%% 短时傅里叶变换
% Short-time Fourier transform
STFT0{i}{j}{k} = fft(Ps{i}{j}{k},nff);
%  将fft变换后的模值转换成原来的幅值。
S{i}{j}{k} = abs(STFT0{i}{j}{k});%取模，除以n(采样点个数)
fax{i}{j}{k} = fs*(0:(nff/2))/nff;                           % 频率轴
tax{i}{j}{k} = (  .5*Win : step : L- .5*Win) / fs;   % 时间轴

%% 求一阶近似导数
%求差分，差分的样本点间隔为1
% 差分间隔为1的时候效果比4的时候好（切割出的字母包含的移动部分更少）
[m, n] = size(S{i}{j}{k});
sPart1{i}{j}{k} = S{i}{j}{k}(:,1:n - 1);
sPart2{i}{j}{k} = S{i}{j}{k}(:,2:n);  
radio{i}{j}{k} = sPart2{i}{j}{k} - sPart1{i}{j}{k};
radioNorm{i}{j}{k} = mapminmax(radio{i}{j}{k},0,1);%归一化一阶导数

%% 选取0.4Hz频率线的一阶导数
e{i}{j}{k} = radioNorm{i}{j}{k}(2,:);%选择第二行数据
eIndexTime{i}{j}{k} = [];
eIndexNum{i}{j}{k} = [];
for n = 2:(length(e{i}{j}{k})-1)
% % %     %过滤既是峰值又大于阈值的点
    if((e{i}{j}{k}(n) > e{i}{j}{k}(n-1)) && (e{i}{j}{k}(n) > e{i}{j}{k}(n+1)) && e{i}{j}{k}(n) > highthreshold)||((e{i}{j}{k}(n) < e{i}{j}{k}(n-1)) && (e{i}{j}{k}(n) < e{i}{j}{k}(n+1)) && e{i}{j}{k}(n) <lowthreshold)
        eIndexTime{i}{j}{k} = [eIndexTime{i}{j}{k} tax{i}{j}{k}(n+1)];
        eIndexNum{i}{j}{k} = [eIndexNum{i}{j}{k} fix(tax{i}{j}{k}(n+1)*fs)];
    end
end

%% 存储切割好的字母
SmoothEner1{i}{j}{k}(1,:)=outSmoothEner{i}{j}{k}(1,eIndexNum{i}{j}{k}(1):eIndexNum{i}{j}{k}(end));
gyroData1{i}{j}{k}(:,1:3)=outgyroData{i}{j}{k}(eIndexNum{i}{j}{k}(1):eIndexNum{i}{j}{k}(end),1:3);
linearData1{i}{j}{k}(:,1:3)=outlinearData{i}{j}{k}(eIndexNum{i}{j}{k}(1):eIndexNum{i}{j}{k}(end),1:3);
                         
%% 绘制时域信号图像
%{
figure;
subplot(2,1,1);
%p1=plot(t,sNorm{i}{j}{k},'Color','[0.5 0.5 1]');
titlename1 = strcat("Letter",char(j+64));
title("Normalized Signal and Frequency Line "+titlename1,'FontSize',30);
set(gca, 'LineWidth',1.25);
xlabel('Time(s)','FontSize',18,'Fontname', 'Times New Roman');
ylabel('Amplitude','FontSize',18,'Fontname', 'Times New Roman');

% 绘制0.78Hz频率线
freLineNorm{i}{j}{k} = mapminmax(S{i}{j}{k}(2,:),0,1);
hold on;p1=plot(tax{i}{j}{k},freLineNorm{i}{j}{k},'LineWidth',2,'color','blue');
% 绘制近似一阶导数
%%设置切割的阈值
hold on;p3=plot(tax{i}{j}{k}(1:length(radioNorm{i}{j}{k}(2,:))),radioNorm{i}{j}{k}(2,:),':k','LineWidth',2);axis tight;
hold on;p4=line([0 t(end)],[highthreshold highthreshold],'Color','g','LineStyle','--','LineWidth',2);
hold on;p5=line([0 t(end)],[lowthreshold lowthreshold],'Color','g','LineStyle','--','LineWidth',2);
%画出切割线，标出波峰
hold on;hh = axis;
for m = eIndexTime{i}{j}{k}
    plot([m,m], [hh(3),hh(4)],'r','LineWidth',2);%字母切割线
end

%画陀螺仪
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
%画陀螺仪
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
end %%k循环
end%% j循环
end%% i循环
end




















