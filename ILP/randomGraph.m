function [G syntax] =randomGraph(n,p)

G=graph;

bounds="bin ";
for i=1:n
    for j=i:n
        if i~=j
            randArray=randperm(10);
            randArray(1);
            if(randArray(1)<=p)
                G=addedge(G,i,j);
            end
        end
    end
end
Result=strings(size(G.Nodes,1),1);
A=full(adjacency(G));
ctr=0;
for i=1:size(G.Nodes,1)
    for j=i:size(G.Nodes,1)
        if i~=j
            if A(i,j)==1
                ctr=ctr+1;
                Result(i)=strcat(Result(i),'A',int2str(ctr),"+");
                bounds=strcat(bounds,"A",int2str(ctr),",");
             
                Result(j)=strcat(Result(j),'B',int2str(ctr),"+");
                bounds=strcat(bounds,"B",int2str(ctr),",");
            end
        end
    end
end
ctr=0;
for i=1:size(G.Nodes,1)
    for j=1:i
        if A(j,i)==1
            ctr=ctr+1;
        end
    end
end


constraint=strings(ctr,1);
k=1;
for i=1:size(G.Nodes,1)
    for j=i:size(G.Nodes,1)
        if i~=j
            if A(i,j)==1
                constraint(k)=strcat(constraint(k),'A',int2str(k),"+B",int2str(k),"=1;");
                k=k+1;
            end
        end
    end
end

cons2=strings(ctr,1);
cons3=strings(ctr,1);
cons1=strings(length(Result),1);
k=1;
for i=1:length(Result)
    if Result(i)~=""
        temp=strip(Result(i),'right','+');
        cons1(i)=strcat(temp,">=1",";");
    end
end
for i=1:size(G.Nodes,1)
    for j=i:size(G.Nodes,1)
        if A(i,j)==1
            cons2(k)=strcat("B",int2str(k),">=x",int2str(i),";");
            cons3(k)=strcat("A",int2str(k),">=x",int2str(j),";");
            k=k+1;
        end
    end
end
for i=1:size(G.Nodes,1)
    G.Nodes.Label(i)=string(i);
    G.Nodes.Degree(i)=degree(G,i);
    randThresh=randperm(G.Nodes.Degree(i));
    if(isempty(randThresh)==1)
        G.Nodes.Thresholds(i)=0;
    else
        G.Nodes.Thresholds(i)=randThresh(1);
    end
    G.Nodes.Status(i)=0;
end
for i=1:length(Result)
    if Result(i)~=""
        Result(i)=strcat(Result(i),int2str(G.Nodes.Thresholds(i))," x",int2str(i),">=",int2str(G.Nodes.Thresholds(i)),";");
    end
end
objective ="min:";
for i=1:length(Result)
    if Result(i)~=""
        
        objective = strcat(objective,"x",int2str(i),"+");
    end
end
objective=strip(objective,'right','+');
objective=strcat(objective,";");
for i=1:length(Result)
    if Result(i)~=""
        bounds=strcat(bounds,"x",int2str(i),",");
    end
    if i==length(Result)
        bounds=strip(bounds,'right',',');
        bounds=strcat(bounds,";");
    end
end
syntax=[objective;constraint;Result;bounds;];
