function [Us,num] = comparation_genUs(G,server)
%GenUs ���ɷ�������Ӧ���û�����
    [Us(:,1),Us(:,2)] = find(G(:,server,:)>0);
    [num,~] = size(Us(:,1));
end