clc
clear vars
clear all
close all
n = 500;
%==========================================================================
%AS algorithm
AS_time = [];
for p1 = 0.1:0.1:0.8
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output500\AS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    AS_time = [AS_time;f_avg_time];
end
%==========================================================================
%for MCS
MCS_time = [];
for p1 = 0.1:0.1:0.8
    f_avg_time = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output500\MCS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        f_avg_time(end+1) = mean(f_results(:,1));
    end
    MCS_time = [MCS_time;f_avg_time];
end
%==========================================================================
%
%AS_time = log10(AS_time);
%MCS_time  = log10(MCS_time);
%
%for plot figures
rows = 1:8;
AS_plot_data = AS_time(rows,:);
MCS_plot_data  = MCS_time(rows,:);
%
%create a figure (left,top,width,height) 
figure('position',[50, 50, 1000, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100, 100, 600, 360]);
hold on
%---------------------------------------------------------------
[P2,P1] = meshgrid([0.0:0.1:1.0],[0.1:0.1:0.8]);
h1 = surf(P2,P1,AS_plot_data,'FaceAlpha',0.5);
h2 = surf(P2,P1,MCS_plot_data,'FaceAlpha',0.7);
%
[~,h_legend] = legend([h1,h2], {'AS', 'MCS'},'FontSize',17);
PatchInLegend = findobj(h_legend, 'type', 'patch');
set(PatchInLegend(1),'FaceAlpha', 0.5);
set(PatchInLegend(2),'FaceAlpha', 0.7);
%
set(gcf,'color','w');
xticks(0.0:0.1:1.0);
xticklabels({' 0.0','','0.2','','0.4','','0.6','','0.8','','1.0'})
xlim([0,1]);
%
yticks(0.1:0.1:0.8);
ylim([0.1,0.8]);
yticklabels({'0.1 ','0.2 ','0.3 ','0.4 ','0.5 ','0.6 ','0.7 ','0.8 '})
%
zlim([0,70]);
zticks(0:10:70);
%
hx = xlabel('{\it p_2}','color','k');
set(hx, 'FontSize', 20)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',20)
%
hy = ylabel('{\it p_1}','color','k');
set(hy, 'FontSize', 20)
hxb = get(gca,'YTickLabel');
set(gca,'YTickLabel',hxb,'fontsize',20)
%
hz = zlabel('Average execution time (sec.)','color','k');
set(hz,'FontSize',20)
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
%}