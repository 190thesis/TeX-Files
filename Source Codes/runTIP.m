function runTIP(filename)

for i=1:10
    resultFile=fopen('ResultTIP.txt','a');
    G=constructGraph(filename,i);
    [resultG, Time]=TIPDecomp(G);
    [resultRandom, TimeRandom]=TIPDecompRandom(G);
    fprintf(resultFile,'%g, %f, %g, %f\n',length(resultG),Time, length(resultRandom),TimeRandom);
    fclose(resultFile);
end
