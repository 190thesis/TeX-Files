function result = runTIP(filename)

thresholds=[10,9,8,7,6,5,4,3,2,1];
result=[];
for i=1:10
    G=constructGraph(filename,thresholds(i));
    resultG=TIPDecomp(G);
    result=[result,size(find(resultG.Nodes.Status==0),1)];
end