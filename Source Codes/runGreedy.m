function runGreedy(filename)
Dataset=fopen('ResultGreedy.txt','a');
fprintf(Dataset,'%s\n',filename);
fclose(Dataset);
for i=1:10
    fileResult=fopen('ResultGreedy.txt','a');
    G=constructGraph(filename,i);
    [s Time]=GreedyTSS(G);
    [sRandom RandomTime]=GreedyTSSRandom(G);
    fprintf(fileResult,'%g, %s, %g, %s\n',length(s), Time, length(sRandom), RandomTime);
    fclose(fileResult);
end