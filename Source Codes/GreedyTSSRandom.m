function [S Time] = GreedyTSSRandom(G)
S=[];
start=tic;
[n m]=size(G.Nodes);
for i=1:n
    currrandomIndex=min(G.Nodes.Thresholds);
    argmin=find(G.Nodes.Thresholds==currrandomIndex);
    randomIndex=randperm(length(argmin));
    if G.Nodes.Thresholds(argmin(randomIndex(1)))>0 && G.Nodes.Status(argmin(randomIndex(1)))==0
        currrandomIndex=min(G.Nodes.Degree);
        argmax=find(G.Nodes.Degree==currrandomIndex);
        randomIndex=randperm(length(argmax));
        S=[S G.Nodes.Label(argmin(randomIndex(1)))];
    end
    
    neighborsrandomIndex=neighbors(G,argmin(randomIndex(1)));
    m=size(neighborsrandomIndex,1);
    disp(m);
    start1=tic;
    for j=1:m
        currN=neighborsrandomIndex(j);
        if G.Nodes.Status(currN)==0
            G.Nodes.Thresholds(currN)=max(G.Nodes.Thresholds(currN)-1,0);
            G.Nodes.Degree(currN)=G.Nodes.Degree(currN)-1;
        end
    end
    toc(start1)
    fprintf("S: %g, i %g, Neighbors: %g\n",length(S),i,m);
    G.Nodes.Status(argmin(randomIndex(1)))=1;
    G.Nodes.Degree(argmin(randomIndex(1)))=-inf;
    G.Nodes.Thresholds(argmin(randomIndex(1)))=inf;
end
Time=toc(start);
