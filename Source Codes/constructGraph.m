function G = constructGraph(filename,threshold)

myValues=csvread(filename,0,0);  %Reading the edges file
myValues = unique(sort(myValues,2),'rows');
G=graph(myValues(:,1),myValues(:,2));

[n,~]=size(G.Nodes);
nodeNames=[];
status=[];
degrees=[];
start=tic;
for i=1:n
    status(i)=0;
    nodeNames(i)=i;
    degrees(i)=degree(G,i);
    if(degrees(i)<threshold)
        thresholds(i)=degrees(i);
    else
        thresholds(i)=threshold;
    end
end
toc(start)
G.Nodes.Status=status';
G.Nodes.Degree=degrees';
nodeNames=string(nodeNames);
G.Nodes.Label=nodeNames';
G.Nodes.Thresholds=thresholds';


