%% plot Baton Rouge
tempx = 1:length(timeBR);
tempy = StBR;
bankfullStage = 30;

%interpolate to replace nan 
inn = ~isnan(tempy);
i1 = (1:numel(tempy)).';
tempy = interp1(i1(inn),tempy(inn),i1,'linear');
StBR = tempy;%this will alter the original record

x = tempx';
f = tempy';
f(f<bankfullStage) = nan;
x(f<bankfullStage) = nan;

N = length(x);
verts = [x(:), f(:); x(:) zeros(N,1)+30];
% Define the faces to connect each adjacent f(x) and the corresponding points at y = 0.
q = (1:N-1)';
faces = [q, q+1, q+N+1, q+N];
figure(1);hold on
subplot(1,2,1);hold on
p1 = patch('Faces', faces, 'Vertices', verts, 'FaceColor', [0 0 0], 'EdgeColor', 'none');
hold on
plot(tempx, StBR,'-k')
plot([tempx(1),tempx(end)],[bankfullStage,bankfullStage],':k')
ylim([0 45])
ylabel('stage (m)');

%calculate number of flood events
f(1:6200) = nan;%set dates prior to available discharge record to nan
f(12541:end) = nan;
totalTimeBR = 12541-6200;
f(~isnan(f))=1;
f(isnan(f))=0;
det = f(2:end)-f(1:end-1);
det(det==-1) = 0;
dayFloodBR = sum(f);
percFloodBR = dayFloodBR/totalTimeBR;
NoFloodBR = sum(det);

%% plot Venice
tempx = 1:length(timeVe);
tempy = StVe;
bankfullStage = 1.5;
inn = ~isnan(tempy);
i1 = (1:numel(tempy)).';
tempy = interp1(i1(inn),tempy(inn),i1,'linear');
StVe = tempy;%this will alter the original record
x = tempx';
f = tempy';
f(f<bankfullStage) = nan;
x(f<bankfullStage) = nan;

N = length(x);
verts = [x(:), f(:); x(:) zeros(N,1)+1.5];
% Define the faces to connect each adjacent f(x) and the corresponding points at y = 0.
q = (1:N-1)';
faces = [q, q+1, q+N+1, q+N];
figure(1);hold on
subplot(1,2,2);hold on
p1 = patch('Faces', faces, 'Vertices', verts, 'FaceColor', [0 0 0], 'EdgeColor', 'none');
ylim([-1 6])
ylabel('stage (m)');
xlabel('year')
plot(tempx, StVe,'-k')
plot([tempx(1),tempx(end)],[bankfullStage,bankfullStage],':k')


%calculate number of flood events
f(1:6207) = nan;%set dates prior to available discharge record to nan
f(12548:end) = nan;
f(~isnan(f))=1;
f(isnan(f))=0;
det = f(2:end)-f(1:end-1);
det(det==-1) = 0;
dayFloodVe = sum(f);
percFloodVe = dayFloodVe/totalTimeBR;
NoFloodVe = sum(det);
