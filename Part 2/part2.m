clear all;
close all;
warning('off','all')

load isolet.dat
data=isolet;

k = 5;

%%preprocessing
%%normalization
M = max(size(data));

for i = 1:M
    max_data = max(data(i, 1:end-1));
    min_data = min(data(i, 1:end-1));
    dif = max_data-min_data;
    data(i, 1:end-1) = (data(i, 1:end-1) - min_data) /dif;
end

%%divide dataset
[trainInd,valInd,testInd] = dividerand(7797,0.6,0.2,0.2);
a=randperm(length(trainInd));
b=randperm(length(valInd));
c=randperm(length(testInd));

trn = data(a,:);
val = data(b,:);
chk = data(c,:);

%%parameters
NF = [5 8 12 15];
NR = [5 10 15 20 25];
inputs=min(size(data))-1;
% NF = [2 3 4 5];
% NR = [2 3 4 5 6];

%%grid preparation
mean_err_mtrx = zeros(length(NF), length(NR));
cv = cvpartition(trn(:, end), 'KFold', 5);

positions = 1:length(trn);

trnOpt = NaN(5, 1);
trnOpt(1) = 70; % number of training epochs
dispOpt = zeros(4, 1);

optimal = {}; %%3d init

%%Relief
[ranks, weights] = relieff(trn(:, 1:end-1), trn(:, end), 10);

%%grid search
for f = 1:length(NF)
     for r = 1:length(NR)

        features = ranks(1:NF(f)); 
        features = [features inputs+1]; 
        
        optimal{f, r} = features;

        for j = 1:5
            [row, col, v_80] = find(positions.*(~cv.test(j))'); % 20%
            %% ektos tou 20% 
            [row, col, v_20] = find(positions.*(cv.test(j))'); % 20%
            trn_80 = trn(v_80, :); 
            v_20 = trn(v_20, :);

            trn_new = trn_80(:, features);
            v_new = v_20(:, features);
             
            inFIS = genfis3(trn_new(:,1:end-1),trn_new(:,end),'sugeno',NR(r),opt);
            n = getfis(inFIS, 'NumOutputMFs');
            for z = 1:n
               old = inFIS.output.mf(z).('params');
               inFIS.output.mf(z).('type') = 'constant';
               inFIS.output.mf(z).('params') = old(length(old));
            end

            [fis,error,stepsize,finalfis,chkerror] = anfis(trn_new,inFIS,100,[0 0 0 0],v_new);
            mean_err_mtrx(f, r) = mean_err_mtrx(f,r) + min(chkerror);
        end
       fprintf('Feature index %d Rule index %d [DONE].\n', NF(f), NR(r)); 
     end
 end

 %%find minimum
 [i_min,j_min]=minmat(mean_err_mtrx);
 feat = NF(i_min);
 clust = NR(j_min);
 
features = optimal{i_min,j_min};
 
trn_new = trn(:, features);
val_new = val(:, features);
chk_new = chk(:, features);

opt = NaN(4, 1);
opt(4) =  0;

%%generate initial model
inF = genfis3(trn_new(:, 1:end-1),trn_new(:,end),'sugeno',clust,opt);

n = getfis(inF, 'NumOutputMFs');
for z = 1:n
   old = inF.output.mf(z).('params');
   inF.output.mf(z).('type') = 'constant';
   inF.output.mf(z).('params') = old(length(old));
end

%%train model
[FIS,ERROR,STEPSIZE,FINALFIS,CHKERROR]=anfis(trn_new,inF,300,[0 0 0],val_new,1);


%%check
result = evalfis(chk_new(:,1:end-1),FINALFIS);
result = round(result);


%%metrics
errorMatrix = calcErrorMatrix(result, chk(:,end));
OA = sum(diag(errorMatrix))/length(result);
x=0;
y=max(size(errorMatrix));
[P_A, U_A, x]=findPA_UA_k(errorMatrix,y)
P_A_f(1,:)=P_A(1,:);
U_A_f(1,:)= U_A(1,:);
kest = (length(chk(:,1:end-1))*sum(diag(errorMatrix))-x)/(length(chk(:,1:end-1))^2-x);

%%plots 
plot(ERROR)
hold on
plot(CHKERROR, 'LineWidth', 1.5)
legend('Training', 'Check')

for i=1:5
subplot(2,3,i)
for j=1:min(size(xout))
    plot(xoutf(:,j),youtf(:,j))
    
    hold on
end
%title(['input '  num2str(i)]) 
end

for i=1:5

subplot(2,3,i)
for j=1:min(size(xout))
    plot(xout(:,j),yout(:,j))
    
    hold on
end
%title(['input '  num2str(i)]) 
end
 

figure
plot(result,'*')
hold on
plot(chk_new(:,end),'LineWidth',2);
title('Prediction and Real Values')
legend('Predicted Value', 'Real Value')
