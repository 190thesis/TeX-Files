function [S, Time] = GreedyTSS(G)
S=[];
start=tic;
[gsize,~]=size(G.Nodes);
ctr=0;
while sum(G.Nodes.Thresholds)~=0
    v=find(G.Nodes.Status==0);
    v=find(G.Nodes.Thresholds==min(G.Nodes.Thresholds(v)));
    v=v(G.Nodes.Status(v)==0);
    currv=v(1);
    if G.Nodes.Thresholds(currv)>0
        v=find(G.Nodes.Status==0);
        v=find(G.Nodes.Degree==max(G.Nodes.Degree(v)));
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
    G.Nodes.Thresholds(currv)=0;
    G.Nodes.Degree(currv)=-inf;
    ctr=length(find(G.Nodes.Thresholds==0));
    fprintf("GreedyTSS Inactive:%d, S=%d, currv=%d\n",gsize-ctr,length(S),currv);
end
Time=toc(start);