function S = runTSS(filename)
S=[];
for i=1:10
    G=constructGraph(filename,i);
    s=TSS(G);
    S=[S s];
end