clc
clear vars
clear all
close all
%==========================================================================
%for size of 500
MCS_time = zeros(4,11);
MCS_iter = zeros(4,11);
MCS_rset = zeros(50,4);
p1 = 0.5;
for n = 500
    f_avg_time = [];
    f_avg_iter = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output500\MCS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        %printf for checking results
        %for i = 1:size(f_results,1)
        %    fprintf('\nI(%d,%0.1f,%0.1f)-%d: ',n,p1,p2,i);
        %    fprintf('time = %6.3f, f(M)=%d, stable=%d, iters=%d, reset=%d',f_results(i,1),f_results(i,2),f_results(i,3),f_results(i,4),f_results(i,5));
        %end
        f_avg_time(end+1) = mean(f_results(:,1));
        f_avg_iter(end+1) = mean(f_results(:,4));
        if (p2 == 1.0)
            MCS_rset(:,1) = f_results(:,5);
        end
    end
    MCS_time(1,:) = f_avg_time;
    MCS_iter(1,:) = f_avg_iter;
end
%
%for sizes of 700, 900, 1200
p1 = 0.5;
k = 2;
ns = [700,900,1200];
for t = 1:size(ns,2)
    n = ns(t);
    f_avg_time = [];
    f_avg_iter = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output700\MCS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        %printf for checking results
        %for i = 1:size(f_results,1)
        %    fprintf('\nI(%d,%0.1f,%0.1f)-%d: ',n,p1,p2,i);
        %    fprintf('time = %6.3f, f(M)=%d, stable=%d, iters=%d, reset=%d',f_results(i,1),f_results(i,2),f_results(i,3),f_results(i,4),f_results(i,5));
        %end
        f_avg_time(end+1) = mean(f_results(:,1));
        f_avg_iter(end+1) = mean(f_results(:,4));
        if (p2 == 1.0)
            MCS_rset(:,k) = f_results(:,5);
        end
    end
    MCS_time(k,:) = f_avg_time;
    MCS_iter(k,:) = f_avg_iter;
    k = k + 1;
end
%
%==========================================================================
%
%for plot figures
% type = 1;
% MCS_plot_data  = MCS_time;

% type = 2;
% MCS_plot_data  = MCS_iter;
% %
type = 3;
MCS_plot_data  = MCS_rset;
%
%create a figure (left,top,width,height) 
figure('position',[50, 50, 800, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100, 100, 475, 375]);
hold on
%
if (type ==1) || (type == 2)
%for MCS - lines
MCS_line1 = plot(MCS_plot_data(1,:),'--r>','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.5);
MCS_line2 = plot(MCS_plot_data(2,:),'--bs','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.5);
MCS_line3 = plot(MCS_plot_data(3,:),'--ko','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.5);
MCS_line4 = plot(MCS_plot_data(4,:),'--r^','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.5);
%
%=========================================================================
%for n = 500, 700, 900, 1200
hand = legend([MCS_line4,MCS_line3,MCS_line2,MCS_line1],'{\it n} = 1200','{\it n} =   900',...
               '{\it n} =   700','{\it n} =   500');  
%=========================================================================
hx = xlabel('{\it p_2}','color','k');
%for layout of figure
set(hand,'FontSize',17,'Position',[0.74 0.71 0.176 0.23]);  
legend('boxoff')
end
%
if (type == 1)
    xlim([1 11]);
    xticks(1:11);
    xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
    hy = ylabel('Average execution time (sec.)','color','k');
    ylim([0,520]);
    yticks([0:50:500]);
end
if (type == 2)
    xlim([1 11]);
    xticks(1:11);
    xticklabels({'0.0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'});
    hy = ylabel('Average number of iterations','color','k');
end

if (type == 3)
    x = 1:4;
    h1 = errorbar(x,mean(MCS_plot_data,1),std(MCS_plot_data,[],1),'--rs','MarkerSize',10,...
     'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1.5,'CapSize',15);
 
    %bar([1:4],MCS_plot_data,0.5);
    xlim([1 4]);
    xticks(1:4);
    xticklabels({'{\it n} = 500','{\it n} = 700','{\it n} = 900','{\it n} = 1200'});
    hx = xlabel('','color','k');
    hy = ylabel('        Average number of \newline calling the escape function');
end
%
set(gcf,'color','w');
set(hx, 'FontSize', 20)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',20)
%
set(hy,'FontSize',20)
%
grid on
ax = gca;
set(ax,'GridLineStyle','--') 
ax.XGrid = 'on';
ax.YGrid = 'on';
ax.GridColor = [0 0 0];
ax.GridLineStyle = '--';
ax.GridAlpha = 0.4;
box on