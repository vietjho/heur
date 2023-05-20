clc
clc
clear vars
clear all
close all
%create a figure (left,top,width,height) 
figure('position',[50, 50, 800, 500]); 
set(axes, 'Units', 'pixels', 'Position', [100, 100, 500, 300]);
hold on
%
n = 700; %the size of SMTI instances
k = 50;  %the number of instances has the same (n,p1,p2)
f_num_ubps = zeros(1,500);
j = 1;
p1 = 0.5;
for p2 = 0.0:0.1:1.0
    i = 1;
    y = zeros(50,500);
    while (i <= k)
        filename2 = ['ubps700\MCS(',num2str(n),',',num2str(p1,'%.1f'),',',num2str(p2,'%.1f'),')-',num2str(i),'.mat'];
        load(filename2,'f_nbps');
        y(i,1:size(f_nbps,2)) = f_nbps;
        i = i + 1;    
    end
    y1 = mean(y,1);
    %
    %[P2,P1] = meshgrid([1:1:size(y1,2)],[j-1]);
    %plot3(P1,P2,y1,'Linewidth',1.5);
    f_num_ubps(j,1:size(y1,2)) = y1;
    j = j + 1;
end
%
iter = 1:25:size(f_num_ubps,2);
y = f_num_ubps(:,iter);
[P2,P1] = meshgrid([1:1:size(y,2)],[0:1:10]);
%surf(P1,P2,y,'FaceAlpha',0.5);
mesh(P1,P2,y,'FaceAlpha',0.5,'LineWidth',1);

set(gcf,'color','w');
xticks(0:1:10);
xticklabels({' 0.0','','0.2','','0.4','','0.6','','0.8','','1.0'})
xlim([0,10]);
%
ylim([0,size(f_num_ubps,2)/25]);
%yticks(25*[0:20:size(f_num_ubps,2)/25]);
yticklabels(25*[0:20:size(f_num_ubps,2)/25])

%
zlim([0,700]);
zticks(0:100:700);
%
hx = xlabel('{\it p_2}','color','k');
set(hx, 'FontSize', 20)
hxa = get(gca,'XTickLabel');
set(gca,'XTickLabel',hxa,'fontsize',20)
%
hy = ylabel('Iterations','color','k');
set(hy, 'FontSize', 20)
hxb = get(gca,'YTickLabel');
set(gca,'YTickLabel',hxb,'fontsize',20)
%
hz = zlabel('Average number of UBPs','color','k');
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