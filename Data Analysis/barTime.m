function barTime(dataset,titleData)

A=csvread(strcat(dataset,'/TSS.csv'),0,0);
time=sum(A(:,3));
B=csvread(strcat(dataset,'/TSSRandom.csv'),0,0);
time=[time  sum(A(:,3))/(length(A)/10)];
A=csvread(strcat(dataset,'/GreedyTSS.csv'),0,0);
B=csvread(strcat(dataset,'/GreedyTSSRandom.csv'),0,0);
time=[time  sum(A(:,3))/(length(A)/10) sum(B(:,3))/(length(B)/10)];
A=csvread(strcat(dataset,'/TIPDecomp.csv'),0,0);
B=csvread(strcat(dataset,'/TIPDecompRandom.csv'),0,0);
time=[time  sum(A(:,3))/(length(A)/10) sum(B(:,3))/(length(B)/10)];
%A=csvread(strcat(dataset,'/VirAds.csv'),0,0);
A=zeros(1,length(A));
B=csvread(strcat(dataset,'/VirAdsRandom.csv'),0,0);
time=[time  sum(A(:,3))/(length(A)/10) sum(B(:,3))/(length(B)/10)];
c = categorical({'TSS','TSSRandom','Greedy','GreedyRandom','TIPDecomp','TIPDecompRandom','VirAds','VirAdsRandom'});

bar(c,time);
title(titleData);
ylabel('Time (Seconds)');