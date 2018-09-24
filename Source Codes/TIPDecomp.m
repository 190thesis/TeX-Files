function G=TIPDecomp(G)
n=size(G.Nodes,1);
dist=zeros(n,1);
for i=1:n
    dist(i)=degree(G,i)-G.Nodes.Thresholds(i);
end
G.Nodes.dist=dist;
flag=true;
while flag==true
    vi=min(G.Nodes.dist);
    currV=find(G.Nodes.dist==vi);
    currVid=find(G.Nodes.Label==string(currV(1)));
    fprintf('V_i: %g, Threshold of V_i: %g, Graph Size: %g\n',currVid,G.Nodes.Thresholds(currVid),size(find(G.Nodes.Status==0),1));
    if G.Nodes.dist(currVid)==inf
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
            end
        end
    end
    G.Nodes.dist(currVid)=inf;
    G.Nodes.Status(currVid)=1;
end