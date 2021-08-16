function errorMatrix = calcErrorMatrix(out, dat)
    n_clusters = max([max(dat) max(out)]); %%dialegei to max enos apo ta 2 stoixeia
                                            %%profanws an mia klasi den
                                            %%exei dothei kan san
                                            %%apotelesma, den exei noima na
                                            %%tin eksetasw (de mou
                                            %%fainetai kai polu swsti
                                            %%logiki, prepei na simplirwsw
                                            %%ton pinaka gia oles tis
                                            %%yparxouses klaseis?
                                            %%diladi kati na einai klasi 5
                                            %%kai na min provlefthike pote,
                                            %%na provlefthike ws 4 pou
                                            %%yparxei px sto out
    
    errorMatrix = zeros(n_clusters, n_clusters);
    
    for i = 1:length(out)
        if(out(i)~=0)
            %%length out:simplirwnw ton pinaka me vasi to plithos pou testara kai pou edwse output
        errorMatrix(out(i), dat(i)) = errorMatrix(out(i), dat(i)) + 1;%%metraw gia kathe pithano syndyasmo ti itan vs
        %%ti provlefthike
        end
    end
end