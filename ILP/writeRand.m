function writeRand(G,n)

A=full(adjacency(G));
thresh=G.Nodes.Thresholds;
filename=strcat('ILP-Sheets\rand30-',int2str(n));
filename=strcat(filename,'.xlsx');
A=[A thresh];

xlswrite(filename,A);