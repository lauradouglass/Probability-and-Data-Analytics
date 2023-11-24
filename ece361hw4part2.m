clear;
close all; clc
[status,sheets] = xlsfinfo('Douglas-HW');

% the command to read the data
A=readmatrix('Douglas-HW.xls','Sheet',1); % read the first sheet
x=A(1:60);% get the first 60 rows of 1st column
y=A(61:110); % get the next 50 of 1st column
A=A(:);
% x and y are of different lengths. Because of this, y contains NaN
%y=y(~isnan(y));
N0 = size(x,1);
N1 = size(y,1);
dat = [x;y];
resp=[zeros(N0,1);ones(N1,1)];
[pf,pd,T,AUC,OPTOCPT]=perfcurve(resp,dat,1);
[~,idxy]=max(pd+(1-pf)-1);
pf(idxy)
pd(idxy)
figure,plot(pf,pd)
xlabel('P_F'),ylabel('P_D'),text(0.3,0.2,[' AUC = ',num2str(AUC)])
hold on
text(0.5,0.5,'\leftarrow Chance line, P_F=P_D')
title('Receiver Operating Characteristics (ROC) curve. Pf=0.0864 Pm=0.0833','color','b')
hold on
plot([0,1],[0,1])
fill([pf',1,1,1,1,1,1],[pd',1,0.7,0.5,0.3,0.1,0],'y','faceAlpha',0.2)
disp(' ')
disp('Threshold from perfcurve(.): uses the maximum value twice to get N+1 threshold values')
disp('perfcurve(.) inserts the maximum value again on top')
disp(' ')
disp('create threshold from the definition of the CDF and the prob. false alarm')
disp('and prob. detection: counts exceeding the threshold. This requires inserting')
disp('a 0 at the bottom of the column to get the (N+1) threshold values')
% create the threshold based on CDF
TT=sort(dat,'descend');
TT=[TT;0];
disp(' ')
disp('Threshold values ')
disp('perfcurve(.) CDF based')
disp([T,TT])
%perfindex
meanx = mean(x);
varx = var(x);
meany = mean(y);
vary = var(y);
pItop = abs(meanx - meany);
pIbottom = sqrt(varx+vary);
pI = pItop/pIbottom;
text(0.5, 0.2,['Perfomance Index =', num2str(pI)])
plot(0.0833333,0.64,'r*') %optimum
N=N0+N1;
Nf = 59;
Nc= 50;
confusionM = [(N0 - Nf), (N1 -Nc); (Nf), (Nc)];
errorrate = (Nf + (N1 - Nc))/N;
ppv = Nc/(Nf + Nc);
text(0.3, 0.1,['ppv =', num2str(ppv)])
text(0.5, 0.1,['error rate =', num2str(errorrate)])
text(0.5,0.4,['confusion matrix = [ 1 , 0 ; 59 , 50 ]'])
p1 = [2, 0.2038];
p2 = [6.5, 0.0908];
midpoint = (p1(:) + p2(:)).'/2;
intersection = [5, 0.0863];
plot(0.1473,0.64,'g*') %midpoint
plot(0.0863,0.54,'b*') %intersection
legend('ROC','chance line', 'ROC shading','optimum threshold','midpoint threshold','intersection threshold')

% [f,xi] = ksdensity(x);
% figure, plot(xi,f);
% hold on 
% [f, yi] = ksdensity(y);
% plot(yi,f)
% title('Threshold (optimum): thr = 0.64. Pf=0.0864 Pm=0.0833')
% legend('target absent','target present')

