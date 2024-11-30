%plot figure 3 b and c
%load sediment layer statistics
NC_mean = readmatrix('layerStatistics.xlsx','Sheet','Sheet1','Range','C3:C83');%mean thickness of noncohesive sediment layer
NC_freq = readmatrix('layerStatistics.xlsx','Sheet','Sheet1','Range','D3:D83');%frequency of noncohesive sediment layer
C_mean = readmatrix('layerStatistics.xlsx','Sheet','Sheet1','Range','E3:E83');%mean thickness of cohesive sediment layer
C_freq = readmatrix('layerStatistics.xlsx','Sheet','Sheet1','Range','F3:F83');%frequency of cohesive sediment layer

figure(3);hold on
subplot(3,2,2);hold on
plot(RK_E/1e3,NC_mean,'o','markeredgecolor','w','markerfacecolor',[.6 .6 .6],'MarkerSize',5)
plot(RK_E/1e3,movmean(NC_mean,[5,5],'omitnan'),'color',[.6 .6 .6],'LineWidth',1.5);
plot(RK_E/1e3,C_mean,'^','markeredgecolor','w','markerfacecolor','k','MarkerSize',5)
plot(RK_E/1e3,movmean(C_mean,[5,5],'omitnan'),'color','k','LineWidth',1.5);
set(gca,'yscale','log')
ylabel('mean layer thickness (m)');
xlabel('river kilometer (RK)');


figure(3);hold on
subplot(3,2,3);hold on
h1 = plot(RK_E/1e3,NC_freq,'o','markeredgecolor','w','markerfacecolor',[.6 .6 .6],'MarkerSize',5);
h2 = plot(RK_E/1e3,movmean(NC_freq,[5,5],'omitnan'),'color',[.6 .6 .6],'LineWidth',1.5);
h3 = plot(RK_E/1e3,C_freq,'^','markeredgecolor','w','markerfacecolor','k','MarkerSize',5);
h4 = plot(RK_E/1e3,movmean(C_freq,[5,5],'omitnan'),'color','k','LineWidth',1.5);
set(gca,'yscale','log')
ylabel('layer frequency');
xlabel('river kilometer (RK)');
legend([h1, h2, h3, h4],{'non-cohesive','move mean','cohesive','move mean'},...
    'Location','southwest','box','off')

subplot(3,2,1);hold on
text(.1, .93,{'A'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(3,2,2);hold on
text(.1, .93,{'B'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(3,2,3);hold on
text(.1, .93,{'C'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(3,2,4);hold on
text(.1, .93,{'D'},'HorizontalAlignment','left','unit','normalized','fontsize',9)

