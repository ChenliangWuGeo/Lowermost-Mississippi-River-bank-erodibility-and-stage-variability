function bootStd= movbootstrap(xtemp,winLength)
    xlength = length(xtemp);
    % bootMean = nan(1,xlength);
    bootStd = nan(1,xlength);
    for i = 1:winLength
        subsample = xtemp(1:i+winLength);
        subsample = subsample(~isnan(subsample));
        bootMean = bootstrp(100,@mean,subsample);
        bootStd(i) = std(bootMean,'omitnan');
    end
    for i = winLength+1 : xlength-winLength 
        subsample = xtemp(i-winLength : i+winLength);
        subsample = subsample(~isnan(subsample));
        bootMean = bootstrp(100,@mean,subsample);
        bootStd(i) = std(bootMean,'omitnan');
    end
    for i = xlength-winLength+1 : xlength
        subsample = xtemp(i-winLength:xlength);
        subsample = subsample(~isnan(subsample));
        bootMean = bootstrp(100,@mean,subsample);
        bootStd(i) = std(bootMean,'omitnan');
    end
end