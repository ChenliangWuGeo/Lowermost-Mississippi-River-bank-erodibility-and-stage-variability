%import channel path
function output = getCenterlineXY(lineIdx)
    hold on

    %For 1883, use B and C(471). For 1913, use E and F(475).
    
    switch lineIdx
        case 1 % time 1 center line
%             x = xlsread('points_200m.xlsx','centerline','A3:A2401');
%             y = xlsread('points_200m.xlsx','centerline','B3:B2401');      
            x = xlsread('points_200m_2.xlsx','centerline','A3:A2383');
            y = xlsread('points_200m_2.xlsx','centerline','B3:B2383');      
        case  2 % time 2 center line
%             x = xlsread('points_200m.xlsx','centerline','C3:C2421');
%             y = xlsread('points_200m.xlsx','centerline','D3:D2421');
            x = xlsread('points_200m_2.xlsx','centerline','C3:C2409');
            y = xlsread('points_200m_2.xlsx','centerline','D3:D2409');
        case  3 % time 1 left bank
            x = xlsread('points_200m.xlsx','bank','A4:A2394');
            y = xlsread('points_200m.xlsx','bank','B3:B2394');
        case  4 % time 1 right bank
            x = xlsread('points_200m.xlsx','bank','C4:C2409');
            y = xlsread('points_200m.xlsx','bank','D4:D2409');
        case  5 % time 2 left bank
            x = xlsread('points_200m.xlsx','bank','E4:E2417');
            y = xlsread('points_200m.xlsx','bank','F4:F2417');
        case  6 % time 2 right bank
            x = xlsread('points_200m.xlsx','bank','G4:G2433');
            y = xlsread('points_200m.xlsx','bank','H4:H2433');
            
    end    
    B = 1 ; %channel width in km
%     [x,y] = deg2utm(y,x);
%     % correct xy for rivers cross multiple utm zones
%     x = utmCorrect(x,y,1);
% 
%     xtemp = x(y>3927000);
%     xtemp(xtemp>772300) = xtemp(xtemp>772300)-(807900-772200);
%     x(y>3927000) = xtemp;

    x = x*0.3048;%feet to meter
    y = y*0.3048;

    x = x';
    y = y';

    ds = x;
    ds(2:end) = sqrt((x(2:end)-x(1:end-1)).^2 + (y(2:end)-y(1:end-1)).^2);
    ds(1) = ds(2);
    accuS = streamLineDistance(ds);
    temp = accuS(2:end)-accuS(1:end-1);
    temp = [1,temp];
    x = x(temp~=0);
    y = y(temp~=0);
    accuS = accuS(temp~=0);
    % %% 
    % 
     xi = x;
     yi = y;
    % 
    s_reMesh = accuS(1):B*1e3/10:accuS(end);%
    x_reMesh = interp1(accuS,x,s_reMesh,'spline');%'makima'
    y_reMesh = interp1(accuS,y,s_reMesh,'spline');
    
    
    x = x_reMesh;
    y = y_reMesh;
    accuS = s_reMesh;
    
    
    %     xi = x;
    %     yi = y;
    
    x = (smooth(x,20,'sgolay',2))';
    y = (smooth(y,20,'sgolay',2))';
    %% 

    curvature = getCurv(x,y);


    [pks1, loca1]=findpeaks(curvature);
    [pks2, loca2]=findpeaks(-curvature);

    locaAll = [loca1,loca2];
    locaAll = sort(locaAll);

    [~,lgth] = size(locaAll);
    if mod(lgth,2) ~= 0 %remainder after divided by 2, in case of odd number
        locaAll = locaAll(1:end-1);
        lgth = lgth - 1;
    end

    xOver = nan(1,lgth);
    yOver = nan(1,lgth);
    accuSOver = nan(1,lgth);

    intrinsicLength = nan(1,lgth-1);
    directLength = nan(1,lgth-1);

    for i = 1  : lgth-1
        locaTemp = locaAll(i):locaAll(i+1);
        xTemp = x(locaTemp);
        yTemp = y(locaTemp);
        accuSTemp = accuS(locaTemp);
        curvTemp = curvature(locaTemp);
        xOver(i) = interp1(curvTemp,xTemp,[0]);
        yOver(i) = interp1(curvTemp,yTemp,[0]);
        accuSOver(i) = interp1(curvTemp,accuSTemp,[0]);
    end

    xOver = xOver(~isnan(xOver));
    yOver = yOver(~isnan(yOver));
    accuSOver = accuSOver(~isnan(accuSOver));
    RK = max(accuS)-accuS;
    RKOver = max(accuS)-accuSOver;

    intrinsicLength = accuSOver(2:end)-accuSOver(1:end-1);
    directLength = sqrt(...
        (xOver(2:end)-xOver(1:end-1)).^2 +...
        (yOver(2:end)-yOver(1:end-1)).^2);

    %to ensure local perturbations excluded.
    accuSOver(intrinsicLength<B*1e3*2) = [];
    xOver(intrinsicLength<B*1e3*2) = [];
    yOver(intrinsicLength<B*1e3*2) = [];
    RKOver(intrinsicLength<B*1e3*2) = [];
    intrinsicLength = accuSOver(2:end)-accuSOver(1:end-1);
    directLength = sqrt(...
        (xOver(2:end)-xOver(1:end-1)).^2 +...
        (yOver(2:end)-yOver(1:end-1)).^2);

    sinu2 = intrinsicLength./directLength;
    aveSinu = movmean(sinu2,10);
    xtemp = [0:0.05:3];
    % aveSinu = interp1(fliplr(RKOver(2:end)/river.Lb/1e3),fliplr(aveSinu),...
    %     xtemp);

    %calculate sinuosity using moving window
    n = 20;
    Lpath = n * B*1e3/2;
    Ldist = sqrt( (x(n+1:end) - x(1:end-n)).^2+...
        (y(n+1:end)- y(1:end-n)).^2);
    sinu1 = Lpath./Ldist;
    sinu1RK = RK(n+1:end);

    %store output
    output.sinu1 = sinu1;
    output.sinu2 = sinu2;
    output.sinu1RK = sinu1RK;
    output.xyOver = [xOver;yOver];
    output.accuSOver = accuSOver;
    output.xy = [x;y];
    output.curvature = curvature;
    output.accuS = accuS;
    output.RK = RK;
    output.RKOver = RKOver;

    output.xyi = [xi;yi];
    output.aveSinu = aveSinu;
    

     
close all
end
