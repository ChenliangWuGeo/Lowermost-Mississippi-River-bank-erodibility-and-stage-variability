%combine sand and silt, and plot figure 3 a and d
figure(3);hold on
subplot(3,2,1);hold on
plot(RK_E/1e3,mud_Sub,marker(m),'markeredgecolor','w','markerfacecolor','k','MarkerSize',5);
plot(RK_E/1e3,movmean(mud_Sub,[5,5],'omitnan'),'color','k','LineWidth',1.5);
ylabel('percentage');
xlabel('river kilometer (RK)');
xlim([0,500]);
ylim([0 100]);
set(gca, 'Layer', 'top','color',[1 1 1])

%combine sand and silt
nonCohesive = siltPrct+sandPrct;
tempx = nonCohesive;
tempx(outliers) = nan;%Lafoure branch, and ancient shorelines
tempy = nonCohesive(~isnan(tempx));
tempx = RK_E(~isnan(tempx));%need to do tempy first, before update tempx
p = polyfit(tempx'/1e3,tempy',3);
ypred2 = polyval(p,tempx'/1e3);
if m == 2 
    ypred3 = polyval(p,RK_E/1e3);
    mudPrct2 = ypred3;
end

figure(3);hold on
subplot(3,2,1);hold on
plot(RK_E/1e3,nonCohesive,'o','markeredgecolor','w','markerfacecolor',[.6 .6 .6],'MarkerSize',5);
plot(RK_E/1e3,movmean(nonCohesive,[5,5],'omitnan'),'color',[.6 .6 .6],'LineWidth',1.5);

%% plot E
figure(3);hold on
subplot(3,2,4);hold on
predE = movmean(E,10);
x = RK_E'/1e3;
h5 = plot(x,E,'hexagram','markeredgecolor','w','markerfacecolor','k','markersize',6);
h6 = plot(RK_E'/1e3,predE,'k:','linewidth',1.5);  
legend([h5,h6],{'bend \itE','move mean ({\itE})'},'location','best','box','off');

% xlabel('river kilometer (RK)');
ylabel('eronsion coefficient (\it{E})');
xlabel('river kilometer (RK)');

