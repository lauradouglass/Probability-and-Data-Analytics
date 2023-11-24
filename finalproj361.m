clear all; clc;
file = 'Lukyanovsky-Proj.xls';
nsmooth=8;
IR_reciever_data = xlsread(file);
no_signal_present = IR_reciever_data(1:70,:);
signal_present = IR_reciever_data(71:130,:);
%% 
nb = 1
maxarray = zeros(1, length(nb));
aritharray = zeros(1, length(nb));
geoarray = zeros(1, length(nb)); 
for i = 1:nb
    szegam = [70 2];
    gam_targ_absent = random('rayleigh', 1.3767, szegam);

    szeric = [60 2];
    ric_targ_pres = random('weibull', 4.7120, 2.4757, szeric);

    gam_max_targ_abs = max(gam_targ_absent, [], 2);
    ric_max_targ_pres = max(ric_targ_pres, [], 2);
    gam_arith = mean(gam_targ_absent, 2);
    ric_arith = mean(ric_targ_pres, 2);
    gam_geo = geomean(gam_targ_absent, 2);
    ric_geo = geomean(ric_targ_pres, 2);

    meanmax_gam = mean(gam_max_targ_abs);
    meanmax_ric = mean(ric_max_targ_pres);
    varmax_gam = var(gam_max_targ_abs);
    varmax_ric = var(ric_max_targ_pres);
    meangamarith = mean(gam_arith);
    meanricarith = mean(ric_arith);
    vargamarith = var(gam_arith);
    varricarith = var(ric_arith);
    meangamgeo = mean(gam_geo);
    meanricgeo = mean(ric_geo);
    vargamgeo = var(gam_geo);
    varricgeo = var(ric_geo);

    maxperfindnum = abs(meanmax_gam - meanmax_ric);
    maxperfinddenum = sqrt(varmax_gam + varmax_ric);
    maxperfindex = maxperfindnum / maxperfinddenum;
    
    arithperfindnum = abs(meangamarith - meanricarith);
    arithperfinddenum = sqrt(vargamarith + varricarith);
    arithperfindex = arithperfindnum / arithperfinddenum; 
    
    geoperfindnum = abs(meangamgeo - meanricgeo);
    geoperfinddenum = sqrt(vargamgeo + varricgeo);
    geoperfindex = geoperfindnum / geoperfinddenum; 

    maxarray(i) = maxperfindex;
    aritharray(i) = arithperfindex;
    geoarray(i) = geoperfindex;
end

maxmean = mean(maxarray);
maxstd = std(maxarray);

arithmean = mean(aritharray);
arithstd = std(aritharray);

geomean = mean(geoarray);
geostd = std(geoarray);

%% Data performance index
targabsmean = mean(gam_arith);
targpresmean = mean(ric_arith);
targabsvar = var(gam_arith);
targpresvar = var(ric_arith);

perfindexnum = abs(targabsmean - targpresmean);
perfindexdenum = sqrt(targabsvar + targpresvar);
perfindex_a_mean = perfindexnum / perfindexdenum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
targabsmean = mean(gam_geo);
targpresmean = mean(ric_geo);
targabsvar = var(gam_geo);
targpresvar = var(ric_geo);

perfindexnum = abs(targabsmean - targpresmean);
perfindexdenum = sqrt(targabsvar + targpresvar);
perfindex_g_mean = perfindexnum / perfindexdenum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
targabsmean = mean(gam_max_targ_abs);
targpresmean = mean(ric_max_targ_pres);
targabsvar = var(gam_max_targ_abs);
targpresvar = var(ric_max_targ_pres);

perfindexnum = abs(targabsmean - targpresmean);
perfindexdenum = sqrt(targabsvar + targpresvar);
perfindex_max = perfindexnum / perfindexdenum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
targabsmean = mean(no_signal_present);
targpresmean = mean(signal_present);
targabsvar = var(no_signal_present);
targpresvar = var(signal_present);

perfindexnum = abs(targabsmean - targpresmean);
perfindexdenum = sqrt(targabsvar + targpresvar);
perfindex_orig = perfindexnum / perfindexdenum
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
xa = 0:0.25:1.2*max(no_signal_present);
xp = 0:0.25:1.2*max(signal_present);
%Data given
%Weibull Calculations
parW_p = fitdist(signal_present,'Weibull');
Bull_a_p = parW_p.a;
Bull_b_p = parW_p.b;
f_weibull_p = pdf('weibull',xp,Bull_a_p,Bull_b_p);

%Rayleigh Calculations
parR_a = fitdist(no_signal_present,'Rayleigh');
Rayleigh_b_a = parR_a.b;
f_Rayleigh_a = pdf('rayleigh',xa,Rayleigh_b_a);

figure
plot(xa, f_Rayleigh_a, 'r')
hold on
plot(xp, f_weibull_p, 'k')
title('Data Supplied')
legend('Target Absent', 'Target Present')
xlabel('data')
ylabel('Estimated pdf')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Arithmetic mean
%Weibull Calculations
parW_p = fitdist(ric_arith,'Weibull');
Bull_a_p = parW_p.a;
Bull_b_p = parW_p.b;
f_weibull_p = pdf('weibull',xp,Bull_a_p,Bull_b_p);

%Rayleigh Calculations
parR_a = fitdist(gam_arith,'Rayleigh');
Rayleigh_b_a = parR_a.b;
f_Rayleigh_a = pdf('rayleigh',xa,Rayleigh_b_a);

figure
plot(xa, f_Rayleigh_a, 'r')
hold on
plot(xp, f_weibull_p, 'k')
title('Arithmetic Mean')
legend('Target Absent', 'Target Present')
xlabel('data')
ylabel('Estimated pdf')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%geometric mean
%Weibull Calculations
parW_p = fitdist(ric_geo,'Weibull');
Bull_a_p = parW_p.a;
Bull_b_p = parW_p.b;
f_weibull_p = pdf('weibull',xp,Bull_a_p,Bull_b_p);

%Rayleigh Calculations
parR_a = fitdist(gam_geo,'Rayleigh');
Rayleigh_b_a = parR_a.b;
f_Rayleigh_a = pdf('rayleigh',xa,Rayleigh_b_a);

figure
plot(xa, f_Rayleigh_a, 'r')
hold on
plot(xp, f_weibull_p, 'k')
title('Geometric Mean')
legend('Target Absent', 'Target Present')
xlabel('data')
ylabel('Estimated pdf')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%maximum
%Weibull Calculations
parW_p = fitdist(ric_max_targ_pres,'Weibull');
Bull_a_p = parW_p.a;
Bull_b_p = parW_p.b;
f_weibull_p = pdf('weibull',xp,Bull_a_p,Bull_b_p);

%Rayleigh Calculations
parR_a = fitdist(gam_max_targ_abs,'Rayleigh');
Rayleigh_b_a = parR_a.b;
f_Rayleigh_a = pdf('rayleigh',xa,Rayleigh_b_a);

figure
plot(xa, f_Rayleigh_a, 'r')
hold on
plot(xp, f_weibull_p, 'k')
title('Maximum')
legend('Target Absent', 'Target Present')
xlabel('data')
ylabel('Estimated pdf')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Graphing AUC/ROC Comparison

%Input Data
N0 = length(no_signal_present);
N1 = length(signal_present);
dat = IR_reciever_data;
resp = [zeros(N0,1);ones(N1,1)];
[pf,pd,T,AUC,OPTOCPT] = perfcurve(resp,dat,1);
in_auc = AUC;
figure
plot(pf,pd, 'm', 'LineStyle', '- -')
hold on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Arithmetic
N0 = length(gam_arith);
N1 = length(ric_arith);
arith_dat = [gam_arith;ric_arith];
resp = [zeros(N0,1);ones(N1,1)];
[pf,pd,T,AUC,OPTOCPT] = perfcurve(resp,arith_dat,1);
arith_auc = AUC;
plot(pf,pd, 'r')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Geometric
N0 = length(gam_geo);
N1 = length(ric_geo);
geo_dat = [gam_geo;ric_geo];
resp = [zeros(N0,1);ones(N1,1)];
[pf,pd,T,AUC,OPTOCPT] = perfcurve(resp,geo_dat,1);
geo_auc = AUC;
plot(pf,pd, 'b')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Maximum
N0 = length(gam_max_targ_abs);
N1 = length(ric_max_targ_pres);
max_dat = [gam_max_targ_abs;ric_max_targ_pres];
resp = [zeros(N0,1);ones(N1,1)];
[pf,pd,T,AUC,OPTOCPT] = perfcurve(resp,max_dat,1);
max_auc = AUC;
plot(pf,pd, 'k')

x = [0,1];
y = [0,1];
plot(x,y, 'g', 'LineStyle', '- -')

title('ROC Comparison: Post Processing')
xlabel('1-Specificity')
ylabel('Sensitivity')
legend(['input data: A_z=', num2str(in_auc)], ['AM of two: A_z=', num2str(arith_auc)], ['GM of two: A_z=', num2str(geo_auc)], ['MAX of two: A_z=', num2str(max_auc)], 'Location', 'southeast')