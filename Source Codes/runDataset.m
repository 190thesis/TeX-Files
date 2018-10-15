function runDataset(filename)
% .csv must not be included in filename

G = constructGraph(strcat(filename,".csv"),1);
algo = ["TSS" "TSSRandom" "GreedyTSS" "GreedyTSSRandom" "TIPDecomp" "TIPDecompRandom" "VirAds1" "VirAds1Random"];
[~,n]=size(algo);
[gsize,~]=size(G.Nodes);
for i=1:n
    A=[];
    for t=1:10
       thresholds=ones(gsize,1)*t;
       G.Nodes.Thresholds=thresholds;
       [S,Time]=feval(algo(i),G);
       A=[A ; length(S) Time];
    end
    csvwrite(strcat(strcat(filename,"_"),strcat(algo(i),".csv")),A);
end