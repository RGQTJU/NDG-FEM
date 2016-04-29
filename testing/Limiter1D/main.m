function main
x1 = 0; x2 = 1; eleNum = 100; nOrder = 2;
mesh = getLineMesh(x1, x2, eleNum, nOrder);
var = getInitialCondition(mesh, x1, x2);

% draw initial condition
figure
subplot(4,2,[5:8])
plot(mesh.x(:), var(:), 'b')
ylim([-.2, 1.2]); grid on; hold on;

fprintf('method \t L1 \t L2 \n');

% limiter test iteartions
iterNum = 100;

%% minmod
varlimit = var;
for i = 1:iterNum
    varlimit = Utilities.Limiter.Limiter1D.MinmodLinear(mesh, varlimit);
end
subplot(4,2,1)
plot(mesh.x(:), var(:), 'b', mesh.x(:), varlimit(:), 'r');
ylim([-.2, 1.2]); grid on;
xlabel('minmod')

subplot(4,2,[5:8])
plot(mesh.x(:), varlimit(:), '*-')

L1 = L1norm(varlimit, var);
L2 = L2norm(varlimit, var);
fprintf('minmod \t %f \t %f \n', L1, L2);
%% modification minmod
varlimit = var;
for i = 1:iterNum
    varlimit = Utilities.Limiter.Limiter1D.MinmodModified(mesh, varlimit);
end
subplot(4,2,2)
plot(mesh.x(:), var(:), 'b', mesh.x(:), varlimit(:), 'r');
ylim([-.2, 1.2]); grid on;
xlabel('modified minmod')

subplot(4,2,[5:8])
plot(mesh.x(:), varlimit(:), 's-')

L1 = L1norm(varlimit, var);
L2 = L2norm(varlimit, var);
fprintf('modified minmod \t %f \t %f \n', L1, L2);

%% moment limiter of Biswas

varlimit = var;
for i = 1:iterNum
    varlimit = Utilities.Limiter.Limiter1D.MomentBDF(mesh, varlimit);
end
subplot(4,2,3)
plot(mesh.x(:), var(:), 'b', mesh.x(:), varlimit(:), 'r');
ylim([-.2, 1.2]); grid on;
xlabel('BDF')

subplot(4,2,[5:8])
plot(mesh.x(:), varlimit(:), '^-')

L1 = L1norm(varlimit, var);
L2 = L2norm(varlimit, var);
fprintf('BDF \t %f \t %f \n', L1, L2);

%% MMP

varlimit = var;
for i = 1:iterNum
    varlimit = Utilities.Limiter.Limiter1D.MMPlim(mesh, varlimit);
end
subplot(4,2,4)
plot(mesh.x(:), var(:), 'b', mesh.x(:), varlimit(:), 'r');
ylim([-.2, 1.2]); grid on;
xlabel('MMP')


subplot(4,2,[5:8])
plot(mesh.x(:), varlimit(:), 'o-')
xlim([0.255, 0.285]); ylim([0.7, 1.05]);
legend('exat', 'minmod', 'modified minmod', 'BDF', 'MMP')

L1 = L1norm(varlimit, var);
L2 = L2norm(varlimit, var);
fprintf('MMP \t %f \t %f \n', L1, L2);

end% func


function L1 = L1norm(var1, var2)
L1 = max( max(abs(var1 - var2)));
end

function L2 = L2norm(var1, var2)
L2 = sqrt( sum2( (var1 - var2 ).^2 )./numel(var1) );
end% func

function a = sum2(v)
a = sum(sum(v));
end