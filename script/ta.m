function [J, X, F] = ta( ...
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

    x= genRandX(userNumber, serverNumber,sub_bandNumber);    %����õ���ʼ��
    
    picture = zeros(2,1);
    index = 1;
    
    while(T>T_min)
        for I=1:k
            [fx, F] = Fx(x,para);
            J = fx;
            x_new = getneighbourhood(x,userNumber, serverNumber,sub_bandNumber);
            [fx_new, F_new] = Fx(x_new,para);
            delta = fx_new-fx;
            if (delta<0)
                x = x_new;
                J = fx_new;
                X = x;
                F = F_new;
                if fx_new < minimal_cost
                    picture(index,1) = T;
                    picture(index,2) = J;
                    figure
                    plot(picture(:,1),picture(:,2))
                    set(gca,'XDir','reverse');      %��X����ת
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
    plot(picture(:,1),picture(:,2))
    set(gca,'XDir','reverse');      %��X����ת
end
 
function res = getneighbourhood(x,userNumber,serverNumber,sub_bandNumber)
    user = unidrnd(userNumber);     %ָ��Ҫ�Ŷ����û�����
    flag_found = 0;
    for server = 1:serverNumber
        for band=1:sub_bandNumber
            if x(user,server,band) ~= 0
                flag_found = 1;
                break;  %�ҵ��û�������ķ�������Ƶ��
            end
        end
        if flag_found == 1
            break;
        end
    end
    %�����Ŷ���ʽ���������߸�ֵ
    if rand > 0.5   %50%�ĸ��ʸ��ģ�����ԭ����һ����ĳ���û���Ƶ���ͷ����������ȼ�
        if rand > 0.5   %25%�ĸ��ʸ����û��ķ�������ѡ��offload��
            origin = x(user,server,band);     %ȡ��ԭ���ķ���
            for j=1:userNumber
                if x(j,server,band) > origin
                    x(j,server,band) = x(j,server,band) - 1;
                end
            end
            x(user,server,band) = 0;
            vary_server = unidrnd(serverNumber);    %Ŀ�������
            vary_band = randi(sub_bandNumber);    %Ŀ��Ƶ��
            M = max(x(:,vary_server,vary_band));    %��ѯƵ��ռ����
            x(user,vary_server,vary_band) = M+1;
        else 
            if rand > 0.6 %15%�ĸ��ʸ����û���Ƶ����ѡ��offload��
                origin = x(user,server,band);     %ȡ��ԭ���ķ���
                for j=1:userNumber
                    if x(j,server,band) > origin
                        x(j,server,band) = x(j,server,band) - 1;
                    end
                end
                x(user,server,band) = 0;
                vary_band = unidrnd(sub_bandNumber+1)-1;    %Ŀ��Ƶ��
                while vary_band == band
                    vary_band = unidrnd(sub_bandNumber+1)-1;
                end
                if vary_band ~= 0
                    M = max(x(:,server,vary_band));    %��ѯƵ��ռ����
                    x(user,server,vary_band) = M+1;
                end
            else    %10%�ĸ��ʸ����û���Ƶ���е�ʹ�����ȼ�
                M = max(x(:,server,band));    %��ѯƵ��ռ����
                if M ~= 0
                    vary_rank = unidrnd(M+1)-1;     %Ŀ�����ȼ�
                    if x(user,server,band) == 0
                        M = M + 1;
                    end
                    while vary_rank == x(user,server,band)
                        vary_rank = unidrnd(M+1)-1; 
                    end
                    if vary_rank ~= 0
                        found = 0;
                        for user_other=1:userNumber
                            if x(user_other,server,band) == vary_rank
                                found = 1;
                                break;  %�ҵ����ȼ�ΪĿ�����ȼ����û�
                            end
                        end
                        if found == 1
                            x(user_other,server,band) = x(user,server,band);
                        end
                    else
                        for j=1:userNumber
                            if x(j,server,band) > x(user,server,band)
                                x(j,server,band) = x(j,server,band) - 1;
                            end
                        end
                    end
                    x(user,server,band) = vary_rank;
                else
                    x(user,server,band) = 1;
                end
            end
        end
    else 
        if rand > 0.4  %20%�ĸ��ʽ��������û��ķ�������Ƶ��
            user_other = unidrnd(userNumber);    %ָ����һ���û�
            while user_other == user
                user_other = unidrnd(userNumber);
            end
            flag_found = 0;
            for server_other = 1:serverNumber
                for band_other=1:sub_bandNumber
                    if x(user_other,server_other,band_other) ~= 0
                        flag_found = 1;
                        break;  %�ҵ���һ���û�������ķ�������Ƶ��
                    end
                end
                if flag_found == 1
                    break;
                end
            end
            xRank =  x(user,server,band);
            xRank_other =  x(user_other,server_other,band_other);
            x(user,server,band) = 0;
            x(user_other,server_other,band_other) = 0;
            x(user,server_other,band_other) = xRank_other;  %����Ƶ���ͷ�����
            x(user_other,server,band) = xRank;
        else
            if rand > 0.333   %10%�ĸ��ʽ��������û��ķ�������Ƶ��
                x(user,server,band) = 0;
            end
        end
    end
    res = x;
end
 
function p = getProbability(delta,t)
    p=exp(-delta/t);
end

function x = genRandX(userNumber, serverNumber,sub_bandNumber)
%GenRandX  �����Ӿ���ת��ΪX����
    seed = genRandSeed(userNumber, serverNumber,sub_bandNumber);
    x = zeros(userNumber, serverNumber,sub_bandNumber);
    sub_band = ones(sub_bandNumber,serverNumber);
    for user=1:userNumber
        for server=1:serverNumber
            band = seed(user, server);
            if band ~= 0
                x(user, server,band) = sub_band(band,server);
                sub_band(band,server) = sub_band(band,server) + 1;
            end
        end
    end
end

function seed = genRandSeed(userNumber, serverNumber,sub_bandNumber)
%GenRandSeed    ��������Լ����������Ӿ���
    seed = zeros(userNumber, serverNumber);
    for server=1:serverNumber
        if sub_bandNumber >= userNumber
            seed(:,server) = randperm(sub_bandNumber+1,userNumber) - 1;    %Ϊÿ������������������N���û�
        else
            temp = randperm(sub_bandNumber+1,sub_bandNumber) - 1;
            member = randperm(userNumber,sub_bandNumber);
            seed(member,server) = temp;
        end
    end
    for user=1:userNumber
        number = 0;
        notzero = [];
        for server=1:serverNumber   %ͳ�Ƹ�ά���в�Ϊ��Ԫ�ظ���
            if seed(user,server) ~= 0
                number = number + 1;
                notzero(number) = server;
            end
        end
        if number > 1
            chosen = unidrnd(number);
            for server=1:number
                if server~=chosen
                    seed(user,notzero(server)) = 0;
                end
            end
        end
    end
end

function [Jx, F] = Fx(x,para)
    [F,res_cra] = cra(x,para.Fs,para.Eta_user);
    Jx = 0;
    [~,serverNumber,~] = size(x);
    for server = 1:serverNumber
       [Us,n] = genUs(x,server);
        if n > 0
            for user = 1:n
                Kappa = getKappa(x,user,server,para.beta_time,para.beta_enengy,para.Sigma,para.Tu,para.tu_local,para.Eu_local,para.W,para.Hr,para.Pur,para.Ps);
                Pi = getPi(x,user,server,para.beta_time,para.beta_enengy,para.tu_local,para.Eu_local,para.Tu,para.Pu,para.Ht,para.Sigma,para.W);
                Jx = Jx + para.lamda(Us(user)) * (1 - Kappa - Pi);
            end
        end
    end
    Jx = (Jx - res_cra);
end

function Pi = getPi(x,user,server,beta_time,beta_enengy,tu_local,Eu_local,Tu,Pu,Ht,Sigma,W)
%GetPi ����Pi_us
    Pi = beta_time(user)/tu_local(user) + beta_enengy(user)/Eu_local(user)*Pu(user);
    Gamma_us = getGamma(x,Pu,Sigma,Ht,user,server);
    Pi = Pi * Tu(user).data / W / log2(1 + Gamma_us) ;
end

function Gamma = getGamma(G,Pu,Sigma,Ht,user,server)
%GetGamma ����Gamma_us
    Gamma = 0;
    [~,serverNumber,sub_bandNumber] = size(G);
    for sub_band = 1:sub_bandNumber
        denominator = 0;
        for i = 1:serverNumber
            if i ~= server
                [Us,n] = genUs(G,i);
                for k = 1:n
                    denominator = denominator + G(Us(k),i,sub_band) * Pu(Us(k)) * Ht(Us(k),i,sub_band);
                end
            end
        end
        denominator = denominator + Sigma^2;
        Gamma = Pu(user)*Ht(user,server,sub_band)/denominator;
    end
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
