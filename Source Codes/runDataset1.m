function runDataset(filename)
% .csv must not be included in filename

algo = ["TSS" "TSSRandom" "GreedyTSS" "GreedyTSSRandom" "TIPDecomp" "TIPDecompRandom" "VirAds" "VirAdsRandom" "VirAds1" "VirAds1Random"];
dmax=10;
for i=1:length(algo)
    A=[];
    for t=6:10
       G = constructGraph(strcat(filename,".csv"),t);
       if algo(i)=="VirAds" || algo(i)=="VirAdsRandom"
           for d=1:dmax
               [S,Time]=feval(algo(i),G,d);
               if Propagate(S,G)
                    A=[A ; length(S) Time d];
               else
                   fprintf("%s at t=%d cannot activate all the nodes. \n",algo(i),t);
                   return;
               end
           end
       else
           [S,Time]=feval(algo(i),G);
             if Propagate(S,G)
               A=[A ; length(S) Time];
             else
               fprintf("%s at t=%d cannot activate all the nodes. \n",algo(i),t);
               return;
             end
       end
     
    end
    csvwrite(strcat(strcat(filename,"_"),strcat(algo(i),".csv")),A);
end