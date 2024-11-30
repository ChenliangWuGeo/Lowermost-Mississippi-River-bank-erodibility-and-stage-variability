function output = getCurv(x,y)
%     [~,temp] = size(x);   
    dx1 = x;%nan(1,temp);
    dx2 = x;%nan(1,temp);
    dy1 = x;%nan(1,temp);
    dy2 = x;%nan(1,temp);
    
    ds = x;
    ds(2:end) = sqrt((x(2:end)-x(1:end-1)).^2 + (y(2:end)-y(1:end-1)).^2);
    ds(1) = ds(2);

    dx1(2:end) =  (x(2:end)-x(1:end-1))./ds(2:end);
    dx1(1) = dx1(2);
    dx2(2:end) = (dx1(2:end)-dx1(1:end-1))./ds(2:end);
    dx2(1) = dx2(2);

    dy1(2:end) = (y(2:end)-y(1:end-1))./ds(2:end);
    dy1(1) = dy1(2);
    dy2(2:end) = (dy1(2:end)-dy1(1:end-1))./ds(2:end);
    dy2(1) = dy2(2);

    curvature = (dx1.*dy2-dy1.*dx2)./(dx1.^2+dy1.^2).^(3/2);
    
    output = curvature;
end
