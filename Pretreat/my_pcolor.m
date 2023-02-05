function [  ] = my_pcolor( f , t , s )
%MY_PCOLOR 绘图函数
% Input            
%       f               - 频率轴矩阵
%       t               - 时间轴矩阵
%       s               - 幅度轴矩阵

    gca = pcolor(f,t,s);                      % 绘制伪彩色图
        set(gca, 'LineStyle','none');         % 取消网格，避免一片黑
    handl = colorbar;                         % 彩图坐标尺
        set(handl, 'FontName', 'Times New Roman', 'FontSize', 30)
        ylabel(handl, 'Magnitude')        % 坐标尺名称
end