function [  ] = my_pcolor( f , t , s )
%MY_PCOLOR ��ͼ����
% Input            
%       f               - Ƶ�������
%       t               - ʱ�������
%       s               - ���������

    gca = pcolor(f,t,s);                      % ����α��ɫͼ
        set(gca, 'LineStyle','none');         % ȡ�����񣬱���һƬ��
    handl = colorbar;                         % ��ͼ�����
        set(handl, 'FontName', 'Times New Roman', 'FontSize', 30)
        ylabel(handl, 'Magnitude')        % ���������
end