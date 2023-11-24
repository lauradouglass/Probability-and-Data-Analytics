clear;
close all; clc
[status,sheets] = xlsfinfo('Douglas-HW');

% the command to read the data
A=readmatrix('Douglas-HW.xls','Sheet',1); % read the first sheet
x=A(1:60);% get the first 60 rows of 1st column
y=A(61:110); % get the next 50 of 1st column
A=A(:);
% x and y are of different lengths. Because of this, y contains NaN
y=y(~isnan(y));

ecdf(x)
hold on 
grid on 
ecdf(y)
title("Laura Douglas Hw3 Part2. Intersection Threshold: 0.0863")
[f,xi] = ksdensity(x,'Function','cdf');
plot(xi,f)
[f,yi] = ksdensity(y,'Function','cdf');
plot(yi,f)

N0 = size(x,1);
N1 = size(y,1);
N = N0 + N1;
Vt = 5;
Nf = 13;
Nc = 36;
ppv = Nc/(Nf + Nc);
pm = Nf/110;
pf = Nc/110;
c = 1-pf;
plot(f(find(pm))+2.8,pm,'r*')
plot(f(find(c))+4,c,'b*')
legend('ecdfH0','ecdfH1','FH0','FH1','Pm','1-Pf')