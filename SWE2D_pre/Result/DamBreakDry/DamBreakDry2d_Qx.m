%% DamBreakQx
% Exact solution for flux qx
function qx = DamBreakDry2d_Qx(x, y, t)
h0    = 10;
xc    = 500;
theta = (x - xc)/t;
g     = 9.81; 
sgh   = sqrt(g*h0);

qx    = zeros(size(x));
h     = zeros(size(x));

% wet part
ind    = theta < -sgh;
h(ind) = h0;
qx(ind)= 0;

ind    = theta > 2*sgh;
h(ind) = 0;
qx(ind)= 0;

ind    = (theta >= -sgh) & (theta <= 2*sgh);
h(ind) = 1/9/g*(theta(ind) - 2*sgh).^2;
u      = 2/3*(theta(ind) + sgh);
qx(ind)=u.*h(ind);

end% func