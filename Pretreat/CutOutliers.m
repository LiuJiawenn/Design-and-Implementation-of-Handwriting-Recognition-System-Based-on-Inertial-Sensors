function [Data] = CutOutliers(OldData)
Data = OldData;

%{ 
������Լ��ٶȣ������ǣ��������ٶ���xyz��������Ϊ0�����
ֻ�۲�ǰ100������
�ҵ�������ֵΪ0����ô�������ֵ��ƽ��ֵ���������
���ڴ�СΪ10
%}
for i=1:length(Data)
    for j=[18 19 20 6 7 8 15 16 17 ]  %������Լ��ٶȣ������ǣ��������ٶ�
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
������Լ��ٶȣ������ǣ��������ٶ���xyz������е��쳣ֵ
�۲���������
�����һ�����ֵ>2����������Χ�������15��������Ϊ0.
ǰ��5��������ֵ����쳣ֵ
%}
%������һ��bug�������ƽ��ֵ������0
Times = 15; % 15����
for i=1:length(Data)
    for j=[18 19 20 6 7 8 ]
        Loc = find(abs(Data{i}(:,j)) > 2);%find��ȡ�����Լ�ֵ
        if(~isempty(Loc))
            for Del=1:length(Loc) %�쳣ֵ��λ��
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


