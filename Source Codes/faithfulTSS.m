function [S, Time] = faithfulTSS(G)
[n m]=size(G.Nodes);
maxes=[];
for i=1:n
    maxes(i)=G.Nodes.Thresholds(i)/(G.Nodes.Degree(i)*(G.Nodes.Degree(i)+1));
end
G.Nodes.TSSMax=maxes';
S=[];
[n , ~]=size(G.Nodes);
start=tic;
ctr=0;
currV=0;
while prod(G.Nodes.Status)==0
    ctr=ctr+1;
    [a, b]=size(G.Nodes);
    if isempty(find(G.Nodes.Thresholds==0 & G.Nodes.Status==0,1))==0%Case 1
        caseof=1;
        vCandidates=find(G.Nodes.Thresholds==0 & G.Nodes.Status==0,1);
        currV=vCandidates;
        N=successors(G, vCandidates);
        sizeN=length(N);
        for j=1:sizeN
            G.Nodes.Thresholds(N(j))=max(G.Nodes.Thresholds(N(j))-1,0);
        end
    else
        
        case2val=find(G.Nodes.Degree<G.Nodes.Thresholds & G.Nodes.Status ==0,1);
        if isempty(case2val)==0%Case 2
            caseof=2;
            currV=case2val;
            S=[S G.Nodes.Label(currV)];
            N=successors(G,currV);
            sizeN=length(N);
            for j=1:sizeN
                G.Nodes.Thresholds(N(j))=G.Nodes.Thresholds(N(j))-1; 
            end
        else 
            caseof=3;
            maxV=max(G.Nodes.TSSMax);
            argmax=find(G.Nodes.TSSMax==maxV,1,'last');
            currV=argmax;
        end
    end
    %Case 3
    N=successors(G,currV);
    sizeN=length(N);
    for j=1:sizeN
        G.Nodes.Degree(N(j))=G.Nodes.Degree(N(j))-1;
        if G.Nodes.Degree(N(j))~=0
            G.Nodes.TSSMax(N(j))=G.Nodes.Thresholds(N(j))/(G.Nodes.Degree(N(j))*((G.Nodes.Degree(N(j)))+1));
        end
    end
    G.Nodes.Status(currV)=1;
    G.Nodes.Thresholds(currV)=-inf;
    G.Nodes.TSSMax(currV)=-inf;
    fprintf("currV: %g, case: %g, ctr: %g\n",currV,caseof,ctr);
end
Time=toc(start);
S=str2double(S);