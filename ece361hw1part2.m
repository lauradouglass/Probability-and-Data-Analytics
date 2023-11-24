clear;
close all; clc
[status,sheets] = xlsfinfo('Douglas-HW');
% the command to read the data
A=readmatrix('Douglas-HW.xls','Sheet',1); % read the first sheet
x=A(1:60);% get the first 60 rows of 1st column
y=A(61:110); % get the next 50 of 1st column
A=A(:);
% x and y are of different lengths. Because of this, y contains NaN
y=y(~isnan(y)); % suppress the NaN
histogram(x, 'normalization', 'pdf');
hold on 
grid on 
histogram(y, 'normalization', 'pdf');

xlim([0,25])
ylim([0,0.3])

xx=0:0.25:1.2*max(A);% get the x-coordinates to get the ksdensity

fx1=ksdensity(x,xx);
plot(xx,fx1,'-y','linewidth',1.75)

fy1=ksdensity(y,xx);
plot(xx,fy1,'-g','linewidth',1.75, "LineStyle","--")

xlabel('values'),ylabel('estimated density');

peaks_fx1 = findpeaks(fx1);
peaks_fy1 = findpeaks(fy1);

plot(2, 0.2038, "red", "Marker","o", "LineWidth", 2)
plot(6.5, 0.0908, '*k', "Marker", "square", "LineWidth", 2)

legend('Target absent','Target present','fit H0','fit H1','peak H0','peak H1');