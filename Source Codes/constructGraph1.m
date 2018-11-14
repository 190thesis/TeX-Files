function G = constructGraph(filename,threshold)

myValues=csvread(filename,0,0);  %Reading the edges file
myValues = unique(sort(myValues,2),'rows');
G=graph(myValues(:,1),myValues(:,2));

n=size(G.Nodes);
nodeNames=[];
status=[];
thresholds=zeros(n);
degrees=[];
for i=1:n
    status(i)=0;
    nodeNames(i)=i;
    degrees(i)=degree(G,i);
    thresholds(i)=threshold(i);
end
G.Nodes.Status=status';
G.Nodes.Degree=degrees';
nodeNames=string(nodeNames);
G.Nodes.Label=nodeNames';
G.Nodes.Thresholds=thresholds';

[n m]=size(G.Nodes);
maxes=[];
for i=1:n
    maxes(i)=G.Nodes.Thresholds(i)/(G.Nodes.Degree(i)*(G.Nodes.Degree(i)+1));
end
G.Nodes.TSSMax=maxes';
