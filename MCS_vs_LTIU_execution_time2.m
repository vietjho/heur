clc
clear vars
clear all
close all
n = 100;
%==========================================================================
%LTIU algorithm
LTIU_time = [];
for p1 = 0.1:0.1:0.8
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output100\LTIU(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    LTIU_time = [LTIU_time;f_avg_time];
end
%==========================================================================
%for MCS
MCS_time = [];
for p1 = 0.1:0.1:0.8
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output100\MCS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    MCS_time = [MCS_time;f_avg_time];
end
%==========================================================================
%
LTIU_time = log10(LTIU_time);
MCS_time  = log10(MCS_time);
%
%for plot figures
% %create a figure (left,top,width,height) 
figure('position',[50, 50, 800, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100, 100, 500, 380]);
hold on
%
x = 1:8;
h1 = errorbar(x,mean(LTIU_time,2),std(LTIU_time,[],2),'--rs','MarkerSize',10,...
     'MarkerEdgeColor','k','LineWidth',1.5,'CapSize',12);
%
h2 = errorbar(x,mean(MCS_time,2),std(MCS_time,[],2),'--bo','MarkerSize',10,...
    'MarkerEdgeColor','k','LineWidth',1.5,'CapSize',12);
% %=========================================================================
 [hand,icons] = legend([h1,h2],{'LTIU','MCS'},'Fontsize',17);  
% %=========================================================================
% %for layout of figure
set(hand,'Position',[0.76, 0.78, 0.21, 0.2]);  
legend('boxoff')
% or for Patch plots 
objhl = findobj(icons, 'type', 'patch');
set(objhl, 'Markersize', 12);

set(gcf,'color','w');
%
xlim([1 8]);
xticks(1:8);
xticklabels(0.1:0.1:0.8)
hx = xlabel('{\it p_1}','color','k');
set(hx, 'FontSize', 20)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',20)
%
ylim([-2,2]);
yticks(-2:0.5:2);
hy = ylabel('Average execution time (log10 sec.)','color','k');
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