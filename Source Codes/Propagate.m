function [active,Time] = Propagate(P,G)
start=tic;
Q=[];
Q=[Q ;P'];
active=false;
[n,~]=size(G.Nodes);
for i=1:size(P)
    G.Nodes.Threshold(P(i))=0;
end
while ~isempty(Q)
   T=Q(1);
   Q=Q(Q~=T);
   tid=T;
   G.Nodes.Status(tid)=1;
    neighborsT=neighbors(G,tid);
    [ntsize,~]=size(neighborsT);
    for i=1:ntsize
       G.Nodes.Thresholds(neighborsT(i))=max(0, G.Nodes.Thresholds(neighborsT(i))-1);
       if G.Nodes.Thresholds(neighborsT(i))==0 && G.Nodes.Status(neighborsT(i))==0
           Q=[Q;neighborsT(i)];
       end
    end
    fprintf("Propagating... Inactive:%.2f \n",length(find(G.Nodes.Status==0))/n*100);
end
if isempty(find(G.Nodes.Status==0, 1))
   active=true; 
end

Time=toc(start);