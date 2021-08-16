function errorMatrix = calcErrorMatrix(out, dat)
    max_actual=max(dat)
    max_predicted=max(out)
    dimension = max([max_actual max_predicted]);
    
    errorMatrix = zeros(dimension, dimension);
    
    for i = 1:length(out)
        if(out(i)~=0)
        errorMatrix(out(i), dat(i)) = errorMatrix(out(i), dat(i)) + 1;
        end
    end
end