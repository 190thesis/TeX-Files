function [hamil path]= hamiltionian(G,startNode)

n=size(G.Nodes);
for i=1:n
    G.Nodes.Degree(i)=degree(G,i);
    G.Nodes.Visited(i)=0;
    G.Nodes.Label(i)=int2str(i);
end

path=[];

deg2=find(G.Nodes.Degree==2);

if(length(deg2)~=n)
    path="Not a hamiltonian circuit";
end

path=[path startNode];
neigh=neighbors(G,startNode);
G.Nodes.Visited(startNode)=1;
nextNode=neigh(1);
path=[path nextNode];
G.Nodes.Visited(nextNode)=1;
for j=1:n-2
    neigh=neighbors(G,nextNode);
    if(G.Nodes.Visited(neigh(1))==0)
        nextNode=neigh(i);
        G.Nodes.Visited(nextNode)=1;
    elseif(G.Nodes.Visited(neigh(2))==0)
        nextNode=neigh(i);
        G.Nodes.Visited(nextNode)=1;
    end
    path=[path nextNode];
end
neigh=neighbors(G,path(length(path)));
if neigh(1)==startNode
    hamil="Hamiltonian Circuit";
    path=[path startNode];
    return;
elseif neigh(2)==startNode
    hamil="Hamiltonian Circuit";
    path=[path startNode];
    return;
else
    hamil="Not a Hamiltonian Circuit";
    path=[];
    return;
end