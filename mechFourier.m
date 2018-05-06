function mechFourier
w = 4;
K = 5;
couplingK = 2.5
tRange = linspace(0, 1/w*200, 1000);
numMasses = 20;
damp = .1;
masses = linspace(0, 1, numMasses);
init = zeros(1, numMasses*2);
M = makeM(masses, damp);

f = figure;

ax = axes('Parent',f,'position',[0.13 0.39  0.77 0.54]);

sW = uicontrol('Parent',f,'Style','slider','Position',[81,54,419,23],...
              'value',w, 'min',2.3, 'max',5, 'String','Driving Frequency');
          
sW.Callback = @(es,ed) updateSystemW(es.Value); 

sD = uicontrol('Parent',f,'Style','slider','Position',[81,85,419,23],...
              'value',damp, 'min',0, 'max',2, 'String','Damping Ratio');

sD.Callback = @(es, ed) updateSystemDamp(es.Value);

sC = uicontrol('Parent',f,'Style','slider','Position',[81,115,419,23],...
              'String','Coupling Coefficient', 'value',couplingK, 'min',0, 'max',5);

sC.Callback = @(es, ed) updateSystemCoupling(es.Value);

driving= makeDriving(w, 1);
[T, X] = ode45(@odeFunc, tRange, init);
plot(masses, max(X(:, numMasses+1:end), [], 1))

%  max(X(:, numMasses+1:end), 1)
for t = 1:length(T)
plot(masses, X(t, numMasses+1:end), '*')
axis([0, 1, -10, 10])
pause(.1)
end

function updateSystemW(wU)
    w = wU;
    driving= makeDriving(w, 1);
    [T, X] = ode45(@odeFunc, tRange, init);
    plot(masses, max(X(:, numMasses+1:end), [], 1))
end

function updateSystemDamp(dampU)
    damp = dampU;
    M = makeM(masses, damp);
    driving= makeDriving(w, 1);
    [T, X] = ode45(@odeFunc, tRange, init);
    plot(masses, max(X(:, numMasses+1:end), [], 1))
end

function updateSystemCoupling(Coupling)
    couplingK = Coupling;
    M = makeM(masses, damp);
    driving= makeDriving(w, 1);
    [T, X] = ode45(@odeFunc, tRange, init);
    plot(masses, max(X(:, numMasses+1:end), [], 1))
end

function B = odeFunc(t,X)
    B = M*X + driving(t);
end 

function M = makeM(X, damp)
    M = zeros(numMasses*2);
    
    M(1:numMasses,numMasses+1:end) = eye(numMasses);
    M(numMasses+1:end,1:numMasses) =  couplingK*diag(ones(numMasses-1,1),1) + couplingK*diag(ones(numMasses-1,1),-1) -K*diag(makeStiffness(numMasses));
    M(numMasses+1:end,numMasses+1:end) = diag(ones(numMasses,1),0)*-damp;
end

function S = makeStiffness(Len)
    S = linspace(1, 5, Len);
%     S = ones(Len, 1)
end


function driving = makeDriving(w, A)
    driveMatrix = zeros(numMasses*2, 1);
    driveMatrix(numMasses+1:end) = 1;
    driving = @(t) A*sin(w*t)*driveMatrix;
end

end