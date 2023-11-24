clear;
close all; clc
[status,sheets] = xlsfinfo('Douglas-HW');

% the command to read the data
A=readmatrix('Douglas-HW.xls','Sheet',1); % read the first sheet
x=A(1:60);% get the first 60 rows of 1st column
y=A(61:110); % get the next 50 of 1st column
A=A(:);
y=y(~isnan(y)); % suppress the NaN
histogram(x, 'normalization', 'pdf');
hold on
grid on 
%
xlim([0,25])
ylim([0,0.3])
xx=0:0.25:1.2*max(A);% get the x-coordinates to get the ksdensity
fx1=ksdensity(x,xx);
plot(xx,fx1,'-y','linewidth',1.75)
R=fitdist((x+1),'Rician');
G=fitdist(x,'gamma');
W=fitdist(x,'weibull');
sigma=R.sigma;
N= fitdist(x,'nakagami');
mu=N.mu;
omega=N.omega;
%xi = 0:0.5:25;
xi=0:0.25:1.2*max(A);
f_r=pdf(R,xi);
f_n=pdf('nakagami',xi,mu,omega);
f_g=pdf('gamma',xi,G.a,G.b);
f_w=pdf('weibull',xi,W.a,W.b);
[fx1]=ksdensity(A,xi);
plot(xi,f_r,'r--',xi,f_n,'b-.',xi,f_g,'g*',xi,f_w,'k--','linewidth',1.7)
LN=length(xi);
MSERic1=sum((fx1-f_r).^2)/LN;
MSENaka=sum((fx1-f_n).^2)/LN;
MSEGamma=sum((fx1-f_g).^2)/LN;
MSEWeibull=sum((fx1-f_w).^2)/LN;
xlabel('values'),ylabel('density fits')
legend('histogram','ksdensity',['Rician fit: MSE =',num2str(MSERic1)],['Nakagami fit: MSE =',num2str(MSENaka)],['Gamma fit: MSE =',num2str(MSEGamma)],['Weibull fit: MSE =',num2str(MSEWeibull)])
title("Target absent")

figure, histogram(y, 'normalization', 'pdf');
hold on
grid on 
title("Target present")
xlim([0,25])
ylim([0,0.3])
xx=0:0.25:1.2*max(A);% get the x-coordinates to get the ksdensity
fy1=ksdensity(y,xx);
plot(xx,fy1,'-y','linewidth',1.75)
R1=fitdist((y+1),'Rician');
G1=fitdist(y,'gamma');
W1=fitdist(y,'weibull');
sigma1=R1.sigma;
N1= fitdist(y,'nakagami');
mu1=N1.mu;
omega1=N1.omega;
%xi = 0:0.5:25;
yi=0:0.25:1.2*max(A);
f_r1=pdf(R1,yi);
f_n1=pdf('nakagami',yi,mu1,omega1);
f_g1=pdf('gamma',yi,G1.a,G1.b);
f_w1=pdf('weibull',yi,W1.a,W1.b);
[fy1]=ksdensity(A,yi);
plot(yi,f_r1,'r--',yi,f_n1,'b-.',yi,f_g1,'g*',yi,f_w1,'k--','linewidth',1.7)
LN1=length(yi);
MSERic11=sum((fy1-f_r1).^2)/LN1;
MSENaka1=sum((fy1-f_n1).^2)/LN1;
MSEGamma1=sum((fy1-f_g1).^2)/LN1;
MSEWeibull1=sum((fy1-f_w1).^2)/LN1;
xlabel('values'),ylabel('density fits')
legend('histogram','ksdensity',['Rician fit: MSE =',num2str(MSERic11)],['Nakagami fit: MSE =',num2str(MSENaka1)],['Gamma fit: MSE =',num2str(MSEGamma)],['Weibull fit: MSE =',num2str(MSEWeibull)])
[h,p,st] = chi2gof(f_r1)
[h,p,st] = chi2gof(f_n1)
[h,p,st] = chi2gof(f_g1)
[h,p,st] = chi2gof(f_w1)

