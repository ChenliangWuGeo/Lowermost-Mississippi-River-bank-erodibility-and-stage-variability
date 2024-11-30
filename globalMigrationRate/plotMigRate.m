figure;hold on
xlabeltext = {"CoV (Qw)","yearly average CoV (Qf)","yearly average CoV (Qw)"};
temp = (DV(:,2));
sz = log(temp).^2;   
x = DV(:,7);
y = log10(migRate);
x(isnan(y))=[];
sz(isnan(y))=[];
y(isnan(y))=[];
% plot(x,y,'o');
p1 = scatter(x,y,sz,'o','MarkerEdgecolor','w','MarkerFaceColor',[.4 .5 .7]);
ylabel("log_{10}(\it{r*})");

[xData, yData] = prepareCurveData( x', y' );
% Set up fittype and options.
ft = fittype( 'poly1' );
% Fit model to data.
[fitresult, gof,output] = fit( xData, yData, ft );

xNew = linspace(0,0.3);
yNew = xNew * fitresult.p1 + fitresult.p2;
CIF = predint(fitresult,xNew,0.95,'functional','on');    % gprMdl1 = fitrgp(x,y);
xtemp = [xNew,fliplr(xNew)]; 
ytemp = [CIF(1:100,1);flipud(CIF(1:100,2))]';
p2 = plot(xNew,yNew,'-k');
p3 = patch(xtemp,ytemp,'k','FaceAlpha',0.1,'edgecolor','none');

sizes = log([10, 1000, 100000]);
sizes = sizes.^2;
legendLabel = ["10 m^3/s","10^3 m^3/s","10^5 m^3/s"];

mdl = fitlm(x,y);%get p value
for i = 1:length(sizes)
p4(i) = plot(nan, nan, 'o', 'MarkerSize', sqrt(sizes(i)),...
    'MarkerFaceColor',[.4 .5 .7],'MarkerEdgeColor', 'w', 'DisplayName', legendLabel(i));
end

equation = sprintf('y = %.2fx %.2f\nr^2 = %.2f', fitresult.p1, fitresult.p2,gof.rsquare);
% text(0.02, 0.12, equation,'unit','normalized', 'FontSize', 10); %'BackgroundColor', 'w', 'EdgeColor', 'k'

cmap = [178,223,138;255,171,93;251,188,188;31,120,180;178 178 178]/255;
for i = 1:4
    temp = (DV(:,2));
    sz = log(temp).^2;   
    x = DV(:,7);
    y = log10(migRate);
    x = x(climateZone==i);
    y = y(climateZone==i);
    sz = sz(climateZone==i);% plot(x,y,'o');
    scatter(x,y,sz,'o','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor','w');
end
lh = legend([p4,p2,p3],{ legendLabel(1),legendLabel(2),legendLabel(3),"fit","95% CI"});
xlabel('\itDV');



figure(2);hold on
titleLabel = {"tropical","arid","temperate","cold"};
for i = 1:4
    subplot(1,4,i);hold on
    temp = (DV(:,2));
    sz = log(temp).^2;   
    x = DV(:,7);
    y = log10(migRate);
    x = x(climateZone==i);
    y = y(climateZone==i);
    sz = sz(climateZone==i);% plot(x,y,'o');

    [xData, yData] = prepareCurveData( x', y' );
    % Set up fittype and options.
    ft = fittype( 'poly1' );
    % Fit model to data.
    [fitresult, gof,output] = fit( xData, yData, ft );
    xNew = linspace(0,0.3);
    yNew = xNew * fitresult.p1 + fitresult.p2;
    CIF = predint(fitresult,xNew,0.95,'functional','on');    % gprMdl1 = fitrgp(x,y);
    xtemp = [xNew,fliplr(xNew)]; 
    ytemp = [CIF(1:100,1);flipud(CIF(1:100,2))]';
    p2 = plot(xNew,yNew,'-k');
    p3 = patch(xtemp,ytemp,'k','FaceAlpha',0.1,'edgecolor','none');
    gof.rsquare
    text(.5,.2,sprintf('r^2=%.3f',gof.rsquare),'Units','normalized');
    title(titleLabel(i));
    scatter(x,y,sz,'o','MarkerFaceColor',cmap(i,:),'MarkerEdgeColor','w');    % scatter(x,y,sz,'o')
    ylabel("log_{10}(\it{r*})");
end