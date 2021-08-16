function [PA, UA, x] = findPA_UA_k(errorMatrix,y)
    x=0;
    for q=1:y
        PA(q) = errorMatrix(q,q)/sum(errorMatrix(:,q));
        UA(q) = errorMatrix(q,q)/sum(errorMatrix(q,:));
        x = x + sum(errorMatrix(:,q))*sum(errorMatrix(q,:));
    end
    
end