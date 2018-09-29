function S = TSS(G)
S=0;
[n m]=size(G.Nodes);
for i=1:n
    [a b]=size(G.Nodes);
    vArgMax=[];
    for k=1:a
        vArgMax(k)=G.Nodes.Thresholds(k)/(G.Nodes.Degree(k)*(G.Nodes.Degree(k)+1));
    end
    [maxV argmax]=max(vArgMax);
    
    if G.Nodes.Threshold(argmax)==0 && G.Nodes.Status(argmax)==0%Case 1
        N=neighbor(G,argmax);
        size(N);
        for j=1:N
            G.Nodes.Thresholds(N(j))=max(G.Nodes.Thresholds(N(j))-1,0);
        end
    else
        if G.Nodes.Degree(argmax)<G.Nodes.Threshold(argmax) && G.Nodes.Status(argmax)==0%Case 2
            S=S+1;
            N=neighbor(G,argmax);
            for j=1:N
            G.Nodes.Thresholds(N(j))=G.Nodes.Thresholds(N(j))-1; 
            end
        end
    end
    %Case 3
    G.Nodes.Status(argmax)=1;
    G.Nodes.Threshold(argmax)=0;
end