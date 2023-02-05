function [Data] = CutOutliers(OldData)
Data = OldData;

%{ 
针对线性加速度，陀螺仪，重力加速度量xyz轴分量最初为0的情况
只观察前100行数据
找到其中数值为0的项，用窗口中数值的平均值将其替代。
窗口大小为10
%}
for i=1:length(Data)
    for j=[18 19 20 6 7 8 15 16 17 ]  %针对线性加速度，陀螺仪，重力加速度
        % slide window  50 10
        k=1;Win =10;step=1;
        while(k<10)
            Range = Data{i}(k:k+Win,j);
            RangeInd1 = find(abs(Range)==0);
            Data{i}(RangeInd1 + k-1,j) =mean(Range);
            k = k + step;
        end
    end
end

%{ 
针对线性加速度，陀螺仪，重力加速度量xyz轴分量中的异常值
观察所有数据
如果有一个点的值>2，且它比周围两个点大15倍，则置为0.
前后5个正常数值替代异常值
%}
%这里有一个bug求出来的平均值可能是0
Times = 15; % 15倍率
for i=1:length(Data)
    for j=[18 19 20 6 7 8 ]
        Loc = find(abs(Data{i}(:,j)) > 2);%find获取坐标以及值
        if(~isempty(Loc))
            for Del=1:length(Loc) %异常值的位置
                Thevalue= abs(Data{i}(Loc(Del),j));
                if(Loc(Del)-5>0 &&Loc(Del)-1>0)
                    LeftValue = mean(abs(Data{i}(Loc(Del)-5:Loc(Del)-1,j)));
                elseif(Loc(Del)-1>0)
                    LeftValue = mean(abs(Data{i}(1:Loc(Del)-1,j)));
                else
                    LeftValue = abs(Data{i}(1,j));
                end
                
                if(Loc(Del)+5<length(Data{i}) && Loc(Del)+1<length(Data{i}))
                    RightValue = mean(abs(Data{i}(Loc(Del)+1:Loc(Del)+5,j)));
                elseif(Loc(Del)+1<length(Data{i}))
                    RightValue = mean(abs(Data{i}(Loc(Del)+1:length(Data{i},j))));
                else
                    RightValue = abs(Data{i}(Loc(Del),j));
                end
                
                if(LeftValue*Times < Thevalue || RightValue*Times < Thevalue)
                    Data{i}(Loc(Del),j) = (LeftValue+RightValue)/2;
                end 
            end
        end
    end
end

end


