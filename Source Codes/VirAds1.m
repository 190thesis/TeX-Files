function [P,Time]=VirAds1(G)
start=tic;
[n,~]=size(G.Nodes);
nve=zeros(n,1);
nva=zeros(n,1);
argmax=zeros(n,1);
P=[];
for i=1:n
   nve(i)=degree(G,i);
   nva(i)=G.Nodes.Thresholds(i);
   argmax(i)=nve(i)+nva(i);
end
G.Nodes.nve=nve;
G.Nodes.nva=nva;
G.Nodes.argmax=argmax;
inactive=gsize;
while inactive ~= 0
    u=G.Nodes.Status==0;
    u=find(G.Nodes.argmax==max(G.Nodes.argmax(u)));
    u=u(G.Nodes.Status(u)==0);
    curru=u(1);
    %recompute for nve
    back2back=false;
    while back2back==false
        neighborsU=neighbors(G,curru);
        [nusize,~]=size(neighborsU);
        rnve=0;
        for i=1:nusize
            if G.Nodes.nva(neighborsU(i))-1==0
                rnve=rnve+1;
            end
        end
        G.Nodes.nve(curru)=rnve;
        nu=G.Nodes.Status==0;
        nu=find(G.Nodes.argmax==max(G.Nodes.argmax(nu)));
        nu=nu(G.Nodes.Status(nu)==0);
        currn=nu(1);
        if currn==curru
            back2back=true;
        else
            curru=currn;
        end
    end
    P=[P curru];
    G.Nodes.nva(curru)=0;
    G.Nodes.nve(curru)=0;
    G.Nodes.Status(curru)=1;
    %initialize a queue
    Q=[];
    %queue implementation 
%    Q=[Q ;1 2]; adding element
%    Q=Q(2:size(Q),:); removing element
     Q=[Q ;curru];
    
    neighborsU=neighbors(G,curru);
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
               G.Nodes.Status(neighborsT(i))=1
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
    inactive=gsize-sum(G.Nodes.Status);
    fprintf("VirAds1 Inactive:%d\n",inactive);
end
Time=toc(start);