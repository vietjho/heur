clc
clear vars
clear all
close all
n = 500;
%==========================================================================
%AS algorithm
AS_iters = [];
AS_rsets = [];
for p1 = 0.1:0.1:0.8
    f_avg_iter = [];
    f_avg_rset = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output500\AS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        f_avg_iter(end+1) = mean(f_results(:,4));
        f_avg_rset(end+1) = mean(f_results(:,5));
    end
    AS_iters = [AS_iters;f_avg_iter];
    AS_rsets = [AS_rsets;f_avg_rset];
end
%==========================================================================
%for MCS
MCS_iters = [];
MCS_rsets = [];
for p1 = 0.1:0.1:0.8
    f_avg_iter = [];
    f_avg_rset = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output500\MCS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        f_avg_iter(end+1) = mean(f_results(:,4));
        f_avg_rset(end+1) = mean(f_results(:,5));
    end
    MCS_iters = [MCS_iters;f_avg_iter];
    MCS_rsets = [MCS_rsets;f_avg_rset];
end
%==========================================================================
%plot 2D
%for plot figures
%
% type = 1;
% AS_plot_data = AS_iters;
% MCS_plot_data = MCS_iters;
%
type = 2;
AS_plot_data = log10(AS_rsets);
MCS_plot_data = log10(MCS_rsets);
%
%create a figure (left,top,width,height) 
figure('position',[50, 50, 800, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100 100 440 375]);
hold on
%
if type == 1
    x = 1:8;
    AS_plot_data1 = AS_plot_data(:,1:10);
    MCS_plot_data1 = MCS_plot_data(:,1:10);

    h1 = errorbar(x,mean(AS_plot_data1,2),std(AS_plot_data1,[],2),'--rs','MarkerSize',6,...
         'MarkerEdgeColor','r','LineWidth',1.5,'CapSize',12);

    h2 = plot(AS_plot_data(:,11),'--b^','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.5);

     %
    h3 = errorbar(x,mean(MCS_plot_data1,2),std(MCS_plot_data1,[],2),'--bo','MarkerSize',6,...
        'MarkerEdgeColor','b','LineWidth',1.5,'CapSize',12);

    h4 = plot(MCS_plot_data(:,11),'--r^','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.5);

    [hand] = legend([h1,h2,h3,h4],...
                   {'AS {\it p_2} \in [0.0,0.9]','AS {\it p_2} = 1.0',...
                   'MCS {\it p_2} \in [0.0,0.9]','MCS {\it p_2} = 1.0'},'Fontsize',17);  
end
if type == 2
    x = 1:8;
    AS_plot_data1 = AS_plot_data(:,1:10);
   
    h1 = errorbar(x,mean(AS_plot_data1,2),std(AS_plot_data1,[],2),'--bs',...
         'LineWidth',1.5,'CapSize',12);

    h2 = plot(AS_plot_data(:,11),'--b^','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.5);

     %
    h4 = plot(MCS_plot_data(:,11),'--r^','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.5);

    [hand] = legend([h1,h2,h4],...
                   {'AS {\it p_2} \in [0.0,0.9]','AS {\it p_2} = 1.0',...
                   'MCS {\it p_2} = 1.0'},'Fontsize',17);  
end
%=========================================================================
%for layout of figure
set(hand,'Position',[0.76, 0.19, 0.2, 0.77]);  
legend('boxoff')
set(gcf,'color','w');
xlim([1 8]);
%xticks(1:11);
xticklabels({'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8'})
if (type ==1)
    ylim([0,3100]);
end
%yticks(10:5:50);
%
hx = xlabel('{\it p_1}','color','k');
set(hx, 'FontSize', 20)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',20)
%
if (type == 1)
    hy = ylabel('Average number of iterations','color','k');
else
    hy = ylabel('Average number of resets (log10)','color','k');
end
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
%}