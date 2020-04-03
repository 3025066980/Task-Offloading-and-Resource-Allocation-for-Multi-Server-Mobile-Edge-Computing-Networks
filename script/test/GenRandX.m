function X = GenRandX(userNumber, serverNumber,sub_bandNumber)
%Convert2G  ��pop����ת��ΪG����
    pop = genRandSeed(userNumber, serverNumber,sub_bandNumber);
    X = zeros(userNumber, serverNumber,sub_bandNumber);
    for user=1:userNumber
        for server=1:serverNumber
            sub = pop(user, server);
            if sub ~= 0
                X(user, server,sub) = 1;
            end
        end
    end
end

function pop = genRandSeed(userNumber, serverNumber,sub_bandNumber)
%GenRandSeed    ��������Լ����������Ӿ���
    pop = zeros(userNumber, serverNumber);
    for server=1:serverNumber
        if sub_bandNumber >= userNumber
            pop(:,server) = randperm(sub_bandNumber+1,userNumber) - 1;    %Ϊÿ������������������N���û�
        else
            temp = randperm(sub_bandNumber+1,sub_bandNumber) - 1;
            member = randperm(userNumber,sub_bandNumber);
            pop(member,server) = temp;
        end
    end
    for user=1:userNumber
        number = 0;
        for server=1:serverNumber   %ͳ�Ƹ�ά���в�Ϊ��Ԫ�ظ���
            if pop(user,server) ~= 0
                number = number + 1; 
            end
        end
        if number > 1
            chosen = unidrnd(number);
            index = 0;
            for server=1:serverNumber
                if server~=chosen
                    index = index +1;
                    if index~=chosen
                        pop(user,server) = 0;  %�û����ѡ��һ��������ķ�������Ҳ�п������Լ���
                    end
                end
            end
        end
    end
end