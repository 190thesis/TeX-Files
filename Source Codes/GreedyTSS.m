function [S Time] = GreedyTSS(G)
S=[];
start=tic;
[n m]=size(G.Nodes);
for i=1:n
    [currV v]=min(G.Nodes.Thresholds);
    if G.Nodes.Thresholds(v)>0 && G.Nodes.Status(v)==0
        [currV v]=max(G.Nodes.Degree);
        S=[S G.Nodes.Label(v)];
    end
    
    neighborsV=neighbors(G,v);
    m=size(neighborsV,1);
    disp(m);
    start1=tic;
    for j=1:m
        currN=neighborsV(j);
        if G.Nodes.Status(currN)==0
            G.Nodes.Thresholds(currN)=max(G.Nodes.Thresholds(currN)-1,0);
            G.Nodes.Degree(currN)=G.Nodes.Degree(currN)-1;
        end
    end
    toc(start1)
    fprintf("S: %g, i %g, Neighbors: %g\n",length(S),i,m);
    G.Nodes.Status(v)=1;
    G.Nodes.Degree(v)=-inf;
    G.Nodes.Thresholds(v)=inf;
end
Time=toc(start);
