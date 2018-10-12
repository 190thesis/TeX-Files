function [S Time] = TSS(G)
S=[];
[n m]=size(G.Nodes);
start=tic;
for i=1:n
    [a b]=size(G.Nodes);
    maxV=max(G.Nodes.TSSMax);
    
    argmax=find(G.Nodes.TSSMax==maxV);
    
    if G.Nodes.Thresholds(argmax(1))==0 && G.Nodes.Status(argmax(1))==0%Case 1
        N=neighbors(G,argmax(1));
        sizeN=size(N,1);
        for j=1:sizeN
            G.Nodes.Thresholds(N(j))=max(G.Nodes.Thresholds(N(j))-1,0);
        end
    else
        if G.Nodes.Degree(argmax(1))<G.Nodes.Thresholds(argmax(1)) && G.Nodes.Status(argmax(1))==0%Case 2
            S=[S G.Nodes.Label(argmax(1))];
            N=neighbors(G,argmax(1));
            sizeN=size(N,1);
            for j=1:sizeN
                G.Nodes.Thresholds(N(j))=G.Nodes.Thresholds(N(j))-1; 
            end
        end
    end
    %Case 3
    G.Nodes.Status(argmax(1))=1;
    
    N=neighbors(G,argmax(1));
    sizeN=size(N,1);
    fprintf("S: %g, i %g, Neighbors: %g, TSSMax: %g\n",S,i,sizeN,G.Nodes.TSSMax(argmax(1)));
    start1=tic;
    for j=1:sizeN
        G.Nodes.Degree(N(j))=G.Nodes.Degree(N(j))-1;
        if G.Nodes.Degree(N(j))~=0 && G.Nodes.TSSMax(N(j))~=0
            G.Nodes.TSSMax(N(j))=G.Nodes.Thresholds(N(j))/(G.Nodes.Degree(N(j))*((G.Nodes.Degree(N(j)))+1));
        end
    end
    toc(start1)
    disp(argmax(1));
    G.Nodes.Thresholds(argmax(1))=0;
    G.Nodes.TSSMax(argmax(1))=0;
end
Time=toc(start);