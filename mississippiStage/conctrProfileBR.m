%set up input parameters for calculating sediment concentration profile
%Qw and Cf data from Nittrouer et al., 2011 and 2012
Qw = [5000	7500	12500	17500	22500	27500	32500	40000];
Cf = [.0075 .0085 .007 .006 .006 .006 .005 .004];

%getting stage/velocity relation from USACE
% https://rivergages.mvr.usace.army.mil/WaterControl/Districts/MVN/velo_br.htm
stageH = 2:2:40;
u_ft = [1.6 2.1 2.5, 2.8,3, 3.2 3.4,3.6,3.8,4,4.2,4.4,4.7,4.9,5.2,5.5,5.8,6.2,6.6,7.2];
u_m  =u_ft * 0.3048;
u = interp1(stageH,u_m,StBR,'makima');%towards 45 ft needs to be corrected
f1 = fit(Qw',Cf','poly1');
CfBR = f1.p1 * QwBR + f1.p2;
tempQw = QwBR;
tempQw (tempQw<.1e3) = nan;
inn = ~isnan(tempQw);
i1 = (1:numel(tempQw)).';
tempQw = interp1(i1(inn),tempQw(inn),i1,'linear');
QwBR = tempQw;%this will alter the original record, fill nan or 0 record
%allocate parameters space for rouse modeling
b = 800; %assume channel width to be constant
hBR = tempQw./u/b;
hBR(9028) = nan;%error in original data
u(9028) = nan;%error in original data
D50 = 300E-6;%micron read from Nittrouer GSAB 2012.

ws = 1.65 * 9.81 * D50^2 / (18*1e-6 + (0.75 * 0.4 * 1.65 *9.81 * D50^3)^0.5);
alfa = 0.8; %need to verify
kappa = 0.41;%von karman constant
usf = u .* sqrt(CfBR);
p = ws./(alfa * kappa * usf);%rouse number
Rep = sqrt(1.65*9.81*D50)*D50/1e-6;
tauc_star = 0.5 * (0.22*Rep^-.6 + 0.06*10^(-7.7*Rep^-.6));
tauc = tauc_star * 1.65 * 9.81 * D50 * 1000;
taub = CfBR*1000.*u.^2;
epsilonZa = (0.004) *0.65 * (taub/tauc-1) ./ (1 + 0.004*(taub/tauc-1));

A1 = 0.68;
A2 = 0.0204*(log(D50*100))^2 + 0.022*(log(D50*100)) + 0.0709;
za = D50 * (A1 * taub/tauc) ./ (1 + A2*(taub/tauc));
