%load bankfull channel depth, width, reach-averaged velocity, and River
%Kilometer
Hbw = readmatrix('Mississippi_H_B_U.xlsx','Sheet','Sheet1','Range','A3:A1617');%depth
Bbw = readmatrix('Mississippi_H_B_U.xlsx','Sheet','Sheet1','Range','B3:B1617');%width
Ubw = readmatrix('Mississippi_H_B_U.xlsx','Sheet','Sheet1','Range','C3:C1617');%velocity
Ubw_re = readmatrix('Mississippi_H_B_U.xlsx','Sheet','Sheet1','Range','D3:D1617');%regression fit of velocity
RKbw = readmatrix('Mississippi_H_B_U.xlsx','Sheet','Sheet1','Range','E3:E1617');%river kilometer

Hbw = Hbw(RKbw<479.1);%keep record of the lower 479 RK.
Bbw = Bbw(RKbw<479.1);%keep record of the lower 479 RK.
Ubw = Ubw(RKbw<479.1);%keep record of the lower 479 RK.
Ubw_re = Ubw_re(RKbw<479.1);%keep record of the lower 479 RK.
RKbw = RKbw(RKbw<479.1);%keep record of the lower 479 RK.
accuS_bw = (max(RKbw)-RKbw) * 1000;%convert RK to accumulative distance m

temp = polyfit(RKbw,Hbw,6);
Hbw_re = polyval(temp,RKbw);% regression fit of flow depth
figure;hold on
subplot(1,2,1);hold on
plot(RKbw,Hbw,'o','markeredgecolor','w','markerfacecolor',[.6 .6 .6],'MarkerSize',5)
plot(RKbw,Hbw_re,'-k','linewidth',1.5)
xlabel('RK');
ylabel('reach-averaged flow depth {\ith} (m)');
set(gca, 'Layer', 'top','color',[1 1 1])
 
temp = polyfit(RKbw,Bbw,6);
Bbw_re = polyval(temp,RKbw);% regression fit of channel width
hold on
subplot(1,2,2);hold on
plot(RKbw,Bbw,'o','markeredgecolor','w','markerfacecolor',[.6 .6 .6],'MarkerSize',5)
plot(RKbw,Bbw_re,'-k','linewidth',1.5)
xlabel('RK');
ylabel('reach-averaged channel width {\itB} (m)');
set(gca, 'Layer', 'top','color',[1 1 1])

subplot(1,2,1);hold on
text(.2, .95,{'A'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(1,2,2);hold on
text(.2, .95,{'B'},'HorizontalAlignment','left','unit','normalized','fontsize',9)

close all%comment to see the figure
