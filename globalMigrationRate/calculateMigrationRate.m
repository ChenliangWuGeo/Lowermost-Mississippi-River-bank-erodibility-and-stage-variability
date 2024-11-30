load batch2LMR.mat
%group 1 
migRateA = [6.6,3.067163,1.9,1.0324, 1.6];
migRateB = [0.9, 12.3, 2.037274, 1.5];
widthA = [1300,220,500,150,1250];%channel width
widthB = [200,125,200,400];
migRateG1 = [migRateA,migRateB]./([widthA, widthB]);

%group 2
batch2B = [410,523,975,988,280,165,240,120,95,240];
migRateG2 = batch2LMR(:,3)'./batch2B./DV(10:19,1)';

%group 3
batch3B = [268,64,99, 286, 96, 110, 116, 53, 44, 4400, 150.9, 123, 220, 125, 135,...
    635, 140, 106, 62, 94, 92];
tempMigRate = [4.5, 1.2, 4, 2.3, 1, 0.9, 0.66, 0.49, 1.2, 54, 0.79, 0.6, 1.8, 1, 1.5,...
    9.2, 1.6, 1.2, 1.2, 0.9, 1.5];
migRateG3 = tempMigRate./batch3B;

%group 4 compiled by duhwan
batch4B = [57, 91, 89, 75, 67, 62, 148.9, 132.6, 198.2, 52, 98.15, 95,...
    79, 281, 127, 41, 100, 466.84, 1270, 420, 47, 55.76, 84.69, 135];
tempMigRate = [0.51, 2.01, 0.74, 0.45, 0.66, 11.74, 2.09, 1.56, 0.97, 2.65, 1.32,...
    9.41, 2.52, 7, 6, 1.7, 1, 3.8, 2.98, 4.37, 3, 6.81, 0.48, 3.07];
migRateG4 = tempMigRate./batch4B;

migRate = [migRateG1,migRateG2,migRateG3,migRateG4];

figure(1);hold on
xlabeltext = {"CoV (Qw)","yearly average CoV (Qf)","yearly average CoV (Qw)"};
temp = (DV(:,2));
If = DV(:,10);
sz = log(temp).^2;
x = DV(:,7);
y = log10(migRate);
scatter(x,y,sz,'o')
riverCount = length(migRate);
riverNum = (1:riverCount);
riverNum = num2str(riverNum');
text(x,y,riverNum)
xlabel(xlabeltext(2));
ylabel("log(r*)");
close all

