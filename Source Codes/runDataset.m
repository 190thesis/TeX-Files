function runDataset(filename)
% .csv must not be included in filename
mkdir(char(filename));
%list of algos to be run
algo = ["TSS" "TSSRandom" "TSSRandom" "TSSRandom" "TSSRandom" "TSSRandom" "GreedyTSS" "GreedyTSSRandom" "GreedyTSSRandom" "GreedyTSSRandom" "GreedyTSSRandom" "GreedyTSSRandom" "TIPDecomp" "TIPDecompRandom" "TIPDecompRandom" "TIPDecompRandom" "TIPDecompRandom" "TIPDecompRandom" "VirAds" "VirAdsRandom" "VirAdsRandom" "VirAdsRandom" "VirAdsRandom" "VirAdsRandom"];
dmax=100;
ctr=1;
for i=1:length(algo)
    A=[];
    for t=1:10
       G = constructGraph(strcat(filename,".csv"),t);
       if algo(i)=="VirAds" || algo(i)=="VirAdsRandom"
           for d=1:10:dmax
               [S,Time]=feval(algo(i),G,d);
               A=[A ; length(S) Time d];
               dlmwrite(strcat(strcat(filename,"/"),strcat(strcat(algo(i),strcat("_RAW_",int2str(t))),".csv")),S,'delimiter',',','-append');
           end
       else
           [S,Time]=feval(algo(i),G);
           A=[A ;t length(S) Time];
           dlmwrite(strcat(strcat(filename,"/"),strcat(strcat(algo(i),strcat("_RAW_",int2str(t))),".csv")),S,'delimiter',',','-append');
           ctr=ctr+1;
       end
     
    end
    dlmwrite(strcat(strcat(filename,"/"),strcat(algo(i),".csv")),A,'delimiter',',','-append');
end