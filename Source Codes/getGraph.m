function G = getGraph(filename,threshold)

myValues=csvread(filename,0,0);  %Reading the edges file
myValues = unique(sort(myValues,2),'rows');
[c,d]=size(myValues);
a={};
b={};
start=tic;
parfor i=1:c
    disp(i);
    a(i)={num2str(myValues(i,1))};
    b(i)={num2str(myValues(i,2))};
end
timeout=toc(start)
G=graph(a,b); %Constructing the graph
[n l]=size(G.Nodes);
thresholds=zeros(1,n);
start=tic;
parfor i=1:n
    disp(i);
    currNode=degree(G,G.Nodes.Name(i));
    if(currNode<threshold)
        thresholds(i)=currNode;
    else
        thresholds(i)=threshold;
    end
end
out=toc(start)
G.Nodes.Thresholds=thresholds';
