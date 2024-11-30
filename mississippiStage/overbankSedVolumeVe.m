%calculate sediment concentration profile and overbank sediment supply
[idx, ~] = find(~isnan(hVe));%find idx of ~nan values for flow depth
n = length(idx);
ciLimit = 2e-6;%instrumental detection limit for sediment concentration
CiVe = nan(size(hVe));%pre-allocate for sediment concentration profile
hLimit = 17.2;%bankfull flow depth
%rouse modeling
for ii = 1:n
    i = idx(ii);
    H = hVe(i);
    Hi = 0.09*H : 0.05*H : H;
    m = length(Hi);
    for j = 1:m
        ciVe(j) = (epsilonZa(i)/(1-epsilonZa(i))) * (((H-Hi(j))/Hi(j))*(za(i)/(H-za(i))))^p(i);
    end
    
    CiVe(i) = sum(ciVe(ciVe>ciLimit & Hi>hLimit))  * 0.05*H;
    clearvars ciVe
end
CiVe(CiVe==0) = nan;

%calculate number of sand transporting flood events
f=CiVe;
f(~isnan(f))=1;
f(isnan(f))=0;
det = f(2:end)-f(1:end-1);
det(det==-1) = 0;
daySandVe = sum(f);
percSandVe = daySandVe/totalTimeBR;
NoSandVe = sum(det);