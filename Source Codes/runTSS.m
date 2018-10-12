function runTSS(filename)
for i=1:10
    resultFile=fopen('ResultTSS.txt','a');
    G=constructGraph(filename,i);
    [s Time]=TSS(G);
    [sRandom TimeRandom]=TSSRandom(G);
    fprintf(resultFile,'%g, %f, %g, %f\n', length(s), Time, length(sRandom), TimeRandom);
    fclose(resultFile);
end