function [P,Time]=VirAds(G,d)
start=tic;
[n,~]=size(G.Nodes);
nve=G.Nodes.Degree;
nva=G.Nodes.Thresholds;
rv=zeros(n,1);
rvi=zeros(n,d+1);
P=[];
for i=1:n
   rv(i)=d+1;
end
G.Nodes.nve=nve;
G.Nodes.nva=nva;
G.Nodes.rv=rv;
G.Nodes.argmax=G.Nodes.nva+G.Nodes.nve;
while sum(G.Nodes.nva)~=0
    u=find(G.Nodes.argmax==max(G.Nodes.argmax(G.Nodes.Status==0)));
    uid=u(1);
    %recompute for nve
    back2back=false;
    while back2back==false
        neighborsU=neighbors(G,uid);
        [nusize,~]=size(neighborsU);
        rnve=0;
        for i=1:nusize
            if G.Nodes.nva(neighborsU(i))==1
                rnve=rnve+1;
            end
        end
        G.Nodes.nve(uid)=rnve;
        G.Nodes.argmax=G.Nodes.nva+G.Nodes.nve;
        nu=find(G.Nodes.argmax==max(G.Nodes.argmax(G.Nodes.Status==0)));
        nuid=nu(1);
        if nuid==uid
            back2back=true;
        else
            uid=nuid;
        end
    end
    P=[P uid];
    G.Nodes.nva(uid)=0;
%     G.Nodes.nve(uid)=0;
    G.Nodes.Status(uid)=1;
    %initialize a queue
    Qid=[];
    Qrv=[];
    %queue implementation 
%    Q=[Q ;1 2]; aQdding element
%     Q=Q(2:size(Q),:); removing element
     Qid=[Qid;uid];
     Qrv=[Qrv;G.Nodes.rv(uid)];
    G.Nodes.rv(uid)=0;
    neighborsU=neighbors(G,uid);
    [nusize,~]=size(neighborsU);

    %reduce neighbors' nva
    for i=1:nusize
       G.Nodes.nva(neighborsU(i))=max(G.Nodes.nva(neighborsU(i))-1,0);
%        if G.Nodes.nva(neighborsU(i))==0
%           G.Nodes.Status(neighborsU(i))=1; 
%           G.Nodes.nve(neighborsU(i))=0;
%        end
    end
    
    %while loop
    while ~isempty(Qid)
       tid=Qid(1);
       trv=Qrv(1);
       Qid=Qid(2:length(Qid)); %removing element
       Qrv=Qrv(2:length(Qrv));
       %for loop neigbors
       G.Nodes.Status(tid)=1;
       neighborsT=neighbors(G,tid);
       neighborsT=neighborsT(G.Nodes.Status(neighborsT)==0);
       [ntsize,~]=size(neighborsT);
        for w=1:ntsize
            upperlimit=min(trv-1,G.Nodes.rv(neighborsT(w))-2);
            from=G.Nodes.rv(tid);
            to=upperlimit;
            if upperlimit<G.Nodes.rv(tid) && upperlimit>=0
               from=upperlimit; 
               to=G.Nodes.rv(tid);
            end

            for i=from:to
                rvi(neighborsT(w),i+1)=rvi(neighborsT(w),i+1)+1;
                if rvi(neighborsT(w),i+1) >= G.Nodes.Thresholds(neighborsT(w))
                   if G.Nodes.rv(neighborsT(w))>=d && i+1<d
                      neighborsW=neighbors(G,neighborsT(w));
                      neighborsW=neighborsW(G.Nodes.Status(neighborsW)==0);
                      [xusize,~]=size(neighborsW);
                      for x=1:xusize
                              G.Nodes.nva(neighborsW(x))=max(G.Nodes.nva(neighborsW(x))-1,0);
%                               if G.Nodes.nva(neighborsW(x))==0
%                                   G.Nodes.Status(neighborsW(x))=1;
%                               end
                      end
                       G.Nodes.rv(neighborsT(w))=i+1;
                       if G.Nodes.rv(neighborsT(w))<d
                            if isempty(Qid(Qid==neighborsT(w)))
                                Qid=[Qid;neighborsT(w)];
                                Qrv=[Qrv;G.Nodes.rv(neighborsT(w))];
                                G.Nodes.Status(neighborsT(w))=1;
                            end
                       end
                   end
                  
                end
            end
        end
    end
    G.Nodes.argmax=G.Nodes.nva+G.Nodes.nve;
    %check if all are active already
    fprintf("VirAds Inactive:%d, P:%d\n",length(find(G.Nodes.Status==0)),length(P));
end
Time=toc(start);