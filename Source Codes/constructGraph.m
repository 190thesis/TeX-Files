function G = constructGraph(filename,threshold)

myValues=csvread(filename,0,0);  %Reading the edges file
myValues = unique(sort(myValues,2),'rows')
G=graph(myValues(:,1),myValues(:,2)); %Constructing the graph

n=size(G.Nodes);
nodeNames=[];
status=[];
thresholds=zeros(n);
for i=1:n
    status(i)=0;
    nodeNames(i)=i;
    if(degree(G,i)<threshold)
        thresholds(i)=degree(G,i);
    else
        thresholds(i)=threshold;
    end
end
G.Nodes.Status=status';
nodeNames=string(nodeNames);
G.Nodes.Label=nodeNames';
G.Nodes.Thresholds=thresholds';