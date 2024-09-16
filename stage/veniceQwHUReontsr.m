QwJeff = [5000	7500	12500	17500	22500	27500	32500	40000];
HJeff = [16.82437248	17.28268382	17.32974525	17.37680667	17.72733759	17.84846072	17.9669604	18.13601201];
UJeff = [0.360495071	0.526393087	0.874936998	1.221591181	1.539538195	1.868879729	2.194100275	2.675248572];
BJeff = [826.948801	826.948801	826.948801	826.948801	826.948801	826.948801	826.948801	826.948801];
CfJeff = [.0075 .0085 .007 .006 .006 .006 .005 .004];


% QwVe(QwVe==0)=nan;
% tempx = StVe(~isnan(QwVe));
% tempy = QwVe(~isnan(QwVe));
% tempy = tempy(~isnan(tempx));
% tempx = tempx(~isnan(tempx));
% f1 = fit(tempx,tempy,'exp1');
% 
% QwVe2 = f1.a * exp(f1.b * StVe);
% QwVe2(QwVe2>4.0493e+04) = nan;%4.049 is max Qw at BR
% 
% f2 = fit(QwJeff',UJeff','poly1');
% uVe = f2.p1 * QwVe2 + f2.p2;

f1 = fit(QwJeff',UJeff','poly1');
CfVe = f2.p1 * QwVe2 + f2.p2;