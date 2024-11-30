%calculate sediment concentration profile and overbank sediment supply
[idx, ~] = find(~isnan(hBR));%find idx of ~nan values for flow depth
n = length(idx);
ciLimit = 2e-6;%instrumental detection limit for sediment concentration
CiBR = nan(size(hBR));%pre-allocate for sediment concentration profile
hLimit = 15.5;%bankfull flow depth
%rouse modeling
for ii = 1:n
    i = idx(ii);
    H = hBR(i);
    Hi = 0.09*H : 0.05*H : H;
    m = length(Hi);
    
    for j = 1:m
        ciBR(j) = (epsilonZa(i)/(1-epsilonZa(i))) * (((H-Hi(j))/Hi(j))*(za(i)/(H-za(i))))^p(i);
    end
    
    CiBR(i) = sum(ciBR(ciBR>ciLimit & Hi>hLimit))  * 0.05*H;
    clearvars ciBR
end

CiBR(CiBR==0) = nan;

%calculate number of sand transporting flood events
f=CiBR;
f(~isnan(f))=1;
f(isnan(f))=0;
det = f(2:end)-f(1:end-1);
det(det==-1) = 0;
daySandBR = sum(f);
percSandBR = daySandBR/totalTimeBR;
NoSandBR = sum(det);