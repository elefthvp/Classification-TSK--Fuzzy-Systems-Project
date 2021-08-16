%Eleftheria Papaioannou AEM:8566
%Fuzzy Systems, exercise 4 part 1

clear;
close all;
%help SUBCLUST
load avila.txt
data=avila;

M = max(size(data));
inputs=10;


[trainInd,valInd,testInd] = dividerand(20867,0.6,0.2,0.2);
a=randperm(length(trainInd));
b=randperm(length(valInd));
c=randperm(length(testInd));

trnDatax=data(a,1:end-1);
trnDatay=data(a,end);
valDatax=data(b,1:end-1);
valDatay=data(b,end);
chkDatax=data(c,1:end-1);
chkDatay=data(c,end);
%num_of_tsk=5;
%NR_ideal = [4,8,12,16,20];
NR=[2 3 4 5];
num_of_tsk=length(NR);


rad=[0.55 0.25 0.23 0.2 0.195 0.19 0.185 0.18];
%rad2=[0.5 0.45 0.4 0.35 0.3 0.25 0.22]
k=1
num_of_rules=[];


for i=1:length(rad)
%i=1
    model(i)= genfis2(trnDatax,trnDatay,rad(i));
    rules=length(model(i).rule);
    num_of_rules=[num_of_rules length(model(i).rule)];
%     if(rules==NR(k))
%         final_model(k)=model;
%         k=k+1;
%         if(k>num_of_tsk)
%         break; %%all models found
%         end
%     end
    
 end

trnOpt = NaN(5, 1);
trnOpt(1) = 80; %number of training epochs
dispOpt = [0 0 0 0];
TrnOpt(4)=0.2;
TrnOpt(5)=0.7;
TrnOpt(3)=0.01;



for i=1:num_of_tsk
%i=1;

     n(i) = getfis(model(i), 'NumOutputMFs');
     for j = 1:n(i)
       oldParams = model(i).output.mf(j).('params');
       model(i).output.mf(j).('type') = 'constant';
       model(i).output.mf(j).('params') = oldParams(length(oldParams));
     end

    [fis, error, stepsize,chkFis,chkErr] = anfis([trnDatax trnDatay], model(i),trnOpt,dispOpt,[valDatax valDatay],1);
    result = evalfis(chkDatax, chkFis);
    result = round(result);

    errorMatrix = calcErrorMatrix(result, chkDatay);
    OA(i) = sum(diag(errorMatrix))/length(result);
    x=0;
    y=max(size(errorMatrix));
    [P_A, U_A, x]=findPA_UA_k(errorMatrix,y)
    P_A_f(i,:)=P_A(1,:);
    U_A_f(i,:)= U_A(1,:);
    kest(i) = (length(chkDatax)*sum(diag(errorMatrix))-x)/(length(chkDatax)^2-x);
        figure();
        %filename = ['errormatrix' num2str(NR(i)) '.jpg']
        fprintf('Plot error matrix \n');
        imagesc(errorMatrix)
        colorbar()
        title(['Error matrix of model with ' num2str(NR(i)) ' rules'])
        %saveas(1,filename)%    
    
    for j=1:inputs

       subplot(4,3,j)
       title ('model with 2 rules' )
        [f,mf] = plotmf(chkFis,'input',j);
        %filename = ['In' num2str(j) 'mod' num2str(NR(i)) '.jpg']
        plot(f ,mf)
        title(['Input ' num2str(j)], 'fontweight','bold','fontsize',10)
        %saveas(1,filename)
        
    end
     
      %filename = ['learning curve' num2str(NR(i)) '.jpg']
    figure();
    plot(error, 'LineWidth',2)
    hold on
    plot(chkErr, 'LineWidth',2)
    title(['Learning curves of model with  ' num2str(NR(i)) ' rules'])
    legend('Training', 'Check')
    
    %saveas(1,filename)   
        
end
