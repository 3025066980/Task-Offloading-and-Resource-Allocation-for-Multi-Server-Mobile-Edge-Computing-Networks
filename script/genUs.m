function [Us,num] = genUs(G,server)
%GenUs ���ɷ�������Ӧ���û�����
    [m,~,z] = size(G);
    num = 0;
    Us = [];
    for user = 1:m
        for sub_band = 1:z
            if G(user,server,sub_band) > 0
                num = num + 1;
                Us(num) = user;
                break;
            end
        end
    end
end