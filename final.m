clear all; close all; clc;
[data, Fs] = audioread('WA1_20180220_175500.wav');
dataR = data(:,1);
L = length(dataR); % number of samples
x = zeros(119,1); %time
y = zeros(119,1); %energy
s = 10; %start at first 10 seconds
k = 1; m = 1; %increase x and y every for loop
for q = 1:119 %calculating energy every 10 seconds
data_seg = dataR(s*Fs: (s + 10)*Fs);
Energy = mean(data_seg.^2); %equation of energy
EnergyinDB = 10*log10(Energy/(20*10^-6)^2); %converting energy to dB
y(k,1) = EnergyinDB;
x(m,1) = s;
s = s+10;
k = k+1; m = m+1;
end
figure(1);
plot(x(:, 1), y(:,1));
hold on
plot(-900,76.5,'*r');
title('Energy of Crows Calls vs Time');
xlabel('Time (seconds)');
ylabel('Energy (dB)');
xlim([-900 1200]);
legend('Energy', 'Time of sunset');

%*****FFT*****
N = L; %total number of samples
f = linspace(0,Fs,N); %frequency
x1 = zeros(119,1); %time
y1 = zeros(119,1); %frequency
s = 10; %start time
freq_max = 0; %frequency related to max fft
k = 1; m = 1; %increase x and y every for loop
for q = 1:119 %loop to calculate frequency at max fft
data_seg = dataR(s*Fs: (s + 10)*Fs);
data_fft = fft(data_seg,N);
sig_env = envelope(abs(data_fft),5000,'rms');
[fmean1, fmeanindex1] = find(f>=500);
[fmean2, fmeanindex2] = find(f<=3000);
[fft_max, fft_max_index] = max(sig_env(fmeanindex1(1):fmeanindex2(end)));
fmax = f(fft_max_index+fmeanindex1(1));
y1(k,1) = fmax;
x1(m,1) = s;
s = s+10;
k = k+1; m = m+1;
end

figure(2);
plot(x1(:, 1), y1(:,1));
hold on
plot(-900,550,'*r');
title('Dominant Frequency vs Time');
xlabel('Time (seconds)');
ylabel('Frequency (Hz)');
ylim([500 1600]);
xlim([-900 1200]);
legend('Frequency', 'Time of sunset');

numberOfCrows = [0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;3;8;16;22;27;37;42;44;56;75;90;97;104;110;113;110;112;115;120;118;121;119;115;114;110;115;112;115;116;117;114;117;118;120;123;122;120;123;126;124;122;125;127;125;122;124;126;125;119;110;102;99;96;89;88;86;83;79;74;73;70;72;71;70;71;68;61;57;52;48;32;28;22;20;18;18;17;17;11;11;12;11;12;12];

B = zeros(2,119);
crowavg = mean(numberOfCrows(:,1)); %average of all crows
energyavg = mean(y(:,1)); %average of all the energy
for q = 1:119 %Calculate B vector
    avg = numberOfCrows(q,1) - crowavg;
    B(1,q) = avg;
    avg1 = y(q,1) - energyavg;
    B(2,q) = avg1;
end
S = (B*B')/118; %Covariance matrix

[vector,value] = eig(S); %eigen values and vector

slope = abs(vector(2,2)/vector(1,2));
eigen_energyx = [1:1:140];
eigen_energyy = zeros(1,140);
for t = 1:140
eigen_energyy(1,t) = slope*eigen_energyx(1,t)+ energyavg; %equation of eigen vector
end
figure(3)
scatter(numberOfCrows(:, 1), y1(:, 1), '*');
title('Dominant Frequency vs Number of Crows');
xlabel('Number of Crows');
ylabel('Frequency (Hz)');


figure(4)
scatter(numberOfCrows(:, 1), y(:, 1), '*');
hold on
title('Eigen Vector at Origin on Original Data');
xlabel('Number of Crows');
ylabel('Energy (dB)');
xlim([0 135]);
ylim([60 100]);
plot(eigen_energyx(1,:), eigen_energyy(1,:),'r');
legend('Signal Energy', 'Eigen Vector');
