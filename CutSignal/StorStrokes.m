%% Strokes_cutSignal 只有切割位置标记，这里将切割好的数据放入数组

function [outgyroData,outlinearData,out_SmoothEner] = StoeStrokes(SmoothEner,gyrodata,lineardata,Strokes_cutSignal  )
out_SmoothEner= cell(1,length(Strokes_cutSignal ));
outgyroData = cell(1,length(Strokes_cutSignal ));
outlinearData= cell(1,length(Strokes_cutSignal ));
for i=1:length(Strokes_cutSignal )
    for j=1:length(Strokes_cutSignal {i})
        for k=1:length(Strokes_cutSignal {i}{j}(:,1))%如果不加最后的(:,1)，对只有一笔的字母不友好
            outgyroData{i}{j}{k} = gyrodata{i}{j}((Strokes_cutSignal {i}{j}(k,1):Strokes_cutSignal {i}{j}(k,2)),:);
            outlinearData{i}{j}{k}= lineardata{i}{j}(Strokes_cutSignal {i}{j}(k,1):Strokes_cutSignal {i}{j}(k,2),:);
            out_SmoothEner{i}{j}{k}(:,1) = SmoothEner{i}{j}(Strokes_cutSignal {i}{j}(k,1):Strokes_cutSignal {i}{j}(k,2),:);
        end
    end
end
end




