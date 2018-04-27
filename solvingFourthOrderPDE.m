function res = solvingFourthOrderPDE()
% initiate array
m = 1000;    % number of time positions
n = 1000;     % number of space positions

totalTime = 10;
dt = totalTime/m;
totalDistance = 2*pi;
dx = totalDistance/n;

pos = zeros(m,n,3);                  % m is rows, n is columns
x = linspace(0,totalDistance,n);     % x is vector of equally spaced distances spanning accross total distance n times
pos(1,:,1) = sin(2*x);                 % setting position at time = 1
%plot(pos(1,:,1))
a = ones(n,1);                       % coefficient of uxx based on space
b = .01 *ones(n,1);                  % coefficient of uxxxx based on space%
% conditions = ones(m,n,3)/0;          
% conditions(:,1,1) = 0;
% conditions(:,m,1) = 0;
time = linspace(0,totalTime,m);     

%plot(x,sin(x))
%hold on
%plot(x,padDiff(padDiff(sin(x))))
%plot(x(1,end-2),diff(sin(x),2)','ro')
    function res = solvingUtt(p)

        res = polyval(polyder(polyder(p)), x);
        res = res - polyval(polyder(polyder(polyder(polyder(p)))), x);
         %padDiff(padDiff(padDiff(padDiff(X))));
    end

%     function ans = padDiff(X)
% 
%     ans = diff(X)/dx;
%     ans(end+1)= 0;
% %     p = polyfix(x,ans, 7 );
%     
%     ans = polyval(p,x);
%     end

for i = 1:m
p = polyfix(x,pos(i,:,1),15,[0, 2*pi],[0, 0], [0, 2*pi], [0, 0]);
pos(i,:,1) = polyval(p,x);

pos(i+1,:,3) = solvingUtt(p);
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

















end




