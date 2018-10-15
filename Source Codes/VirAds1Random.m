function [P,Time]=VirAds1Random(G)
start=tic;
[n,~]=size(G.Nodes);
nve=zeros(n,1);
nva=zeros(n,1);
P=[];
for i=1:n
   nve(i)=degree(G,i);
   nva(i)=G.Nodes.Thresholds(i);
end
G.Nodes.nve=nve;
G.Nodes.nva=nva;
[gsize,~]=size(G.Nodes);
inactive=gsize;
while inactive ~= 0
    fprintf("Inactive:%d\n",inactive);
    u=find(G.Nodes.nve+G.Nodes.nva==max(G.Nodes.nve+G.Nodes.nva));
    randIndex=randperm(length(u));
    uid=find(G.Nodes.Label==string(u(randIndex(1))));
    %recompute for nve
    back2back=false;
    while back2back==false
        neighborsU=neighbors(G,uid);
        [nusize,~]=size(neighborsU);
        rnve=0;
        for i=1:nusize
            if G.Nodes.nva(neighborsU(i))-1==0
                rnve=rnve+1;
            end
        end
        G.Nodes.nve(uid)=rnve;
        nu=find(G.Nodes.nve+G.Nodes.nva==max(G.Nodes.nve+G.Nodes.nva));
        nuid=find(G.Nodes.Label==string(nu(1)));
        if nuid==uid
            back2back=true;
        else
            uid=nuid;
        end
    end
    P=[P uid];
    G.Nodes.nva(uid)=0;
    G.Nodes.nve(uid)=0;
    G.Nodes.Status(uid)=1;
    %initialize a queue
    Q=[];
    %queue implementation 
%    Q=[Q ;1 2]; adding element
%     Q=Q(2:size(Q),:); removing element
     Q=[Q ;uid];
%     G.Nodes.rv(uid)=0;
    
    neighborsU=neighbors(G,uid);
    [nusize,~]=size(neighborsU);

    %reduce neighbors' nva
    for i=1:nusize
       G.Nodes.nva(neighborsU(i))=max(G.Nodes.nva(neighborsU(i))-1,0);
    end
    
    %while loop
    
    while ~isempty(Q)
       T=Q(1);
       Q=Q(2:size(Q));
       tid=T;
       G.Nodes.Status(tid)=1;
        neighborsT=neighbors(G,tid);
        [ntsize,~]=size(neighborsT);
        for i=1:ntsize
           G.Nodes.Thresholds(neighborsT(i))=max(0, G.Nodes.Thresholds(neighborsT(i))-1);
           if G.Nodes.Thresholds(neighborsT(i))==0 && G.Nodes.Status(neighborsT(i))==0
               qcontains=false;
               for k=1:size(Q)-1
                   if Q(k)==neighborsT(i)
                       qcontains=true;
                   end
               end
               if qcontains==false
                   Q=[Q ;neighborsT(i)];
               end
           end
        end

    end
    
   %check if all are active already
    inactive=0;
    for i=1:n
        if G.Nodes.Status(i)==0
            inactive=inactive+1;
        end
    end
end
Time=toc(start);