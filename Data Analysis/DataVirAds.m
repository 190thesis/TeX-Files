function DataVirAds(dataset)

A=csvread(strcat(dataset,"/VirAds.csv"));
result=zeros(10,3);

for i=1:10
    result(i,1)=i;
    result(i,2)=mean(A((2+(10*(i-1))):(10+(10*(i-1))),1));
    result(i,3)=mean(A((2+(10*(i-1))):(10+(10*(i-1))),2));
end

csvwrite(strcat(dataset,"/VirAds.csv"),result);