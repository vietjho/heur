clc
clear vars
clear all
close all
%
n = 500;
k = 50; %the number of instances has the same (n,p1,p2)
%==========================================================================
%AS algorithm: count the perfect and maximal matchings
%
AS_num_stable_matchings = [];
AS_num_perfect_matching = []; 
AS_num_maximal_matching = [];
AS_avg_maximal_matching = [];
for p1 = 0.1:0.1:0.8
    num_stable_matchings = [];
    num_perfect_matching = [];
    num_maximal_matching = [];
    avg_maximal_matching = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output500\AS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        %count for instances
        s = 0; %for stable matchings
        p = 0; %for the perfect matchings
        m = 0; %for the maximal matchings
        x = 0; %for average cost of maximal matchings
        for i = 1:k
            if (f_results(i,3) == 1)
                s = s + 1;
            end
            if (f_results(i,2) == 0)&&(f_results(i,3) == 1)
                p = p + 1;
            end
            if (f_results(i,2) ~= 0)&&(f_results(i,3) == 1)
                m = m + 1;
                x = x + f_results(i,2);
            end
        end
        num_stable_matchings(end+1) = s;
        num_perfect_matching(end+1) = p;
        num_maximal_matching(end+1) = m;
        if (m ==0)
            avg_maximal_matching(end+1) = 0;
        else
            avg_maximal_matching(end+1) = x/m;
        end
    end
    AS_num_stable_matchings = [AS_num_stable_matchings; num_stable_matchings];
    AS_num_perfect_matching = [AS_num_perfect_matching; num_perfect_matching];
    AS_num_maximal_matching = [AS_num_maximal_matching; num_maximal_matching];
    AS_avg_maximal_matching = [AS_avg_maximal_matching; avg_maximal_matching];
end
%==========================================================================
%MCS algorithm: count the perfect, maximal and unstable matchings
%
MCS_num_stable_matchings = [];
MCS_num_perfect_matching = []; 
MCS_num_maximal_matching = [];
MCS_avg_maximal_matching = [];
for p1 = 0.1:0.1:0.8
    num_stable_matchings = [];
    num_perfect_matching = [];
    num_maximal_matching = [];
    avg_maximal_matching = [];
    for p2 = 0.0:0.1:1.0
        %load to file for averaging results
        filename = ['output500\MCS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),').mat'];
        load(filename,'f_results');
        %count for instances
        s = 0; %for stable matchings
        p = 0; %for the perfect matchings
        m = 0; %for the maximal matchings
        x = 0; %for average cost of maximal matchings
        for i = 1:k
            if (f_results(i,3) == 1)
                s = s + 1;
            end
            if (f_results(i,2) == 0)&&(f_results(i,3) == 1)
                p = p + 1;
            end
            if (f_results(i,2) ~= 0)&&(f_results(i,3) == 1)
                m = m + 1;
                x = x + f_results(i,2);
            end
        end
        num_stable_matchings(end+1) = s;
        num_perfect_matching(end+1) = p;
        num_maximal_matching(end+1) = m;
        if (m ==0)
            avg_maximal_matching(end+1) = 0;
        else
            avg_maximal_matching(end+1) = x/m;
        end
    end
    MCS_num_stable_matchings = [MCS_num_stable_matchings; num_stable_matchings];
    MCS_num_perfect_matching = [MCS_num_perfect_matching; num_perfect_matching];
    MCS_num_maximal_matching = [MCS_num_maximal_matching; num_maximal_matching];
    MCS_avg_maximal_matching = [MCS_avg_maximal_matching; avg_maximal_matching];
end
%
%==========================================================================
AS_num_stable_matchings = AS_num_stable_matchings*100/50;
AS_num_perfect_matching = AS_num_perfect_matching*100/50;
%
MCS_num_stable_matchings = MCS_num_stable_matchings*100/50;
MCS_num_perfect_matching = MCS_num_perfect_matching*100/50;
%
%Percentage of perfect matchings
% type = 1;
% AS_plot_data = AS_num_perfect_matching';
% MCS_plot_data  = MCS_num_perfect_matching';
%
%Average cost of stable matchings
type = 2;
AS_plot_data = AS_avg_maximal_matching';
MCS_plot_data  = MCS_avg_maximal_matching';
%
%create a figure (left,top,width,height) 
figure('position',[50, 50, 800, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100, 100, 475, 375]);
hold on
%
AS_line1 = plot(AS_plot_data(11,:),'--bs','MarkerEdgeColor','k','MarkerSize',9,'LineWidth',1.5);
MCS_line1 = plot(MCS_plot_data(11,:),'--rs','MarkerEdgeColor','k','MarkerFaceColor','k','MarkerSize',9,'LineWidth',1.5);
%=========================================================================
hand = legend('AS {\it p_2} = 1.0','MCS {\it p_2} = 1.0');
%for layout of figure
set(hand,'FontSize',17,'Position',[0.79,0.7,0.1,0.2]);  
legend('boxoff')
set(gcf,'color','w');
xlim([1,8]);
%xticks(0:8);
xticklabels({'0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8'})
%
hx = xlabel('{\it p_1}','color','k');
set(hx, 'FontSize', 20)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',20)
%
if (type == 1)
    ylim([0,105]);
    yticks(0:10:105);
    hy = ylabel('Percentage of perfect matchings','color','k');
else
    ylim([0,3.0]);
    yticks(0:0.5:3.0);
    hy = ylabel('Average number of singles','color','k');
end
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
