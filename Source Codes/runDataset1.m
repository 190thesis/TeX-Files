function runDataset(filename)
% .csv must not be included in filename

algo = ["TSS" "TSSRandom" "GreedyTSS" "GreedyTSSRandom" "TIPDecomp" "TIPDecompRandom" "VirAds" "VirAdsRandom" "VirAds1" "VirAds1Random"];
dmax=10;
for i=1:length(algo)
    A=[];
    parfor t=1:10
       G = constructGraph(strcat(filename,".csv"),t);
       if algo(i)=="VirAds" || algo(i)=="VirAdsRandom"
           for d=1:dmax
               [S,Time]=feval(algo(i),G,d);
               A=[A ; length(S) Time d];
           end
       else
           [S,Time]=feval(algo(i),G);
           A=[A ; length(S) Time];
       end
     
    end
    csvwrite(strcat(strcat(filename,"_"),strcat(algo(i),".csv")),A);
end