% plot figure 4, correlations between erosion coefficient E, mud
% content, and mud layer frequency
%% correlations between erosion coefficient E, mud content in upstream reach
RK_cutoff = 36;%downstream bend number of river reach with substrate exposure
reachLgth = 5;%reach length as in number of bends, used for averaging
xtemp = mud_Sub(1:RK_cutoff-6);
% xtemp = C_freq(1:RK_cutoff-6);
ytemp = log(E(1:RK_cutoff-6));

ClayAve = movmean(xtemp,[reachLgth,reachLgth],'omitnan');
EAve = movmean(ytemp,[reachLgth,reachLgth]);
% ClayStd = movstd(xtemp,[reachLgth,reachLgth],'omitnan');
% EStd = movstd(ytemp,[reachLgth,reachLgth]);
ClayStd = movbootstrap(xtemp,reachLgth);
EStd = movbootstrap(ytemp,reachLgth);

figure(4); hold on
subplot(1,2,1);hold on
% plot(ClayAve,EAve,'o','markeredgecolor',cmap(i,:));
errorbar(ClayAve,EAve,EStd,'color',[.8 .8 .8],'LineStyle','none','CapSize',0)
errorbar(ClayAve,EAve,ClayStd,'horizontal','color',[.8 .8 .8],'LineStyle','none','CapSize',0)

scatter(ClayAve,EAve,[],RK_E(1:RK_cutoff-6)/1000,'filled','o')
clim([40 469]);
p1 = plot(ClayAve,EAve,'ok','markerfacecolor','none','markersize',6,...
    'LineWidth', 1);

[p,S] = polyfit(ClayAve,EAve,1); 
[E_fit,delta] = polyval(p,ClayAve,S);
% plot(ClayAve,E_fit,'-','Color',cmap(i,:))
p2 = plot(ClayAve,E_fit,'k-');
ylim([-14.5 -12.5]);


SStot = sum((EAve-mean(EAve)).^2);                    % Total Sum-Of-Squares
SSres = sum((EAve-E_fit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                           % R^2
text(0.05, 0.6,{sprintf('y = %.2fx + %.2f\nr^2 = %.2f',p(1),p(2),Rsq)},'HorizontalAlignment','left','unit','normalized','fontsize',8);

%% correlations between erosion coefficient E, mud content in downstream reach
reachLgth = 5;
% xtemp = mud_Sub(1:30);
% ytemp = E(1:30);
% xtemp = mud_Sub(RK_cutoff+1:81);
% ytemp = log(E(RK_cutoff+1:81));
xtemp = mud_Sub(36:70);
ytemp = log(E(36:70));

ClayAve = movmean(xtemp,[reachLgth,reachLgth],'omitnan');
EAve = movmean(ytemp,[reachLgth,reachLgth]);
% ClayStd = movstd(xtemp,[reachLgth,reachLgth],'omitnan');
% EStd = movstd(ytemp,[reachLgth,reachLgth]);
ClayStd = movbootstrap(xtemp,reachLgth);
EStd = movbootstrap(ytemp,reachLgth);

figure(4); hold on
subplot(1,2,1);hold on
% plot(ClayAve,EAve,'o','markeredgecolor',cmap(i,:));
errorbar(ClayAve,EAve,EStd,'color',[.8 .8 .8],'LineStyle','none','CapSize',0)
errorbar(ClayAve,EAve,ClayStd,'horizontal','color',[.8 .8 .8],'LineStyle','none','CapSize',0)

scatter(ClayAve,EAve,[],RK_E(36:70)/1000,'filled','^')
clim([40 469]);
p3 = plot(ClayAve,EAve,'^k','markerfacecolor','none','markersize',7);

[p,S] = polyfit(ClayAve,EAve,1); 
[E_fit,delta] = polyval(p,ClayAve,S);
% plot(ClayAve,E_fit,'-','Color',cmap(i,:))
plot(ClayAve,E_fit,'k-')
ylim([-14.5 -12.5]);

SStot = sum((EAve-mean(EAve)).^2);                    % Total Sum-Of-Squares
SSres = sum((EAve-E_fit).^2);                       % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;                          % R^2

text(0.05, 0.20,{sprintf('y = %.2fx + %.2f\nr^2 = %.2f',p(1),p(2),Rsq)},'HorizontalAlignment','left','unit','normalized','fontsize',8);

xlabel('% of cohesive material')
ylabel('log({\itE})');

%% frequency plot, correlation in upstream reach

RK_cutoff = 36;
% RK_cutoff = 42;
reachLgth = 5;
% xtemp = mud_Sub(1:RK_cutoff-6);
xtemp = C_freq(1:RK_cutoff-6);
ytemp = log(E(1:RK_cutoff-6));

ClayAve = movmean(xtemp,[reachLgth,reachLgth],'omitnan');
EAve = movmean(ytemp,[reachLgth,reachLgth]);
ClayStd = movbootstrap(xtemp,reachLgth);
EStd = movbootstrap(ytemp,reachLgth);

figure(4); hold on
subplot(1,2,2);hold on
errorbar(ClayAve,EAve,EStd,'color',[.8 .8 .8],'LineStyle','none','CapSize',0)
errorbar(ClayAve,EAve,ClayStd,'horizontal','color',[.8 .8 .8],'LineStyle','none','CapSize',0)

scatter(ClayAve,EAve,[],RK_E(1:RK_cutoff-6)/1000,'filled');
clim([40 469]);
p1 = plot(ClayAve,EAve,'ok','markerfacecolor','none','markersize',6,...
    'LineWidth', 1);

[p,S] = polyfit(ClayAve,EAve,1); 
[E_fit,delta] = polyval(p,ClayAve,S);
p2 = plot(ClayAve,E_fit,'k-');
ylim([-14.5 -12.5]);

SStot = sum((EAve-mean(EAve)).^2); % Total Sum-Of-Squares
SSres = sum((EAve-E_fit').^2); % Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;% R^2

text(0.4, 0.6,{sprintf('y = %.2fx + %.2f\nr^2 = %.2f',p(1),p(2),Rsq)},'HorizontalAlignment','left','unit','normalized','fontsize',8);


%% correlation in downstream reach
reachLgth = 5;

xtemp = C_freq(RK_cutoff+1:70);
ytemp = log(E(RK_cutoff+1:70));

ClayAve = movmean(xtemp,[reachLgth,reachLgth],'omitnan');
EAve = movmean(ytemp,[reachLgth,reachLgth]);
ClayStd = movbootstrap(xtemp,reachLgth);
EStd = movbootstrap(ytemp,reachLgth);

figure(4); hold on
subplot(1,2,2);hold on
errorbar(ClayAve,EAve,EStd,'color',[.8 .8 .8],'LineStyle','none','CapSize',0)
errorbar(ClayAve,EAve,ClayStd,'horizontal','color',[.8 .8 .8],'LineStyle','none','CapSize',0)

scatter(ClayAve,EAve,[],RK_E(RK_cutoff+1:70)/1000,'filled','^');
clim([40 469]);
p3 = plot(ClayAve,EAve,'^k','markerfacecolor','none','markersize',7);

[p,S] = polyfit(ClayAve,EAve,1); 
[E_fit,delta] = polyval(p,ClayAve,S);
plot(ClayAve,E_fit,'k-')
ylim([-14.5 -12.5]);

SStot = sum((EAve-mean(EAve)).^2);% Total Sum-Of-Squares
SSres = sum((EAve-E_fit').^2);% Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;% R^2

text(0.2, 0.1,{sprintf('y = %.2fx + %.2f\nr^2 = %.2f',p(1),p(2),Rsq)},'HorizontalAlignment','left','unit','normalized','fontsize',8);
xlabel('layer frequency \itf')
ylabel('log({\itE})');

subplot(1,2,1);hold on
text(.2, .95,{'A'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(1,2,2);hold on
text(.2, .95,{'B'},'HorizontalAlignment','left','unit','normalized','fontsize',9)

legend([p3 p1 p2],{'RK 40 - 254','RK 293 - 469','regression fit'},'Box','off');
cb = colorbar('XTick', [40,254,468],'XTickLabel',{'40','254','468'});
set(cb,'Position',[.82 .55 .02 .2])% To change size
yl = ylabel(cb,'RK');
% yl.Position(2) = min(xlim(cb))-1;
% yl.VerticalAlignment = 'bottom';

set(gcf,'unit','inch','Position',[1 1 9 4])
