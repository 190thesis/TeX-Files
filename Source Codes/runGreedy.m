function S = runGreedy(filename)

S=[];

for i=1:10
    G=constructGraph(filename,i);
    s=GreedyTSS(G);
    S=[S s];
end