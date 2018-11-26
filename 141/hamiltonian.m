% This is a matlab code for the detection of
% hamiltonian circuits/cycle in graphs with all
% vertices in degree 2. It accepts the matlab
% data structure graph and a start node.
% Nodes here are synonymous with Vertices.
% 
% To initialize a graph G, for example
%     >> G=graph;
% To add edges, for vertices 1 and 2,
%     >> G=G.addedge(1,2);

function [hamil,path]= hamiltonian(G,startNode)

n=size(G.Nodes,1);
% required properties of each node in the graph
for i=1:n
    G.Nodes.Degree(i)=degree(G,i);
    G.Nodes.Visited(i)=0;
    G.Nodes.Label(i)=i;
end
path=[];

%check if all nodes are in degree 2
deg2=find(G.Nodes.Degree==2);

if(length(deg2)~=n)
    hamil="Not a hamiltonian circuit";
    path=[];
    return;
end

%initialize HC using the entered start node
path=[path startNode];
neigh=neighbors(G,startNode);
G.Nodes.Visited(startNode)=1;
nextNode=neigh(1);
path=[path nextNode];
G.Nodes.Visited(nextNode)=1;

%HC's next nodes
for j=1:n-2
    neigh=neighbors(G,nextNode);
    if(G.Nodes.Visited(neigh(1))==0)
        nextNode=neigh(1);
        G.Nodes.Visited(nextNode)=1;
    elseif(G.Nodes.Visited(neigh(2))==0)
        nextNode=neigh(2);
        G.Nodes.Visited(nextNode)=1;
    end
    path=[path nextNode];
end
neigh=neighbors(G,path(length(path)));


if neigh(1)==startNode || neigh(2)==startNode
    hamil="Hamiltonian Circuit";
    path=[path startNode];
    return;
else
    hamil="Not a Hamiltonian Circuit";
    path=[];
    return;
end