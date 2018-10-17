function [P,Time]=VirAds(G,d)
start=tic;
[n,~]=size(G.Nodes);
nve=zeros(n,1);
nva=zeros(n,1);
rv=zeros(n,1);
rvi=zeros(n,d);
P=[];
for i=1:n
   nve(i)=degree(G,i);
   nva(i)=G.Nodes.Thresholds(i);
   rv(i)=d+1;
end
G.Nodes.nve=nve;
G.Nodes.nva=nva;
G.Nodes.rv=rv;
[gsize,~]=size(G.Nodes);
inactive=gsize;
while inactive ~= 0
    u=find(G.Nodes.nve+G.Nodes.nva==max(G.Nodes.nve+G.Nodes.nva));
    uid=find(G.Nodes.Label==string(u(1)));
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
     Q=[Q ;uid G.Nodes.rv(uid)];
%     G.Nodes.rv(uid)=0;
    
    neighborsU=neighbors(G,uid);
    [nusize,~]=size(neighborsU);

    %reduce neighbors' nva
    for i=1:nusize
       G.Nodes.nva(neighborsU(i))=max(G.Nodes.nva(neighborsU(i))-1,0);
       if G.Nodes.nva(neighborsU(i))==0
          G.Nodes.Status(neighborsU(i))=1; 
       end
    end
    
    %while loop
    while ~isempty(Q)
       tid=Q(1,1);
       trv=Q(1,2);
       Q=Q(2:size(Q),:); %removing element
       %for loop neigbors
       neighborsT=neighbors(G,tid);
       [ntsize,~]=size(neighborsT);
        for w=1:ntsize
            upperlimit=min(trv-1,G.Nodes.rv(neighborsT(w))-2);
            for i=G.Nodes.rv(tid):upperlimit
                rvi(neighborsT(w),i+1)=rvi(neighborsT(w),i+1)+1;
                if rvi(neighborsT(w),i+1) >= G.Nodes.Thresholds(neighborsT(w))
                   if G.Nodes.rv(neighborsT(w))>=d && i+1<d
                      neighborsW=neighbors(G,neighborsT(w));
                      [xusize,~]=size(neighborsW);
                      for x=1:xusize
                          if neighborsW(x)~=uid
                              G.Nodes.nva(neighborsW(x))=max(G.Nodes.nva(neighborsW(x))-1,0);
                              if G.Nodes.nva(neighborsW(x))==0
                                  G.Nodes.Status(neighborsW(x))=1;
                              end
                          end
                      end
                   end
                   G.Nodes.rv(neighborsT(w))=i+1;
                   if G.Nodes.rv(neighborsT(w))<d
                       % check if w is in Q
                       [qrow , ~]=size(Q);
                       qcontains=false;
                       for k=1:qrow
                           if Q(k,1)==neighborsT(w)
                               qcontains=true;
                           end
                       end
                       if qcontains==false
                           Q=[Q ;neighborsT(w) G.Nodes.rv(neighborsT(w))];
                       end
                       
                   end
                end
            end
        end
    end
    %check if all are active already
    inactive=gsize-sum(G.Nodes.Status);
    fprintf("VirAds Inactive:%d\n",inactive);
end
Time=toc(start);