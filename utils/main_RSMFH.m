function evaluation_info =  main_RSMFH(XTrain,YTrain,XTest,YTest,LTest,LTrain,param)
    tic;
    
    [W1,W2,B,obj] = slove_RSMFH(XTrain, YTrain, LTrain, param);
    
    
    fprintf('evaluating...\n');
    
    %% Training Time
    traintime=toc;
    evaluation_info.trainT=traintime;
    evaluation_info.obj=obj;
    

    %% image as query to retrieve text database
    BxTest = compactbit(XTest*W1'>= 0);
    ByTrain = compactbit(B' >= 0);
    Dhamm1 = hammingDist(BxTest, ByTrain)';   
    [~, HammingRank]=sort(Dhamm1,1);
    mapIT = map_rank(LTrain, LTest,HammingRank); 
    evaluation_info.Image_to_Text_MAP = mapIT(50);


    %% text as query to retrieve image database
    ByTest = compactbit(YTest*W2' >= 0);
    BxTrain = compactbit(B' >= 0);
    Dhamm2 = hammingDist(ByTest, BxTrain)';
    [~, HammingRank]=sort(Dhamm2,1);
    mapTI = map_rank(LTrain, LTest,HammingRank); 
    evaluation_info.Text_to_Image_MAP = mapTI(50);
    
end




