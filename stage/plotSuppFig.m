figure;hold on
subplot(2,2,1);hold on
p1 = plot(StBR, u,'o','color',[.6 .6 .6],'markersize',2);
p2 = plot(stageH,u_m,'o','MarkerEdgeColor','w','MarkerFaceColor','k');
xlabel('stage (ft)');
ylabel('{\itu}');
set(gca, 'Layer', 'top','color',[1 1 1])

subplot(2,2,2);hold on
p3 = plot(Qw,Cf,'o','MarkerEdgeColor','w','MarkerFaceColor','k');
p4 = plot(Qw,f1.p1 * Qw + f1.p2,'-k');
xlabel('{\itQ_w} (m^3/s)');
ylabel('{\itC_f}');
set(gca, 'Layer', 'top','color',[1 1 1])

SStot = sum((Cf-mean(Cf)).^2);% Total Sum-Of-Squares
SSres = sum((Cf-(f1.p1 * Qw + f1.p2)).^2);% Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;% R^2
text(0.05, 0.15,{sprintf('y = %.2ex + %.2e\nr^2 = %.2f',f1.p1,f1.p2,Rsq)},'HorizontalAlignment','left','unit','normalized','fontsize',8);



subplot(2,2,3);hold on
p7 = plot(QwVe,StVe,'o','color',[.6 .6 .6],'markersize',2);
temp = linspace(-1,5);
p8 = plot(f3.a * exp(f3.b * temp),temp,'k-');
xlim([0 40000]);
xlabel('{\itQ_w} (m^3/s)');
ylabel('stage {\itT} (ft)');
set(gca, 'Layer', 'top','color',[1 1 1])

tempx = StVe(~isnan(QwVe));
tempy = QwVe(~isnan(QwVe));
tempy = tempy(~isnan(tempx));
tempx = tempx(~isnan(tempx));
SStot = sum((tempy-mean(tempy)).^2);% Total Sum-Of-Squares
SSres = sum((tempy-(f3.a * exp(f3.b * tempx))).^2);% Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;% R^2
text(0.35, 0.15,{sprintf('{Q_w} = %.2ee^{%.2e{T}}\nr^2 = %.2f',f3.a,f3.b,Rsq)},'HorizontalAlignment','left','unit','normalized','fontsize',8);



subplot(2,2,4);hold on
p5 = plot(Qw,U,'o','MarkerEdgeColor','w','MarkerFaceColor','k');
p6 = plot(QwVe2,uVe,'-k');
xlabel('{\itQ_w} (m^3/s)');
ylabel('{\itu}');
set(gca, 'Layer', 'top','color',[1 1 1])

temp = f2.p1 * Qw.^2 + f2.p2 * Qw + f2.p3;
SStot = sum((U-mean(U)).^2);% Total Sum-Of-Squares
SSres = sum((U-temp).^2);% Residual Sum-Of-Squares
Rsq = 1-SSres/SStot;% R^2
text(0.05, 0.75,{sprintf('y = %.2ex^2 + %.2ex + %.2e\nr^2 = %.2f',f2.p1,f2.p2,f2.p3,Rsq)},'HorizontalAlignment','left','unit','normalized','fontsize',8);


subplot(2,2,1);hold on
text(.1, .93,{'A'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(2,2,2);hold on
text(.1, .93,{'B'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(2,2,3);hold on
text(.1, .93,{'C'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(2,2,4);hold on
text(.1, .93,{'D'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
