function [S, Time]=TIPDecomp(G)
start=tic;
n=size(G.Nodes,1);
dist=zeros(n,1);
S=[];
for i=1:n
    dist(i)=degree(G,i)-G.Nodes.Thresholds(i);
end
G.Nodes.dist=dist;
flag=true;
while flag==true
    vi=min(G.Nodes.dist);
    currV=find(G.Nodes.dist==vi);
    currVid=find(G.Nodes.Label==string(currV(1)));
    if G.Nodes.dist(currVid)==inf
        S=str2double(S);
        Time=toc(start);
        return
    else
        neighborsV=neighbors(G,currVid);
        m=size(neighborsV,1);
        for i=1:m
            currN=find(G.Nodes.Label==string(neighborsV(i)));
            if G.Nodes.dist(currN)>0 && G.Nodes.Status(currN)==0
                G.Nodes.dist(currN)=G.Nodes.dist(currN)-1;
            elseif G.Nodes.dist(currN)<=0 && G.Nodes.Status(currN)==0
                G.Nodes.dist(currN)=inf;
                S=[S G.Nodes.Label(currN)];
            end
        end
    end
    G.Nodes.dist(currVid)=inf;
    G.Nodes.Status(currVid)=1;
end

