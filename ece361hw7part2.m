clear all; clc;
file = 'Douglas-HW.xls';
nsmooth=8;
A = xlsread(file);
absent = A(1:60);
present = A(61:110);


[bootstat,bootsam] = bootstrp(7,[],absent);
y = absent(bootsam);
nb=5000;
ym=bootstrp(nb,@mean,absent);
figure;
histfit(ym,20)
two = prctile(ym,2.5); % 2.5%
nine = prctile(ym,97.5); % 97.5%
%prctile(ym,50)
S = std(absent)/sqrt(length(absent));
M = mean(absent);
xlabel('Boot Samples')
ylabel('Frequency')
title('Douglas Stats of mean(H_0): Mean, Std. Dev., 95% Cl')
txt = 'Std. Dev. =  0.2671, Mean = 3.3355, 95% of mean = [2.8276, 3.8731 ]';
text(2.5, 800, txt)


[bootstat,bootsam] = bootstrp(7,[],present);
y1 = present(bootsam);
nb=5000;
ym1=bootstrp(nb,@mean,present);
figure;
histfit(ym1,20)
two1 = prctile(ym1,2.5); % 2.5%
nine1 = prctile(ym1,97.5); % 97.5%
%prctile(ym,50)
S1 = std(present)/sqrt(length(present));
M1 = mean(present);
xlabel('Boot Samples')
ylabel('Frequency')
title('Douglas Stats of mean(H_1): Mean, Std. Dev., 95% Cl')
txt = 'Std. Dev. =  0.5521, Mean = 7.9234, 95% of mean = [6.8776, 9.0463]';
text(6, 780, txt)


N0 = length(absent);
N1 = length(present);
dat = A;
resp = [zeros(N0,1);ones(N1,1)];
[pf,pd,T,AUC,OPTOCPT] = perfcurve(resp,dat,1);


nb=5000;
ym2=bootstrp(nb,@calculateROCarea,resp,dat);
figure;
histfit(ym2,20)
two2 = prctile(ym2,2.5); % 2.5%
nine2 = prctile(ym2,97.5); % 97.5%
%prctile(ym,50)
xlabel('Samples of AUC')
ylabel('Frequency')
title('Douglas Stats of AUC: Mean, Std. Dev., 95% Cl')
txt2 = {['Std. Dev. = ', num2str(std(ym2))], ['Mean = ', num2str(mean(ym2))], ['95% of mean = [', num2str(two2), ', ', num2str(nine2),']']};
text(0.7, 700, txt2)

function area=calculateROCarea(resp,dat)
[pf,pd,T,AUC]=perfcurve(resp,dat,1);
area=AUC;
end