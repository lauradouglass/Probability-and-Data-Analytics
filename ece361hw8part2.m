clear;
close all; clc
[status,sheets] = xlsfinfo('Douglas-HW8Part2.xls');
% the command to read the data
orig = readmatrix('Douglas-HW8Part2.xls','Sheet',1);
parG = fitdist(orig, 'gamma');
a = parG.a;
b = parG.b;
mean1 = (a.*b);
t = (a.*b)./2;

truncate = orig(orig>t);
parG1 = fitdist(truncate, 'gamma');
a1 = parG1.a;
b1 = parG1.b;
mean2 = (a1.*b1);

censor = orig;
censor(censor < t) = 0;
parG2 = fitdist(censor, 'gamma');
a3 = parG2.a;
b3 = parG2.b;
mean3 = (a3.*b3);

xx = uint32(1):uint32(250);
x = reshape(xx,[],1);

s1 = subplot(3,1,1);
scatter(x,orig, 'r')
ylim(s1,[0 40]);
legend('original','Location','northwest')
grid on 

s2 = subplot(3,1,2);
scatter(x,censor, 'c')
ylim(s2,[0 40]);
legend('censored','Location','northwest')
grid on 

s3 = subplot(3,1,3);
%scatter(x,(truncate(~cellfun('isempty',truncate))),'g')
ylim(s3,[0 40]);
legend('truncated','Location','northwest')
grid on 


figure; 
grid on
xx1 = 0:0.15:1.15*max(orig);
fxx1 = ksdensity(orig, xx1);
plot(xx1,fxx1,'-r','Linewidth',2)
title("Theoretical Densities (Laura HW 8 Part 2)")
hold on
xx2 = t:0.15:1.15*max(censor);
fxx2 = ksdensity(censor, xx2);
plot(xx2,fxx2,'-g','Linewidth',2)
l1 = line([t t],[0 0.0265], 'Color', 'g','Linewidth',2);
l2 = line([0 0],[0 0.04], 'Color', 'g','Linewidth',2);
l3 = line([0 t],[0 0], 'Color', 'g','Linewidth',2);
xx3 = t:0.15:1.15*max(truncate);
fxx3 = ksdensity(truncate, xx3);
plot(xx3,fxx3,'-k','Linewidth',2);
l4 = line([t t],[0 0.0265], 'Color', 'k','Linewidth',2);
l1.Annotation.LegendInformation.IconDisplayStyle = 'off';
l2.Annotation.LegendInformation.IconDisplayStyle = 'off';
l3.Annotation.LegendInformation.IconDisplayStyle = 'off';
l4.Annotation.LegendInformation.IconDisplayStyle = 'off';
legend('input, Mean = 16.3050 ', 'censored, Mean = 16.0218', 'truncated, Mean = 16.6894','','')


figure
subplot(3,1,1);
h1 = histogram(orig,'normalization','pdf');
hold on
xx1 = 0:0.15:1.15*max(orig);
fxx1 = ksdensity(orig, xx1);
plot(xx1,fxx1,'-r','Linewidth',2)
hold off
legend('histogram','gamma density fit: original')
grid on
title('Original data, Mean = 16.3050')

subplot(3,1,2);
h2 = histogram(censor, 'normalization','pdf');
hold on
xlim([0 40])
xx2 = t:0.15:1.15*max(censor);
fxx2 = ksdensity(censor, xx2);
plot(xx2,fxx2,'-g','Linewidth',2)
line([t t],[0 0.0265], 'Color', 'g','Linewidth',2)
line([0 0],[0 0.015], 'Color', 'g','Linewidth',2)
line([0 t],[0 0], 'Color', 'g','Linewidth',2)
hold off
legend('histogram','gamma density fit: censored')
grid on
title('Censored data, Mean = 16.0218')

subplot(3,1,3);
h3 = histogram(truncate, 'normalization','pdf');
hold on
xlim([0 40])
xx3 = t:0.15:1.15*max(truncate);
fxx3 = ksdensity(truncate, xx3);
plot(xx3,fxx3,'-k','Linewidth',2)
line([t t],[0 0.0265], 'Color', 'k','Linewidth',2)
hold off
legend('histogram','gamma density fit: truncated')
grid on
title('Truncated data, Mean = 16.6894')

%%
figure
ab = makedist('Gamma', a, b);
randomdata = random(ab, 10000, 1);

%---
parG = fitdist(randomdata, 'gamma');
a_random = parG.a;
b_random = parG.b;
mean1 = (a.*b);
trun = (a.*b)./2;
[hG,pG,statsG] = chi2gof(orig,'CDF',parG)
%---
truncatedata = randomdata(randomdata > trun);
parG1 = fitdist(truncatedata, 'gamma');
a1 = parG1.a;
b1 = parG1.b;
mean2 = (a1.*b1);
[hG1,pG1,statsG1] = chi2gof(orig,'CDF',parG1)
%---
censoreddata = randomdata;
censoreddata(censoreddata < trun) = 0;
parG2 = fitdist(censoreddata, 'gamma');
a3 = parG2.a;
b3 = parG2.b;
mean3 = (a3.*b3);
[hG2,pG2,statsG2] = chi2gof(orig,'CDF',parG2)

%-------original 
subplot(3,1,1)
h2 = histogram(randomdata,'normalization', 'pdf');
hold on;
grid on
x1 = 0 : 0.15 : 1*max(randomdata);
fx2 = ksdensity(randomdata, x1)
plot(x1, fx2,'color', 'red', 'LineWidth', 3)
xlabel('values')
ylabel('pdf')
title(['random [10000 samples: G(', num2str(a_random), ', ' num2str(b_random), ')]'])
legend('histogram','theory');
hold on;

%-------censored
subplot(3,1,2)
h1 = histogram(censoreddata,'normalization', 'pdf');
hold on;
grid on
x = trun : 0.15 : 1*max(censoreddata);
fx = ksdensity(censoreddata, x)
plot(x, fx,'color', 'red','LineWidth',3)
line([trun trun],[0 0.0185], 'Color', [1 0 0],'linewidth',3)
line([0 0],[0 0.04], 'Color', [1 0 0],'linewidth',3)
line([0 trun],[0 0], 'Color', [1 0 0],'linewidth',3)
xlabel('values')
ylabel('pdf')
title(['censored data, Mean = ', num2str(mean3)])
legend('histogram','theory');
hold on;

%-------truncated
subplot(3,1,3)
h3 = histogram(truncatedata,'normalization', 'pdf');
hold on;
grid on
x2 = trun : 0.15 : 1*max(truncatedata);
fx3 = ksdensity(truncatedata, x2)
plot(x2, fx3,'color', 'red','LineWidth',3)
line([trun trun],[0 0.0185], 'Color', [1 0 0],'linewidth',3)
xlabel('values')
ylabel('pdf')
title(['truncated data, Mean = ', num2str(mean2)])
legend('histogram','theory');
hold on;