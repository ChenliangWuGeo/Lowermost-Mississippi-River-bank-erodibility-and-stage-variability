%Calculate percentage of sediments
[RK_mud_sort,idx] = sort(RK_mud);%sort original sediment content entry by RK
outliers = [];
cb = [0 0 0;0 0 0];%colormap for plotting
marker = ["^","^"];
plotIdx = ["A","B","C","D","E","F"];
%% plot clay
m = 2;%bank type 2 = point bar
temp = mud_Hmax;
temp(bankType==m)=nan;%use only cutbank
mud_aH_sort = temp(idx);
tempRK = RK_mud;
tempRK(bankType==m)=nan;
%calculate kernal density
tempRK=tempRK(~isnan(temp));
temp=temp(~isnan(temp));
tempP=[tempRK',temp];
p = gkde2(tempP);
accuS_mud = fliplr(RK_mud_sort)*1000;%unit in meter

for i = 1 : length(xOver)-1
       RK_E(i) = RKOver(i);%approximate RK_E as RK_over
       mud_sub = mud_aH_sort(accuSOver(i) <=accuS_mud &  accuS_mud<accuSOver(i+1));
       mud_Sub(i) = mean(mud_sub,'omitnan');%mud percent over bend scale
       mud_SubStd(i) = std(mud_sub,'omitnan');
end
if m == 2 
    mudPrct = mud_Sub;
end

figure(3);hold on
subplot(1,3,1);hold on;box on
%plot kernal density
surf(p.x,p.y,p.pdf-10);
view(2)
N = 256; % number of colors
cmap = [linspace(1,0,N).' linspace(1,0,N).' ones(N,1)]; % decreasing R and G; B = 1
colormap(cmap)
shading interp

plot(RK_mud_sort,mud_aH_sort,'o','markeredgecolor',[.85 .85 .85],'markerfacecolor',[.85 .85 .85],'markersize',2);
plot(RK_E/1e3,mud_Sub,marker(m),'markeredgecolor','w','markerfacecolor','k');
plot(RK_E/1e3,movmean(mud_Sub,[5,5],'omitnan'),'color','k','LineWidth',1.5);
xlabel('river kilometer (RK)');
ylabel('percentage');
text(.05, .88,{plotIdx(1)},'HorizontalAlignment','left','unit','normalized','fontsize',9)
text(.85, .88,{'clay'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
xlim([0,500]);
ylim([0 100]);
set(gca, 'Layer', 'top','color',[1 1 1])
%% plot silt
m = 2;
temp = silt_Hmax;
temp(bankType==m)=nan;%use only cutbank
silt_aH_sort = temp(idx);
tempRK = RK_mud;
tempRK(bankType==m)=nan;
%calculate kernal density
tempRK=tempRK(~isnan(temp));
temp=temp(~isnan(temp));
tempP=[tempRK',temp];
p = gkde2(tempP);
accuS_silt = fliplr(RK_mud_sort)*1000;%unit in meter
for i = 1 : length(xOver)-1

        %approximate RK_E as RK_over
       silt_sub = silt_aH_sort(accuSOver(i) <=accuS_silt &  accuS_silt<accuSOver(i+1));
       silt_Sub(i) = mean(silt_sub,'omitnan');%silt percent over bend scale
       silt_SubStd(i) = std(silt_sub,'omitnan');
end
if m == 2 
    siltPrct = silt_Sub;
end
figure(3);hold on
subplot(1,3,2);hold on;box on
%plot kernal density
surf(p.x,p.y,p.pdf-10);
view(2)
N = 256; % number of colors
cmap = [linspace(1,0,N).' linspace(1,0,N).' ones(N,1)]; % decreasing R and G; B = 1
colormap(cmap)
shading interp
fill([0 500 500 0],[80 80 100 100],'w','edgecolor','none');

%regression for mud percentage
tempx = silt_Sub;
tempy = silt_Sub(~isnan(tempx));
tempx = RK_E(~isnan(tempx));%need to do tempy first, before update tempx
p = polyfit(tempx'/1e3,tempy',3);
if m == 2 
    ypred3 = polyval(p,RK_E/1e3);
    siltPrct2 = ypred3;
end
plot(RK_mud_sort,silt_aH_sort,'o','markeredgecolor',[.85 .85 .85],'markerfacecolor',[.85 .85 .85],'markersize',2);
plot(RK_E/1e3,silt_Sub,marker(m),'markeredgecolor','w','markerfacecolor','k');
plot(RK_E/1e3,movmean(silt_Sub,[5,5],'omitnan'),'color','k','LineWidth',1.5);    % legend([h2,h3,h1],{'bend ave.','outlier','reg. fit'},'Orientation','horizontal');
xlabel('river kilometer (RK)');
ylabel('percentage');
text(.05, .88,{plotIdx(2)},'HorizontalAlignment','left','unit','normalized','fontsize',9)
text(.85, .88,{'silt'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
xlim([0,500]);
ylim([0 100]);
set(gca, 'Layer', 'top','color',[0 0 0])


%% plot sand
m = 2;
temp = sand_Hmax;
temp(bankType==m)=nan;%use only cutbank
sand_aH_sort = temp(idx);
tempRK = RK_mud;
tempRK(bankType==m)=nan;
%calculate kernal density
tempRK=tempRK(~isnan(temp));
temp=temp(~isnan(temp));
tempP=[tempRK',temp];
p = gkde2(tempP);
accuS_mud = fliplr(RK_mud_sort)*1000;%unit in meter
for i = 1 : length(xOver)-1
       sand_sub = sand_aH_sort(accuSOver(i) <=accuS_mud &  accuS_mud<accuSOver(i+1));
       sand_Sub(i) = mean(sand_sub,'omitnan');%sand percent over bend scale
       sand_SubStd(i) = std(sand_sub,'omitnan');
end
if m == 2 
    sandPrct = sand_Sub;
end
figure(3);hold on
subplot(1,3,3);hold on;box on
%plot kernal density
surf(p.x,p.y,p.pdf-10);
view(2)
N = 256; % number of colors
cmap = [linspace(1,0,N).' linspace(1,0,N).' ones(N,1)]; % decreasing R and G; B = 1
colormap(cmap)
shading interp
%regression for mud percentage
tempx = sand_Sub;
tempy = sand_Sub(~isnan(tempx));
tempx = RK_E(~isnan(tempx));%need to do tempy first, before update tempx
gprMdl1 = fitrgp(tempx'/1e3,tempy');
p = polyfit(tempx'/1e3,tempy',3);
ypred2 = polyval(p,tempx'/1e3);
if m == 2 
    ypred3 = polyval(p,RK_E/1e3);
    sandPrct2 = ypred3;
end
plot(RK_mud_sort,sand_aH_sort,'o','markeredgecolor',[.85 .85 .85],'markerfacecolor',[.85 .85 .85],'markersize',2);
plot(RK_E/1e3,sand_Sub,marker(m),'markeredgecolor','w','markerfacecolor',cb(m,:));
plot(RK_E/1e3,movmean(sand_Sub,[5,5],'omitnan'),'color','k','LineWidth',1.5);%     if m ==2 

xlabel('river kilometer (RK)');
ylabel('percentage');
ylim([0 100]);
text(.05, .88,{plotIdx(3)},'HorizontalAlignment','left','unit','normalized','fontsize',9);
text(.85, .88,{'sand'},'HorizontalAlignment','left','unit','normalized','fontsize',9);
xlim([0,500]);
ylim([0 100]);
set(gca, 'Layer', 'top','color',[0 0 0])
close all%comment to see the figure




