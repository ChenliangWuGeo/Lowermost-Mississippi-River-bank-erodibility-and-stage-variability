%load centerlines and calculate migration rate
CL1 = getCenterlineXY(1);% time 1 center line
CL2 = getCenterlineXY(2);% time 2 center line

[dist,ixy1,ixy2] = dtw(CL1.xy,CL2.xy);%river migration distance using dynamic time warping method
plot([CL1.xy(1,ixy1)',CL2.xy(1,ixy2)']',[CL1.xy(2,ixy1)',CL2.xy(2,ixy2)']','-k')
set(gca,'DataAspectRatio',[1 1 1])
hold on
plot(CL1.xy(1,:),CL1.xy(2,:),'-b');

migDist = sqrt( (CL1.xy(1,ixy1)-CL2.xy(1,ixy2)).^2 ...
    + (CL1.xy(2,ixy1)-CL2.xy(2,ixy2)).^2 );
movMeanRate = movmean(migDist,100);%100 point moving average migration rate
figure(2);hold on
plot(migDist)

curvCL = getCurv(CL1.xy(1,:),CL1.xy(2,:));%centerline curvature
curveSignCL = curvCL;
curveSignCL(curveSignCL>0) = 1;%sign of curvature, bending left or right of the flow
curveSignCL(curveSignCL<0) = -1;
[ixy1Unique, ia, ~] = unique(ixy1,'stable');
migDistUniqueSign = migDist(ixy1Unique) .* curveSignCL;

figure(3); hold on
% plot(LB1.xy(1,:),LB1.xy(2,:),'-b');
plot(CL1.xy(1,:),CL1.xy(2,:),'-k');
% plot(RB1.xy(1,:),RB1.xy(2,:),'-r');
plot(CL1.xyOver(1,:),CL1.xyOver(2,:),'or');
set(gca,'DataAspectRatio',[1 1 1])
close all%comment to see the figure
