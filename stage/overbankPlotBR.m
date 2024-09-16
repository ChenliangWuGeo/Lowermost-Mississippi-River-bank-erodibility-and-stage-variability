tempx = 1:length(timeBR);
tempy = StBR;
bankfullStage = 30;
x = tempx';
f = tempy';
x(isnan(CiBR)) = nan;
f(isnan(CiBR)) = nan;
% Define the vertices: the points at (x, f(x)) and (x, 0)
N = length(x);
verts = [x(:), f(:); x(:) zeros(N,1)+30];
% Define the faces to connect each adjacent f(x) and the corresponding points at y = 0.
q = (1:N-1)';
faces = [q, q+1, q+N+1, q+N];
figure(1);hold on
subplot(2,2,1);hold on
p = patch('Faces', faces, 'Vertices', verts,'FaceColor', [200, 200, 200]/256, 'EdgeColor', 'none');
