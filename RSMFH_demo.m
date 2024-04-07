clear
clc;

addpath data;
addpath utils;

nbits_set=[32];

%% load dataset
load './data/labelme_sigir14.mat'
I_te = double(I_te);
I_tr = double(I_tr);
T_te = double(T_te);
T_tr = double(T_tr);

XTrain = I_tr; YTrain = T_tr; LTrain = L_tr;
XTest = I_te; YTest = T_te; LTest = L_te;


%% initialization   
fprintf('initializing...\n')
param.lambdaX = 0.5;
param.alpha = 0.001;
param.mu = 1000;
param.beta = 0.0001;
param.gamma = 0.1;
param.iter = 50;


tag = 1;
run = 10;

%% centralization
fprintf('centralizing data...\n');
XTest = bsxfun(@minus, XTest, mean(XTrain, 1)); XTrain = bsxfun(@minus, XTrain, mean(XTrain, 1));
YTest = bsxfun(@minus, YTest, mean(YTrain, 1)); YTrain = bsxfun(@minus, YTrain, mean(YTrain, 1));

% %% kernelization
fprintf('kernelizing...\n\n');
[XKTrain,XKTest]=Kernelize(XTrain,XTest); [YKTrain,YKTest]=Kernelize(YTrain,YTest);
XKTest = bsxfun(@minus, XKTest, mean(XKTrain, 1)); XKTrain = bsxfun(@minus, XKTrain, mean(XKTrain, 1));
YKTest = bsxfun(@minus, YKTest, mean(YKTrain, 1)); YKTrain = bsxfun(@minus, YKTrain, mean(YKTrain, 1));



%% evaluation
for bit=1:length(nbits_set) 
    nbits=nbits_set(bit);
    for i=1:run
    %% RSMFH
    param.nbits=nbits;
    eva_info =  main_RSMFH(XKTrain,YKTrain,XKTest,YKTest,LTest,LTrain,param);
    
    % train time
    trainT = eva_info.trainT;
    obj = eva_info.obj;
    
    % MAP
    Image_to_Text_MAP = eva_info.Image_to_Text_MAP;
    Text_to_Image_MAP = eva_info.Text_to_Image_MAP;
    mapIT(i,1) = Image_to_Text_MAP;
    mapTI(i,1) = Text_to_Image_MAP;
    end
    mapIT1 = mean(mapIT);
    mapTI1 = mean(mapTI);
    map(tag, 1) =  nbits;
    map(tag, 2) = mapIT1;
    map(tag, 3) = mapTI1;
    fprintf('RSMFH %d bits --  Image_to_Text_MAP: %f ; Text_to_Image_MAP: %f \n',map(tag,1),map(tag,2),map(tag,3));
    tag = tag + 1;
end



