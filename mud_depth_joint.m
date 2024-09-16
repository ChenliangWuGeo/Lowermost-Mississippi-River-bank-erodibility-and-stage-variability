%assign flow depth for the geotechnical borehole
%get centerline
CL2 = getCenterlineXY(2);% get centerline of 1913

x = CL2.xy(1,:);
y = CL2.xy(2,:);
RK = CL2.RK/1e3;

% get borehole coordinate
mud_xy = readmatrix('mississippi_levee_content.xlsx','Sheet','Sheet1','Range','D2:E3370');
x_mud = mud_xy(:,1)*0.3048; %convert xy from ft to meter
y_mud = mud_xy(:,2)*0.3048; %convert xy from ft to meter 
x_mud = x_mud';
y_mud = y_mud';

mud_H = readmatrix('mississippi_levee_content.xlsx','Sheet','Sheet1','Range','F2:F3370');
mud_H = [nan;mud_H];

mud_Hmax =  readmatrix('mississippi_levee_content.xlsx','Sheet','Sheet1','Range','H2:H3370');
mud_Hmax (mud_Hmax==-999)= nan;

bankType = readmatrix('mississippi_levee_content.xlsx','Sheet','Sheet1','Range','G2:G3370');

silt_Hmax =  readmatrix('mississippi_levee_content.xlsx','Sheet','Sheet1','Range','I2:I3370');
silt_Hmax (silt_Hmax == -999) = nan;

sand_Hmax =  readmatrix('mississippi_levee_content.xlsx','Sheet','Sheet1','Range','J2:J3370');
sand_Hmax (sand_Hmax == -999) = nan;

%find RK for borehole by matching with the nearing RK measurement
a = length(x);
b = length(x_mud);
distMud = nan(a,b);%distance b/w borehole points and central line points

for i = 1:a
    for j = 1:b
        distMud(i,j) = sqrt((x_mud(j)-x(i))^2+(y_mud(j)-y(i))^2);
    end
end

[~,idx] = min(distMud);%find idx of nearest point from central line to borehole
RK_mud = RK(idx);% get RK for borehole




