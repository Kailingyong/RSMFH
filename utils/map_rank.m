function [ap] = map_rank(traingnd,testgnd, IX)
%% Label Matrix
% if isvector(traingnd) 
%     le = length(unique(traingnd));
%     traingnd1 = zeros(length(traingnd),le);
%     for j=1:length(traingnd)
%         for i=1:le
%             if traingnd(j)==i
%                 traingnd1(j,i+1)=1;
%             end
%         end
%     end
%  traingnd = traingnd1;                              
% %     traingnd = sparse(1:length(traingnd), double(traingnd), 1); 
% %     traingnd = full(traingnd);
% end
% if isvector(testgnd) 
%     testgnd = sparse(1:length(testgnd), double(testgnd), 1); 
%     testgnd = full(testgnd);
% end

[numtrain, numtest] = size(IX);
apall = zeros(numtrain,numtest);
aa = 1:numtrain;
for i = 1 : numtest
    y = IX(:,i);
    new_label=zeros(1,numtrain);
    new_label(traingnd*testgnd(i,:)'>0)=1;   
    xx = cumsum(new_label(y));
    x = xx.*new_label(y);
    p = x./aa;
    p = cumsum(p);
    id = find(p~=0);
    p(id) = p(id)./xx(id);
    apall(:,i) = p';
end
ap = mean(apall,2);
