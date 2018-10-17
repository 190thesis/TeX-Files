function [S, Time] = GreedyTSS(G)
S=[];
start=tic;
[gsize,~]=size(G.Nodes);
ctr=0;
while prod(G.Nodes.Status)==0
    v=find(G.Nodes.Thresholds==max(G.Nodes.Thresholds));
    v=v(G.Nodes.Status(v)==0);
    currv=v(1);
    if G.Nodes.Thresholds(currv)>0
        v=find(G.Nodes.Degree==max(G.Nodes.Degree));
        v=v(G.Nodes.Status(v)==0);
        currv=v(1);
        S=[S currv];
    end
    
    neighborsV=neighbors(G,currv);
    neighborsV=neighborsV(G.Nodes.Status(neighborsV)==0);
    for u=1:length(neighborsV)
       G.Nodes.Thresholds(neighborsV(u))=max( G.Nodes.Thresholds(neighborsV(u))-1,0);
       G.Nodes.Degree(neighborsV(u))=G.Nodes.Degree(neighborsV(u))-1;
    end
    G.Nodes.Status(currv)=1;
    G.Nodes.Thresholds(currv)=-inf;
    G.Nodes.Degree(currv)=-inf;
    ctr=ctr+1;
    fprintf("Inactive:%d\n",gsize-ctr);
end
Time=toc(start);