function res = solvingFourthOrderPDE()
% initiate array
m = 1000;    % number of time positions
n = 1000;     % number of space positions
w = 10;
A = 80;
totalTime = 10;
dt = totalTime/m;
totalDistance = 2*pi;
dx = totalDistance/n;

pos = zeros(m,n,3);                  % m is rows, n is columns
x = linspace(0,totalDistance,n);     % x is vector of equally spaced distances spanning accross total distance n times
% pos(1,:,1) = sin(2*x);                 % setting position at time = 1
a = ones(n,1);                       % coefficient of uxx based on space
b = .01 *ones(n,1);                  % coefficient of uxxxx based on space%

time = linspace(0,totalTime,m);     

for i = 1:m
p = polyfix(x,pos(i,:,1),15,[0, 2*pi],[0, 0], [0, 2*pi], [0, 0]);
pos(i,:,1) = polyval(p,x);

pos(i+1,:,3) = solvingUtt(p) + A*sin(w*i*dt);
pos(i+1,:,2) = pos(i,:,2)+dt*pos(i+1,:,3);
pos(i+1,:,1) = pos(i,:,1) + dt*pos(i+1,:,2);
end

for i = 1:m
    % plot(x,pos(i,:,3), '-r')
    % hold on

    plot(x, pos(i, :, 1), '-b')
    axis([0 2*pi -10 10])
    % legend('Utt', 'U')
    pause(.0001)
    clf
end

    function res = solvingUtt(p)
        res = polyval(polyder(polyder(p)), x) - x .* polyval(polyder(polyder(polyder(polyder(p)))), x);
    end

    % Creates a discrete derivative matrix of a given order for a row vector
    % of size n. Multiply this matrix by a column vector x in order to get the
    % resulting derivative
    function M = makeDiffMat(n, order)
        M = zeros(n);
        M = eye(n);
        M = M + diag(-1*ones(n-1,1),-1);
        M = M^order;
        M(1:order, :) = repmat(M(order+1, :),order,1);

    end





end




