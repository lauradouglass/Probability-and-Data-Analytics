clear;
close all; clc

%% maximum
for h = 1:2000
    x= random('weibull',2.1,3,60,2);
    n = length(x);
    y=random('rician',2.6,5,50,2);
    n1 = length(y);
    
    for i = 1:n
        b(i)=max(x(i,:));
        b=b.';
    end
    mta(h)=mean(b);
    vta(h)=var(b);
    for a = 1:n1
        c(a)=max(y(a,:));
        c=c.';
    end
    mtp(h)=mean(c);
    vtp(h)=var(c);
    
    pindex(h) = abs(mta(h)-mtp(h))/sqrt(vta(h)+vtp(h));
    pindex=pindex.';
    
end 
Mpindex_Max=mean(pindex)
SDpindex_Max=std(pindex)

%% arithmetic mean 
for h1 = 1:2000
    x1= random('weibull',2.1,3,60,2);
    nn = length(x1);
    y1=random('rician',2.6,5,50,2);
    nn1 = length(y1);
    
    for ii = 1:nn
        b1(ii)=sum(x1(ii,:))/2;
        b1=b1.';
    end
    mta1(h1)=mean(b1);
    vta1(h1)=var(b1);
    for aa = 1:nn1
        c1(aa)=sum(y1(aa,:))/2;
        c1=c1.';
    end
    mtp1(h1)=mean(c1);
    vtp1(h1)=var(c1);
    
    pindex1(h1) = abs(mta1(h1)-mtp1(h1))/sqrt(vta1(h1)+vtp1(h1));
    pindex1=pindex1.';
    
end 
Mpindex_Arithmean=mean(pindex1)
SDpindex_Arithmean=std(pindex1)

%% geometric mean 
for h2 = 1:2000
    x2= random('weibull',2.1,3,60,2);
    n2 = length(x2);
    y2=random('rician',2.6,5,50,2);
    nn2 = length(y2);
    
    for iii = 1:n2
        b2(iii)=sqrt(x2(iii,1)*x2(iii,2));
        b2=b2.';
    end
    mta2(h2)=mean(b2);
    vta2(h2)=var(b2);
    for aaa = 1:nn2
        c2(aaa)=sqrt(y2(aaa,1)*y2(aaa,2));
        c2=c2.';
    end
    mtp2(h2)=mean(c2);
    vtp2(h2)=var(c2);
    
    pindex2(h2) = abs(mta2(h2)-mtp2(h2))/sqrt(vta2(h2)+vtp2(h2));
    pindex2=pindex2.';
    
end 
Mpindex_Geomean=mean(pindex2)
SDpindex_Geomean=std(pindex2)
%% comparison 
[status,sheets] = xlsfinfo('Douglas-HW');
A=readmatrix('Douglas-HW.xls','Sheet',1); 
x=A(1:60);
y=A(61:110); 
mta3=mean(x);
mtp3=mean(y);
vta3=var(x);
vtp3=var(y);
Performance_index_input = abs(mta3-mtp3)/sqrt(vta3+vtp3)
  