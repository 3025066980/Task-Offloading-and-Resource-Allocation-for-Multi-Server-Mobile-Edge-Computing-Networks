function [J, X, P, F] = ta( ...
    userNumber,...              % �û�����
    serverNumber,...            % ����������
    sub_bandNumber,...          % �Ӵ�����
    T,...                       % ��ʼ���¶�ֵ
    T_min,...                   % �¶��½�
    alpha,...                   % �¶ȵ��½���
    k, ...                      % �����ռ�Ĵ�С
    minimal_cost,...            % ��СĿ��ֵ������ֵԽС������Ӧ��Խ�ߣ�
    para...                     % �������
)
%TA Task allocation,��������㷨������ģ���˻��㷨

    %T=1000;         
    %T_min=1e-12;    
    %alpha=0.98;     
    %k=1000;         

    x= genRandSeed(userNumber, serverNumber,sub_bandNumber);    %����õ���ʼ��
    
    picture = zeros(2,1);
    index = 1;
    
    while(T>T_min)
        for I=1:k
            G = convert2G(x,userNumber, serverNumber,sub_bandNumber);
            [fx, P, F] = Fx(G,para);
            J = fx;
            x_new = getneighbourhood(x,userNumber, serverNumber,sub_bandNumber);
            G_new = convert2G(x_new,userNumber, serverNumber,sub_bandNumber);
            [fx_new, P_new, F_new] = Fx(G_new,para);
            delta = fx_new-fx;
            if (delta<0)
                x = x_new;
                J = fx_new;
                X = x;
                P = P_new;
                F = F_new;
                if fx_new < minimal_cost
                    picture(index,1) = T;
                    picture(index,2) = J;
                    figure
                    plot(picture(1),picture(2))
                    return;
                end
            else
                pro=getProbability(delta,T);
                if(pro>rand)
                    x=x_new;
                end
            end
        end
        picture(index,1) = T;
        picture(index,2) = J;
        index = index + 1;
        T=T*alpha;
    end
    figure
    plot(picture(1),picture(2))
end
 
function res = getneighbourhood(x,userNumber,serverNumber,sub_bandNumber)
    user = unidrnd(userNumber);
    for server = 1:serverNumber
        if x(user,server) ~= 0
            break;  %�ҵ��û�������ķ�����
        end
    end
    %�����Ŷ���ʽ���������߸�ֵ
    if rand > 0.3   %����ĳ���û���Ƶ���ͷ�����
        x(user,server) = 0;     %ȡ��ԭ���ķ���
        band_flag = zeros(sub_bandNumber,2);    %Ƶ��ʹ������ı������
        if rand > 0.6   %�����û��ķ�����
            vary_server = unidrnd(serverNumber);    %Ŀ�������
            for i=1:userNumber  %ʹ��һ��ѭ�����б��
                if x(i,vary_server) ~= 0
                    band_flag(x(i,vary_server),1) = 1;      %��һά��1˵���Ѿ�ʹ��
                    band_flag(x(i,vary_server),2) = i;      %�ڶ�ά�����˭�õ�
                end
            end
            vacancy = 0;
            for j=1:sub_bandNumber  %ʹ��һ��ѭ�����ҿ�ȱ��Ƶ��
                if band_flag(j,1) ~= 1
                    vacancy = 1;
                    x(user,vary_server) = j;
                    break;
                end
            end
            if vacancy == 0     %���û�п�ȱ��Ƶ��
                vary_band = unidrnd(sub_bandNumber);
                victimeUser = band_flag(vary_band,2);
                x(victimeUser,vary_server) = 0;
                x(user,vary_server) = vary_band;   %�������һ���û��Ķ�һ������
            end
        else    %�����û���Ƶ����Ҳ����ѡ���Ƿ�offload��
            vary_band = unidrnd(sub_bandNumber+1)-1;    %Ŀ��Ƶ��
            if vary_band ~= 0    %������Ǹ���������ִ�У����ܻ������ͻ��Ҫ���м�鴦��
                for i=1:userNumber  %ʹ��һ��ѭ�����б��
                    if x(i,server) ~= 0
                        band_flag(x(i,server),1) = 1;      %��һά��1˵���Ѿ�ʹ��
                        band_flag(x(i,server),2) = i;      %�ڶ�ά�����˭�õ�
                    end
                end
                if band_flag(vary_band,1) == 1  %������Ƶ����ʹ���ˣ�Ҫ��ԭ�ȵ��û�����һ���Դ�
                    victimeUser = band_flag(vary_band,2);
                    vacancy = 0;
                    for j=1:sub_bandNumber  %ʹ��һ��ѭ�����ҿ�ȱ��Ƶ��
                        if band_flag(j,1) ~= 1
                            vacancy = 1;
                            x(victimeUser,server) = j;
                            break;
                        end
                    end
                    if vacancy == 0     %���û�п�ȱ��Ƶ�����ǾͰݰ��ˣ��Լ����
                        x(victimeUser,server) = 0;
                    end
                end
            end
            x(user,server) = vary_band;
        end
    else    %���������û��ķ�������Ƶ��
        user_other = unidrnd(userNumber);
        server_other = unidrnd(serverNumber);
        temp_band = x(user,server);
        x(user,server) = 0;
        x(user,server_other) = x(user_other,server_other);  %����Ƶ���ͷ�����
        x(user_other,server_other) = 0;
        x(user_other,server) = temp_band;
    end
    res = x;
end
 
function p = getProbability(delta,t)
    p=exp(-delta/t);
end

function G = convert2G(pop,userNumber, serverNumber,sub_bandNumber)
%Convert2G  ��pop����ת��ΪG����
    G = zeros(userNumber, serverNumber,sub_bandNumber);
    for user=1:userNumber
        for server=1:serverNumber
            sub = pop(user, server);
            if sub ~= 0
                G(user, server,sub) = 1;
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
        notzero = [];
        for server=1:serverNumber   %ͳ�Ƹ�ά���в�Ϊ��Ԫ�ظ���
            if pop(user,server) ~= 0
                number = number + 1;
                notzero(number) = server;
            end
        end
        if number > 1
            chosen = unidrnd(number);
            for server=1:number
                if server~=chosen
                    pop(user,notzero(server)) = 0;
                end
            end
        end
    end
end

function [Jx, P, F] = Fx(x,para)
    [P,res_pra] = pra(x,para.beta_time,para.beta_enengy,para.Tu,para.tu_local,para.Eu_local,para.W,para.Ht,para.Pu,para.Sigma,para.r,para.Epsilon,para.beta,para.lamda);
    [F,res_cra] = cra(x,para.Fs,para.Eta_user);
    Jx = 0;
    [~,serverNumber,~] = size(x);
    for server = 1:serverNumber
       [Us,n] = genUs(x,server);
        if n > 0
            for user = 1:n
                Kappa = getKappa(x,user,server,para.beta_time,para.beta_enengy,para.Sigma,para.Tu,para.tu_local,para.Eu_local,para.W,para.Hr,para.Pur,para.Ps);
                Jx = Jx + para.lamda(Us(user)) * (1 - Kappa);
            end
        end
    end
    Jx = (Jx - res_pra - res_cra);
end

function Kappa = getKappa(x,user,server,beta_time,beta_enengy,Sigma,Tu,tu_local,Eu_local,W,Hr,Pur,Ps)
%GetKappa ����Kappa_us
    Kappa = beta_time(user)/tu_local(user) + beta_enengy(user)/Eu_local(user)*Pur(user);
    Xi_us = getXi(x,Ps,Sigma,Hr,user,server);
    Kappa = Kappa * Tu(user).output/W /log2(1 + Xi_us) ;
end

function Xi = getXi(G,Ps,Sigma,Hr,user,server)
%GetXi ����Xi_us
    Xi = 0;
    [~,serverNumber,sub_bandNumber] = size(G);
    for sub_band = 1:sub_bandNumber
        denominator = 0;    %�����ĸ
        for i = 1:serverNumber
            if i ~= server
                [Us,userNumber] = genUs(G,i);
                for k = 1:userNumber
                    denominator = denominator + G(Us(k),i,sub_band) * Ps(Us(k)) * Hr(Us(k),i,sub_band);
                end
            end
        end
        denominator = denominator + Sigma^2;    %��ĸ�������
        Xi = Ps(user)*Hr(user,server,sub_band)/denominator;
    end
end
