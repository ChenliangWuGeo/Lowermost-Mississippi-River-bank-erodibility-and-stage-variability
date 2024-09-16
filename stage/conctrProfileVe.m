%set up input parameters for calculating sediment concentration profile
%Qw U and Cf data from Nittrouer et al., 2011 and 2012
Qw = [5000	7500	12500	17500	22500	27500	32500	40000];
U = [0.360495071	0.526393087	0.874936998	1.221591181	1.539538195	1.868879729	2.194100275	2.675248572];
Cf = [.0075 .0085 .007 .006 .006 .006 .005 .004];

QwVe(QwVe==0)=nan;
tempx = StVe(~isnan(QwVe));
tempy = QwVe(~isnan(QwVe));
tempy = tempy(~isnan(tempx));
tempx = tempx(~isnan(tempx));
f3 = fit(tempx,tempy,'exp1');

QwVe2 = f3.a * exp(f3.b * StVe);
QwVe2(QwVe2>4.0493e+04) = 4.0493e+04;%4.049 is max Qw at BR,assume value higher than this
%correspond to higher stage, assume higher stage has max QwBr here.

%allocate parameters space for rouse modeling
f2 = fit(Qw',U','poly2');
uVe = f2.p1 * QwVe2.^2 + f2.p2 * QwVe2 + f2.p3;
hVe = QwVe2./uVe./826.948801;%constant channel width 826.94 from Jeff's spreadsheet
f1 = fit(Qw',Cf','poly1');
CfVe = f1.p1 * QwVe2 + f1.p2;
D50 = 250E-6;%micron, read from Nittrouer GSAB 2012.
ws = 1.65 * 9.81 * D50^2 / (18*1e-6 + (0.75 * 0.4 * 1.65 *9.81 * D50^3)^0.5);
alfa = 0.8; %need to verify
kappa = 0.41;%von karman constant
usf = uVe .* sqrt(CfVe);
p = ws./(alfa * kappa * usf);%rouse number
Rep = sqrt(1.65*9.81*D50)*D50/1e-6;
tauc_star = 0.5 * (0.22*Rep^-.6 + 0.06*10^(-7.7*Rep^-.6));
tauc = tauc_star * 1.65 * 9.81 * D50 * 1000;
taub = CfVe*1000.*uVe.^2;
epsilonZa = (0.004) *0.65 * (taub/tauc-1) ./ (1 + 0.004*(taub/tauc-1));

A1 = 0.68;
A2 = 0.0204*(log(D50*100))^2 + 0.022*(log(D50*100)) + 0.0709;
za = D50 * (A1 * taub/tauc) ./ (1 + A2*(taub/tauc));
