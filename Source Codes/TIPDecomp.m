function G=TIPDecomp(G)
n=size(G.Nodes,1);
ctr=n;
dist=zeros(n,1);
for i=1:n
    dist(i)=degree(G,G.Nodes.Name(i))-G.Nodes.Thresholds(i);
    disp(i);
end
G.Nodes.dist=dist;
flag=true;

while flag==true
    vi=min(G.Nodes.dist);
    currV=find(G.Nodes.dist==vi);
    ctr=ctr-1;
    if G.Nodes.dist(currV(1))==inf
        return
    else
        neighborsV=neighbors(G,G.Nodes.Name(currV(1)));
        m=size(neighborsV,1);
        for i=1:m
            currN=findnode(G,neighborsV(i));
            if G.Nodes.dist(currN)>0
                G.Nodes.dist(currN)=G.Nodes.dist(currN)-1;
            elseif G.Nodes.dist(currN)<=0
                G.Nodes.dist(currN)=inf;
            end
        end
    end
    G=rmnode(G,G.Nodes.Name(currV(1)));
    disp(size(G.Nodes));
end
