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
ctr=1;
while flag==true
    disp(ctr);
    ctr=ctr+1;
    vi=min(G.Nodes.dist);
    currV=find(G.Nodes.dist==vi,1);
    currVid=currV;
    if G.Nodes.dist(currVid)==inf
       flag=false;
    else
        neighborsV=neighbors(G,currVid);
        m=size(neighborsV,1);
        for i=1:m
            currN=neighborsV;
            if G.Nodes.dist(currN(i))>0 && G.Nodes.Status(currN(i))==0
                G.Nodes.dist(currN(i))=G.Nodes.dist(currN(i))-1;
            else
                G.Nodes.dist(currN(i))=inf;
            end
        end
    end
    G.Nodes.dist(currVid)=inf;
    G.Nodes.Status(currVid)=1;
end
S=find(G.Nodes.Status==0);
Time=toc(start);
