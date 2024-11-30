tempx = 1:length(timeVe);
tempy = StVe;
x = tempx';
f = tempy';
x(isnan(CiVe)) = nan;
f(isnan(CiVe)) = nan;

% Define the vertices: the points at (x, f(x)) and (x, 0)
N = length(x);
verts = [x(:), f(:); x(:) zeros(N,1)+1.5];
% Define the faces to connect each adjacent f(x) and the corresponding points at y = 0.
q = (1:N-1)';
faces = [q, q+1, q+N+1, q+N];
figure(1);hold on
subplot(1,2,2);hold on
p2 = patch('Faces', faces, 'Vertices', verts,'FaceColor', [200, 200, 200]/256, 'EdgeColor', 'none');

