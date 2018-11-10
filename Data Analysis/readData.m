function readData(filename,i)

data=csvread(strcat(filename,".csv"),0,0);
titlePlot=strsplit(filename,'/');
threshold=data(:,1);
result=data(:,2);
time=data(:,3);
if length(result)>10
    for a=1:10
        thresholdTemp(a)=a;
        averageResult(a)=mean([result(a+10*0) result(a+10*1) result(a+10*2) result(a+10*3) result(a+10*4)]);
    end
    threshold=thresholdTemp';
    result=averageResult';
end

if i==1
    plot(threshold,result,'-x','Color','k');
    legend('TSS','Location','northwest');
elseif i==2
    plot(threshold,result,'-s','Color','r');
    newLeg={'TSS','Greedy'};
    legend(newLeg,'Location','northwest');
elseif i==3
    plot(threshold,result,'-*','Color','g');
    newLeg={'TSS','Greedy','TIP-Decomp'};
    legend(newLeg,'Location','northwest');
elseif i==4
    plot(threshold,result,'-o','Color','b');
    newLeg={'TSS','Greedy','TIP-Decomp','VirAds'};
    legend(newLeg,'Location','northwest');
end
ax = gca;
ax.YGrid = 'on';
ax.GridLineStyle = '-';
title(titlePlot(1));
hold all;