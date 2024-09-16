%calibrate erosion coefficient E over bend scale
x1 = CL1.xy(1,:);
y1 = CL1.xy(2,:);

x2 = CL2.xy(1,:);
y2 = CL2.xy(2,:);


ds = x1;
ds(2:end) = sqrt((x1(2:end)-x1(1:end-1)).^2 + (y1(2:end)-y1(1:end-1)).^2);
ds(1) = ds(2);

accuS1 = streamLineDistance(ds);%accumulative river distance, measured from upstream

%% get cross over point   
xOver = CL1.xyOver(1,:);
yOver = CL1.xyOver(2,:);
xOverNAD = xOver/0.3048; %get x for crossover in NAD coordinate
yOverNAD = yOver/0.3048; %get y for crossover in NAD coordinate
RKOver = CL1.RKOver;
accuSOver = CL1.accuSOver;%accumulative river distance for cross over points

%% calculate average rate of migration over each bend and calibrate for E
[ixy1Unique, ia, ~] = unique(ixy1,'stable');
migDistUnique = migDist(ixy1Unique);
ixy2Unique = ixy2(ia);
E = nan(1,length(xOver)-1);%bend erosion coefficient
Sinu = nan(1,length(xOver)-1);%bend sinuosity
Curv = nan(1,length(xOver)-1);%bend max curvature
RK_E = nan(1,length(xOver)-1);%RK of bend
migBend = nan(1,length(xOver)-1);%average rate of migration over bend

for i = 1 : length(xOver)-1
       x1Sub = x1(accuSOver(i) <= accuS1 &  accuS1 < accuSOver(i+1));
       y1Sub = y1(accuSOver(i) <= accuS1 &  accuS1 < accuSOver(i+1));
       x2Sub = x2(accuSOver(i) <= accuS1 &  accuS1 < accuSOver(i+1));
       y2Sub = y2(accuSOver(i) <= accuS1 &  accuS1 < accuSOver(i+1));
 
       %approximate RK_E as RK_over
       RK_E(i) = RKOver(i);
       
       migSub = migDistUnique(accuSOver(i) <= accuS1 &  accuS1 < accuSOver(i+1));
       migSub = mean(migSub)/30;%yearly average mig rate, 30 year
       migBend(i) = migSub;

       H_Sub = Hbw_re(accuSOver(i) <=accuS_bw &  accuS_bw<accuSOver(i+1));
       H_input = mean(H_Sub);
       H_out(i) = H_input;
       
       U_Sub = Ubw_re(accuSOver(i) <=accuS_bw &  accuS_bw<accuSOver(i+1));
       U_input = mean(U_Sub);
       U_out(i) = U_input;

       B_Sub = Bbw_re(accuSOver(i) <=accuS_bw &  accuS_bw<accuSOver(i+1));
       B_input = mean(B_Sub);
       B_out(i) = B_input;

       
       [E(i), Sinu(i), Curv(i)]= calibrateE(x1Sub, y1Sub, migSub, H_input, U_input, B_input);
end


% function for calibrate E by matching observated and modeled average
% migration rate over bend scale
function [E, Sinu, Curv]= calibrateE(x1Sub,y1Sub,migSub,H_input, U_input, B_input)
    x = x1Sub;
    y = y1Sub;

    [~,noNode] = size(x);
    us0 = U_input;%need to varify. 1.5 is trinity river, Moran 2017
    h0 = H_input;
    Cf = 0.005;
    g = 9.81;
    b = B_input/2;
    year = 365*24*60*60;
    A = 10; %need to verify
    alfa = 0.077;
    Chi1 = alfa/sqrt(Cf);
    Chi = Chi1 - 1/3;
    As = 181 * (h0/b)^2 * 1/Chi1 * (2*Chi^2 + 0.8*Chi + 1/15);
    A = A + As -1;
    tf = 1;
    xStep = 3*b;
    E = 20e-7;
    k = 80; %searching index range for cutoff point

    ds = nan(1,noNode);
    usb = zeros(1,noNode);
    dCurve = nan(1,noNode);

    
    ds = x;
    ds(2:end) = sqrt((x(2:end)-x(1:end-1)).^2 + (y(2:end)-y(1:end-1)).^2);
    ds(1) = ds(2);

    curvature = getCurv(x,y);
    dCurve(2:end) = (curvature(2:end)-curvature(1:end-1))./ds(2:end);
    dCurve(1) = dCurve(2);

    usb(2:end) = b./(us0./ds(2:end) + 2*us0./h0*Cf) .*...
        (-us0.^2.*dCurve(2:end) + ...
        Cf*curvature(2:end) .* ((us0.^4/g./h0.^2) + A*us0.^2./h0)...
        + us0./ds(2:end) .* usb(1:end-1)/b);
    usb(1) = 0;

accuS  = streamLineDistance(ds);%streamline distance for each node
streamwiseDist = max(accuS);
cartisianDist = sqrt((x(1)-x(end))^2+(y(1)-y(end))^2);
Sinu = streamwiseDist / cartisianDist;
Curv = max(abs(curvature)); %get max curvature for the bend   

    Ecali = logspace(-8,-5,1000);
    for i = 1:length(Ecali)
        migrRate = Ecali(i).*usb*year*tf;
        migrRate = mean(abs(migrRate));
        if migrRate - migSub > 0.1
            E = Ecali(i);
            break
        end
    end
end

% calculate curvature and alongstream distance.
function output = getCurv(x,y)
%     [~,temp] = size(x);   
    dx1 = x;%nan(1,temp);
    dx2 = x;%nan(1,temp);
    dy1 = x;%nan(1,temp);
    dy2 = x;%nan(1,temp);
    
    ds = x;
    ds(2:end) = sqrt((x(2:end)-x(1:end-1)).^2 + (y(2:end)-y(1:end-1)).^2);
    ds(1) = ds(2);

    dx1(2:end) =  (x(2:end)-x(1:end-1))./ds(2:end);
    dx1(1) = dx1(2);
    dx2(2:end) = (dx1(2:end)-dx1(1:end-1))./ds(2:end);
    dx2(1) = dx2(2);

    dy1(2:end) = (y(2:end)-y(1:end-1))./ds(2:end);
    dy1(1) = dy1(2);
    dy2(2:end) = (dy1(2:end)-dy1(1:end-1))./ds(2:end);
    dy2(1) = dy2(2);

    curvature = (dx1.*dy2-dy1.*dx2)./(dx1.^2+dy1.^2).^(3/2);
    
    output = curvature;
end

