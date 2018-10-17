function active = Propagate(P,G)
Q=[];
Q=[Q ;P'];
[n,~]=size(G.Nodes);
for i=1:size(P)
    G.Nodes.Threshold(P(1))=0;
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
    
end
active = true;
    for i=1:n
        if G.Nodes.Status(i)==0
            active=false;
        end
    end