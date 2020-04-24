function [serverMap,userMap] = genLocation(userNumber,serverNumber,gapOfServer)
%GENLOCATION ����������û��ͷ�����������
%�������������������ھ������У��û��������
    xlength = (serverNumber^0.5+1) * (gapOfServer);
    ylength = xlength;
    index = 1;
    serverMap = zeros(serverNumber,2);
    if serverNumber ~= 2
        for i = 1:serverNumber^0.5
            for j = 1:serverNumber^0.5
                serverMap(index,1) = i * gapOfServer;
                serverMap(index,2) = j * gapOfServer;
                index = index + 1;
            end
        end
    else
        for i = 1:2
        	serverMap(index,1) = gapOfServer;
            serverMap(index,2) = i * gapOfServer;
            index = index + 1;
        end
    end
    index = 1;
    userMap = zeros(userNumber,2);
    for i = 1:userNumber
        userMap(index,1) =  xlength * rand;
        userMap(index,2) =  ylength * rand;
        index = index + 1;
    end
end
