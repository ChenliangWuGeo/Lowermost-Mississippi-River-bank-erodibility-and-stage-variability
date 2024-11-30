function DV = calculateDV (DV,discharge)
    for m = 1 : length(DV)
        month = discharge(m).data(:,1);
        % day = xlsread('globalDischarge.xlsx',riverName(riverNo),'B:B');
        yr = discharge(m).data(:,2);
        Qw = discharge(m).data(:,3);
        
        yrStart = min(yr);
        yrEnd = max(yr);
        % yrDam = yrDam(m);
        yr_unique = unique(yr);
    
        noYear = length(yr_unique);
        aveMonth = nan(noYear,12);
        maxQw = nan(1,noYear);
        minQw = nan(1,noYear);
        
        for i = 1 : noYear
            % get max and min daily Qw
            maxQw(i) = max(Qw(yr == yr_unique(i)));
            minQw(i) = min(Qw(yr == yr_unique(i)));
        end
    

        %% calculate recurrence interval
        maxQw2 = maxQw(1:noYear);
        temp  = maxQw2;
        temp(temp==0) = [];
        temp(isnan(temp)) = [];
        Qw_sort = sort(temp,'descend');
        [n,~] = size(Qw_sort');
        p_exceed = ((1:n)/(n+1)*100)';
        returnInterval = 1./p_exceed * 100;
    
        pkQw = max(temp);
        pd = fitdist(Qw_sort','gamma');
        p = gamcdf((1:pkQw),pd.a,pd.b);
    
   
        [alpha,beta,xi,Gamma] = pearson3_fit(Qw_sort);
        Q_range = (1:pkQw);
        [cdf]=pearson3_cdf(Q_range,alpha,beta,xi,Gamma);
        cdf_range = cdf(cdf>0.001);%the distribution will have lower limit larger than 1, so rid of nan values
        Q_range = Q_range(cdf>0.001);
        Qp15 = interp1(1./(1-cdf_range),Q_range,(1.5));
        Qp20 = interp1(1./(1-cdf_range),Q_range,(2));
        Qp30 = interp1(1./(1-cdf_range),Q_range,(3));
        Qp40 = interp1(1./(1-cdf_range),Q_range,(4));
    
        %% calculate flow duration curve
        Qw(Qw==0) = []; % there are entries of discharge value zero
        Qw(isnan(Qw)) = [];
        Qw_sort = sort(Qw,'descend');
        [~,n] = size(Qw_sort');
        p_exceed = ((1:n)/(n+1)*100)';
        
        [temp,~] = size(Qw_sort);
        Qw_sort2 = Qw_sort + (1:temp)'*1e-9; %add small perturbation so values are unique
    
        p15 = interp1(flipud(Qw_sort2/mean(Qw_sort,'all')),flipud(p_exceed),Qp15/mean(Qw_sort,'all'));
        p20 = interp1(flipud(Qw_sort2/mean(Qw_sort,'all')),flipud(p_exceed),Qp20/mean(Qw_sort,'all'));
    
        cv = nan(1,noYear);
        for i = 1 : noYear
            tempQw = Qw(yr == yr_unique(i));
            qf = tempQw(tempQw>Qp15);           
            cv1(i) = std(qf,'omitnan')/mean(qf,'omitnan');
            cv2(i) = std(tempQw,'omitnan')/mean(Qw,'omitnan');
        end
    
    
        Qf = Qw_sort(Qw_sort>Qp15);
        Qfm = mean(Qf);
        CVQf = std(Qf)/Qfm;
        
        Qf2 = Qw_sort(Qw_sort>Qp20);
        Qfm2 = mean(Qf2);
        CVQf2 = std(Qf2)/Qfm2;
       
        Qm = mean(Qw,'omitnan');
        CVQf3 = std(Qw,'omitnan')/Qm;
    
        % Qmp = mean(maxQw);%mean of annual peak discharge
        % CVQf4 = Qmp/Qm;
        CVQf4 = std(maxQw)/mean(maxQw);

        CV1m = mean(cv1,'omitnan');
        CV2m = mean(cv2,'omitnan');
    
        Q95 = prctile(Qw,95);
        CVQf5 = Q95/Qm;
    
        If = length(Qf)/length(Qw_sort);
    
        DV(m,:) = [p15,Qm,CVQf,CVQf2,CVQf3,CVQf4,CV1m,CV2m,CVQf5,If, noYear];
        % keyboard
        % close all
    end
end