B = zeros(2,119);
crowavg = mean(numberOfCrows(:,1));
energyavg = mean(y(:,1));
for q = 1:119
    avg = numberOfCrows(q,1) - crowavg;
    B(1,q) = avg;
    avg1 = y(q,1) - energyavg;
    B(2,q) = avg1;
end
S = (B*B')/118;

[vector,value] = eig(S);

slope = abs(vector(2,2)/vector(1,2));
eigen_energyx = [1:1:140];
eigen_energyy = zeros(1,140);
for t = 1:140
eigen_energyy(1,t) = slope*eigen_energyx(1,t)+min(y);
end


figure(3)
scatter(numberOfCrows(:, 1), y(:, 1), '*');
hold on
title('Energy of Crows Calls vs Number of Crows');
xlabel('Number of Crows');
ylabel('Energy (dB)');
xlim([0 140]);
ylim([min(y) max(y)]);
plot(eigen_energyx(1,:), eigen_energyy(1,:),'b');
