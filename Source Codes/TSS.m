function [S, Time] = TSS(G)
[n m]=size(G.Nodes);
maxes=[];
for i=1:n
    maxes(i)=G.Nodes.Thresholds(i)/(G.Nodes.Degree(i)*(G.Nodes.Degree(i)+1));
end
G.Nodes.TSSMax=maxes';
S=[];
[n , ~]=size(G.Nodes);
start=tic;
for i=1:n
    [a, b]=size(G.Nodes);
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
    fprintf("S: %g, i %g, Neighbors: %g, TSSMax: %g\n",length(S),i,sizeN,G.Nodes.TSSMax(argmax(1)));
    for j=1:sizeN
        G.Nodes.Degree(N(j))=G.Nodes.Degree(N(j))-1;
        if G.Nodes.Degree(N(j))~=0 && G.Nodes.TSSMax(N(j))~=0
            G.Nodes.TSSMax(N(j))=G.Nodes.Thresholds(N(j))/(G.Nodes.Degree(N(j))*((G.Nodes.Degree(N(j)))+1));
        end
    end
    G.Nodes.Thresholds(argmax(1))=0;
    G.Nodes.TSSMax(argmax(1))=0;
end
Time=toc(start);
S=str2double(S);