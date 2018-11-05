function [S, Time] = parTSS(G)
[n m]=size(G.Nodes);
maxes=[];
thresholds=G.Nodes.Thresholds(:);
degrees=G.Nodes.Degree(:);
parfor i=1:n
    maxes(i)=thresholds(i)/(degrees(i)*(degrees(i)+1));
end
G.Nodes.TSSMax=maxes';
S=[];
[n , ~]=size(G.Nodes);
start=tic;
ctr=0;
maxV=max(G.Nodes.TSSMax);
argmax=find(G.Nodes.TSSMax==maxV);
argctr=1;
for i=1:n
    ctr=ctr+1;
    disp(ctr)
    [a, b]=size(G.Nodes);
    
    if(argctr==length(argmax))
        maxV=max(G.Nodes.TSSMax);
        argmax=find(G.Nodes.TSSMax==maxV);
        argctr=1;
    else
        argctr=argctr+1;
    end
    
    if G.Nodes.Thresholds(argmax(argctr))==0 && G.Nodes.Status(argmax(argctr))==0%Case 1
        N=neighbors(G,argmax(argctr));
        sizeN=size(N,1);
        thresholds=G.Nodes.Thresholds(N(:));
        parfor j=1:sizeN
           thresholds(j)=max(thresholds(j)-1,0);
        end
        G.Nodes.Thresholds(N(:))=thresholds(:);
    else
        if G.Nodes.Degree(argmax(argctr))<G.Nodes.Thresholds(argmax(argctr)) && G.Nodes.Status(argmax(argctr))==0%Case 2
            S=[S G.Nodes.Label(argmax(argctr))];
            N=neighbors(G,argmax(argctr));
            sizeN=size(N,1);
            thresholds=G.Nodes.Thresholds(N(:));
            parfor j=1:sizeN
                thresholds(j)=max(thresholds(j)-1,0);
            end
            G.Nodes.Thresholds(N(:))=thresholds(:);
        end
    end
    %Case 3
    G.Nodes.Status(argmax(argctr))=1;
    N=neighbors(G,argmax(argctr));
    sizeN=size(N,1);
    degrees= G.Nodes.Degree(N(:));
    thresholds=G.Nodes.Thresholds(N(:));
    maxes=G.Nodes.TSSMax(N(:));
    parfor j=1:sizeN
        degrees(j)=degrees(j)-1;
        if degrees(j)~=0 && maxes(j)~=0
            maxes(j)=thresholds(j)/(degrees(j)*(degrees(j)+1));
        end
    end
    G.Nodes.Degree(N(:))=degrees(:);
    G.Nodes.TSSMax(N(:))=maxes(:);
    G.Nodes.Thresholds(argmax(argctr))=0;
    G.Nodes.TSSMax(argmax(argctr))=0;
end
Time=toc(start);
S=str2double(S);