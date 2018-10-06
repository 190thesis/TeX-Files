function S = TSS(G)
S=[];
[n m]=size(G.Nodes);
start=tic;
for i=1:n
    [a b]=size(G.Nodes);
    vArgMax=[];
    [maxV argmax]=max(G.Nodes.TSSMax);
    
    if G.Nodes.Thresholds(argmax)==0 && G.Nodes.Status(argmax)==0%Case 1
        N=neighbors(G,argmax);
        sizeN=size(N,1);
        for j=1:sizeN
            G.Nodes.Thresholds(N(j))=max(G.Nodes.Thresholds(N(j))-1,0);
        end
    else
        if G.Nodes.Degree(argmax)<G.Nodes.Thresholds(argmax) && G.Nodes.Status(argmax)==0%Case 2
            S=[S G.Nodes.Label(argmax)];
            N=neighbors(G,argmax);
            sizeN=size(N,1);
            for j=1:sizeN
                G.Nodes.Thresholds(N(j))=G.Nodes.Thresholds(N(j))-1; 
            end
        end
    end
    %Case 3
    G.Nodes.Status(argmax)=1;
    
    N=neighbors(G,argmax);
    sizeN=size(N,1);
    fprintf("S: %g, i %g, Neighbors: %g, TSSMax: %g\n",S,i,sizeN,G.Nodes.TSSMax(argmax));
    start1=tic;
    for j=1:sizeN
        G.Nodes.Degree(N(j))=G.Nodes.Degree(N(j))-1;
        if G.Nodes.Degree(N(j))~=0 && G.Nodes.TSSMax(N(j))~=0
            G.Nodes.TSSMax(N(j))=G.Nodes.Thresholds(N(j))/(G.Nodes.Degree(N(j))*((G.Nodes.Degree(N(j)))+1));
        end
    end
    toc(start1)
    disp(argmax);
    G.Nodes.Thresholds(argmax)=0;
    G.Nodes.TSSMax(argmax)=0;
end
toc(start)