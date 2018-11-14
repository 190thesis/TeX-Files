function [S, Time] = GreedyTSSRandom(G)
S=[];
start=tic;
[n , ~]=size(G.Nodes);
for i=1:n
    currV=max(G.Nodes.Thresholds);
    maxV=find(G.Nodes.Thresholds==currV);
    lengthMax=length(maxV);
    randIndex=randperm(lengthMax);
    if G.Nodes.Thresholds(maxV(randIndex(1)))>0 && G.Nodes.Status(maxV(randIndex(1)))==0
        currV=max(G.Nodes.Degree);
        maxV=find(G.Nodes.Degree==currV);
        lengthMax=length(maxV);
        randIndex=randperm(lengthMax);
        S=[S G.Nodes.Label(maxV(randIndex(1)))];
    end
    
    neighborsV=neighbors(G,maxV(randIndex(1)));
    m=size(neighborsV,1);
    for j=1:m
        currN=neighborsV(j);
        if G.Nodes.Status(currN)==0
            G.Nodes.Thresholds(currN)=max(G.Nodes.Thresholds(currN)-1,0);
            G.Nodes.Degree(currN)=G.Nodes.Degree(currN)-1;
        end
    end
    fprintf("S: %g, i %g, Neighbors: %g\n",length(S),i,m);
    G.Nodes.Status(maxV(randIndex(1)))=1;
    G.Nodes.Degree(maxV(randIndex(1)))=-inf;
    G.Nodes.Thresholds(maxV(randIndex(1)))=-inf;
end
Time=toc(start);
S=str2double(S);