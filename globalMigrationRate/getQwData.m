function output = getQwData(riverNo)

    % i = 10;%select the number of river first
    riverName1 = ["mississippi","trinity","rhine","meuse","danube","brazos","riogrande",...
    "colorado","indus"];
    riverName2 = ["Don","Kobuk","Yana","Mackenzie","Tombigbee","Apalachicola",...
        "Alabama","Sabine","Neches","Suwanee"];
    riverName3 = ["sacramento","minnesota_up","minnesota_down","red","wabash","pearl",...
        "okavango","beatton","beaver","amazon","riojutai","kootenay","trinity_postdam",...
        "riogrande_postdam","clearwater","ob","reddeer","willamette","driftwood",...
        "white","bellinger"];
    riverName4 = ["bogue_chitto","chinchaga","chickasawhay","choctawhatchee",...
        "escambia","murghab","rio_curuca","rio_itui","rio_xingu","nishnabotna",...
        "east_fork_white","oldman","pembina","fort_nelson","sikanni_chief",...
        "swan","rouge","riopurus","rioparana","rioaraguaia","milk","whitewater",...
        "ocmulgee","brazos_upstream"];


    riverName = [riverName1,riverName2,riverName3,riverName4];
    
    yrDam1 = [2030,2030,2030,2030,2030,2030,1951,2030,2030];
    yrDam2 = [2030,2030,2030,2030,2030,2030,2030,2030,2030,2030];
    yrDam3 = [2030,2030,2030,2030,2030,2030,2030,2030,2030,2030,2030,2030,2030,2030,...
        2030,2030,2030,2030,2030, 2030,2030];
    yrDam4 = 2030 *ones(1,24);
    yrDam  = [yrDam1, yrDam2,yrDam3,yrDam4];
    % yrDam(62) = 1974; 
    % yrDam(52) = 1991; 
    % yrDam(16) = 1979;

    month = readmatrix('globalDischarge.xlsx','Sheet',riverName(riverNo),'Range','A:A');
    % day = xlsread('globalDischarge.xlsx',riverName(riverNo),'B:B');
    yr = readmatrix('globalDischarge.xlsx','Sheet',riverName(riverNo),'Range','C:C');
    Qw = readmatrix('globalDischarge.xlsx','Sheet',riverName(riverNo),'Range','D:D');


    %get rid of heading
    % month(1) = [];
    % day(1) = [];
    % yr(1) = [];
    % Qw(1) = [];
    Qw(Qw==-999) = nan;%arctic delta has -999 or 0 values
    Qw(Qw==999) = nan;%arctic delta has -999 or 0 values
    Qw(Qw==0) = nan;
    
    month(isnan(Qw)) = [];
    yr(isnan(Qw)) = [];
    Qw(isnan(Qw)) = [];
    
    Qw(yr>yrDam(riverNo)) = [];
    month(yr>yrDam(riverNo)) = [];
    yr(yr>yrDam(riverNo)) = [];

    output = [month,yr,Qw];

    % yrStart = min(yr);
    % yrEnd = max(yr);
    % yrDam = yr_Dam(riverNo);
    % 
    % noYear = yrEnd - yrStart;
    % aveMonth = nan(noYear,12);
    % maxQw = nan(1,noYear);
    % minQw = nan(1,noYear);
    % aveYrlyQw = nan(1,noYear);
    % DVIyt = nan(1,noYear);
    % DVIyt2 = nan(1,noYear);
    % DVIyt3 = nan(1,noYear);
    % 
    % for i = 1 : noYear
    %     for j = 1:12 % get average Qs of wettest and driest month on record
    %         temp = Qw(yr == i + yrStart -1 & month == j); % single out month and year
    %         aveMonth(i,j) = mean(temp,'omitnan');% ave. Qs for a month,
    %     end
    % 
    %     % get max and min daily Qw
    %     maxQw(i) = max(Qw(yr == i + yrStart -1 ));
    %     minQw(i) = min(Qw(yr == i + yrStart -1 ));
    %     aveYrlyQw(i) = mean(Qw(yr == i + yrStart -1 ),'omitnan');
    %     DVIyt(i) = (maxQw(i) - minQw(i)) / aveYrlyQw(i);
    %     DVIyt2(i) = (maxQw(i) - minQw(i));
    %     DVIyt3(i) = maxQw(i);
    % end
    % 
    % if yrDam <= yrStart || isnan(yrDam)
    %     noYear2 = noYear;
    %     Qw2 = Qw;
    % else
    %     noYear2 = yrDam-yrStart;% 1951 construction of dam
    %     Qw2 = Qw(yr<yrDam);
    % end
    % 
    % 
    % aveMonth = aveMonth(1:noYear2,:);
    % 
    % [a, b] = size(aveMonth);
    % aveQw = sum(sum(aveMonth,'omitnan')) / (a*b);% mean Qw based on Hansford paper
    % 
    % % DVIc = (max(max(aveMonth)) - min(min(aveMonth))) / mean(Qw2);
    % DVIc = (max(max(aveMonth)) - min(min(aveMonth))) / aveQw;
    % DVIca = sum(max(aveMonth') - min(aveMonth')) / aveQw / noYear2;
    % DVIy = sum(DVIyt(1:noYear2),'omitnan') / noYear2;
    % 
    % %% calculate recurrence interval
    % % special treatment, excluding data after dam construction, as hydrograph
    % % dramatically changed.
    % % Qwbf = 701;%m3/s
    % maxQw2 = maxQw(1:noYear2);
    % temp  = maxQw2;
    % temp(temp==0) = [];
    % temp(isnan(temp)) = [];
    % Qw_sort = sort(temp,'descend');
    % [n,~] = size(Qw_sort');
    % p_exceed = ((1:n)/(n+1)*100)';
    % returnInterval = 1./p_exceed * 100;
    % 
    % pkQw = max(temp);
    % pd = fitdist(Qw_sort','gamma');
    % p = gamcdf((1:pkQw),pd.a,pd.b);
    % 
    % % Qp15 = interp1(flipud(returnInterval),fliplr(Qw_sort),(1.5));
    % % Qp20 = interp1(flipud(returnInterval),fliplr(Qw_sort),(2));
    % figure(2);hold on
    % plot(1./(1-p),(1:pkQw),'-r')
    % 
    % [alpha,beta,xi,Gamma] = pearson3_fit(Qw_sort);
    % Q_range = (1:pkQw);
    % [cdf]=pearson3_cdf(Q_range,alpha,beta,xi,Gamma);
    % figure(2);hold on
    % plot(1./(1-cdf),Q_range,'-k')
    % % cdf_range = cdf(~isnan(cdf));%the distribution will have lower limit larger than 1, so rid of nan values
    % % Q_range = Q_range(~isnan(cdf));
    % cdf_range = cdf(cdf>0.001);%the distribution will have lower limit larger than 1, so rid of nan values
    % Q_range = Q_range(cdf>0.001);
    % Qp15 = interp1(1./(1-cdf_range),Q_range,(1.5))
    % Qp20 = interp1(1./(1-cdf_range),Q_range,(2))
    % 
    % figure(2);hold on
    % % subplot(1,2,1);hold on
    % % plot(Qw_sort/mean(Qw_sort,'all'),p_exceed,'o','color',[0,114,178]/256,'Linewidth',1.5)
    % plot(returnInterval,Qw_sort,'o','color',[0,114,178]/256,'Linewidth',1.5)
    % set(gca,'xscale','log');
    % 
    % %% calculate flow duration curve
    % Qwbf = 700;%m3/s need to verify
    % Qw2(Qw2==0) = []; % there are entries of discharge value zero
    % Qw2(isnan(Qw2)) = [];
    % Qw_sort = sort(Qw2,'descend');
    % [~,n] = size(Qw_sort');
    % p_exceed = ((1:n)/(n+1)*100)';
    % figure(1);hold on
    % subplot(1,2,1);hold on
    % plot(Qw_sort/mean(Qw_sort,'all'),p_exceed,'-','color',[0,158,115]/256,'Linewidth',1.5)
    % set(gca,'xscale','log');
    % subplot(1,2,2);hold on
    % plot(Qw_sort/mean(Qw_sort,'all'),p_exceed,'-','color',[0,158,115]/256,'Linewidth',1.5)
    % set(gca,'xscale','log');
    % 
    % [temp,~] = size(Qw_sort);
    % Qw_sort2 = Qw_sort + (1:temp)'*1e-9; %add small perturbation so values are unique
    % 
    % pExcBf = interp1(flipud(Qw_sort2/mean(Qw_sort,'all')),flipud(p_exceed),Qwbf/mean(Qw_sort,'all'));
    % pExcAve = interp1(flipud(Qw_sort2/mean(Qw_sort,'all')),flipud(p_exceed),(1));
    % p15 = interp1(flipud(Qw_sort2/mean(Qw_sort,'all')),flipud(p_exceed),Qp15/mean(Qw_sort,'all'))
    % p20 = interp1(flipud(Qw_sort2/mean(Qw_sort,'all')),flipud(p_exceed),Qp20/mean(Qw_sort,'all'))
    % 
    % subplot(1,2,1);hold on
    % plot([1e-2, Qwbf/mean(Qw_sort,'all')],[pExcBf,pExcBf],'-','color',[0,158,115]/256);
    % text(1e-2,pExcBf,num2str(riverNo),'VerticalAlignment','bottom','HorizontalAlignment','left','fontsize',8);
    % 
    % subplot(1,2,2);hold on
    % plot([1e-2, 1],[pExcAve,pExcAve],'-','color',[0,158,115]/256);
    % text(1e-2,pExcAve,num2str(riverNo),'VerticalAlignment','bottom','HorizontalAlignment','left','fontsize',8);
    % 
    % DVIy2 = sum(DVIyt2(1:noYear2),'omitnan') / mean(Qw_sort,'all') / noYear2;
    % DVIy3 = sum(DVIyt2(1:noYear2),'omitnan') / Qp15 / noYear2;
    % DVIc2 = (max(max(aveMonth)) - min(min(aveMonth))) / mean(Qw_sort,'all');
    % DVIc3 = (max(max(aveMonth)) - Qp15) / Qp15;
    % 
    % Qf = Qw_sort(Qw_sort>Qp15);
    % Qfm = mean(Qf);
    % CVQf = std(Qf)/Qfm;
    % Qf2 = Qw_sort(Qw_sort>Qp20);
    % Qfm2 = mean(Qf2);
    % CVQf2 = std(Qf2)/Qfm2;
    % CVQf3 = std(Qw2,'omitnan')/mean(Qw2,'omitnan');
    % 
    % output = [DVIc,DVIc2,DVIy,DVIy2,p15,mean(Qw_sort,'all'),CVQf,CVQf2,CVQf3];
    % close all
    % % figure(5);hold on
    % % Qw5 = Qw(yr>=yr &yr<=1943);
    % % plot(Qw5/mean(Qw5),'-b','linewidth',1);
end
