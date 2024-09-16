%plot stage, flood intermittancy and sediment supply to overbank at Baton
%Rouge and Venice
run mississippi_stage.m%load and prepare stage data
run stagePlot.m

run conctrProfileBR.m%calculate concentration profiles at Baton Rouge
run overbankSedVolumeBR.m%calculate overbank sediment supply volume at BR
run overbankPlotBR.m

run conctrProfileVe.m%calculate concentration profiles at Venice
run overbankSedVolumeVe.m%calculate overbank sediment supply volume at Ve
run overbankPlotVe.m

subplot(2,2,1);hold on
xlim([11238,12335]);
ylim([2 14]/0.3048);
yticks([2 6 10 14]/0.3048);
yticklabels({'2','6','10','14'});
xlabel('year');
xticks([0 1 2 3]*365 + 11238);
xticklabels({'2018','2019','2020','2021'});

subplot(2,2,2);hold on
ylim([-.5 2]/0.3048);
yticks([-.5 0 0.5 1 1.5 2]/0.3048);
yticklabels({'-0.5','0','0.5','1','1.5','2'});
xlim([11245,12342]);
xticks([0 1 2 3]*365 + 11245);
xticklabels({'2018','2019','2020','2021'});


hold on
subplot(2,2,3);hold on
b1 = bar([1 2],[daySandBR,dayFloodBR;daySandVe,dayFloodVe]/totalTimeBR);
b1(1).FaceColor = [200, 200, 200]/255;
b1(2).FaceColor = [0, 0, 0]/255;
ylabel('intermittancy');
xticks([1 2]);
xticklabels({'Baton Rouge','Venice'});
legend(b1,{'non-cohesive','cohesive'});

subplot(2,2,4);hold on
b2 = bar([1 2],[NoSandBR,NoFloodBR;NoSandVe,NoFloodVe]/23);
b2(1).FaceColor = [200, 200, 200]/255;
b2(2).FaceColor = [0, 0, 0]/255;
ylabel('flood frequency (1/year)');
xticks([1 2]);
xticklabels({'Baton Rouge','Venice'});

subplot(2,2,1);hold on
text(.1, .93,{'A'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(2,2,2);hold on
text(.1, .93,{'B'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(2,2,3);hold on
text(.1, .93,{'C'},'HorizontalAlignment','left','unit','normalized','fontsize',9)
subplot(2,2,4);hold on
text(.1, .93,{'D'},'HorizontalAlignment','left','unit','normalized','fontsize',9)


