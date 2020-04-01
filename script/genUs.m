function [Us,num] = genUs(G,i)
%GenUs ���ɷ�������Ӧ���û�����
    [~,n,z] = size(G);
    num = 0;
    Us = [];
    for j = 1:n
        for k = 1:z
            if G(i,j,k) > 0
                Us(num) = j;
                num = num + 1;
                break;
            end
        end
    end
return