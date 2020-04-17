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
            if (delta>0)
                x = x_new;
                J = fx_new;
                X = x;
                F = F_new;
                if fx_new > minimal_cost
                    picture(index,1) = T;
                    picture(index,2) = J;
                    figure
                    title('ģ���˻��㷨������������Ż�');
                    xlabel('�¶�T');
                    ylabel('Ŀ�꺯��ֵ');
                    plot(picture(:,1),picture(:,2),'b-.')
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
    title('ģ���˻��㷨������������Ż�');
    xlabel('�¶�T');
    ylabel('Ŀ�꺯��ֵ');
    plot(picture(:,1),picture(:,2),'b-.');
    set(gca,'XDir','reverse');      %��X����ת
end
 
function res = getneighbourhood(x,userNumber,serverNumber,sub_bandNumber)
    user = unidrnd(userNumber);     %ָ��Ҫ�Ŷ����û�����
    flag_found = 0;
    for server = 1:serverNumber
        for band = 1:sub_bandNumber
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
    chosen = rand;
    if chosen > 0.3   %50%�ĸ��ʸ��ģ�����ԭ����һ����ĳ���û���Ƶ���������
        if chosen > 0.75   %45%�ĸ��ʸ����û��ķ�������ѡ��offload��
            x(user,server,band) = 0;
            vary_server = unidrnd(serverNumber);    %Ŀ�������
            vary_band = randi(sub_bandNumber);    %Ŀ��Ƶ��
            x(user,vary_server,vary_band) = 1;
        else    %25%�ĸ��ʸ����û���Ƶ����ѡ��offload��
            if sub_bandNumber ~= 1
                x(user,server,band) = 0;
                vary_band = unidrnd(sub_bandNumber);    %Ŀ��Ƶ��
                while vary_band == band
                    vary_band = unidrnd(sub_bandNumber);
                end
                x(user,server,vary_band) = 1;
            end
        end
    else 
        if chosen > 0.2  %10%�ĸ��ʽ��������û��ķ�������Ƶ��
            if userNumber ~= 1
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
                xValue =  x(user,server,band);
                xValue_other =  x(user_other,server_other,band_other);
                x(user,server,band) = 0;
                x(user_other,server_other,band_other) = 0;
                x(user,server_other,band_other) = xValue_other;  %����Ƶ���ͷ�����
                x(user_other,server,band) = xValue;
            end
        else    %20%�ĸ��ʸı���û��ľ���
            x(user,server,band) = 1 - x(user,server,band);
        end
    end
    res = x;
end
 
function p = getProbability(delta,t)
    k = 1e-3;
    p=exp(delta/(k*t));
end

function x = genRandX(userNumber, serverNumber,sub_bandNumber)
%GenRandX  �����Ӿ���ת��ΪX����
    seed = genRandSeed(userNumber, serverNumber,sub_bandNumber);
    x = zeros(userNumber, serverNumber,sub_bandNumber);
    for user=1:userNumber
        for server=1:serverNumber
            if seed(user, server) ~= 0
                x(user, server, seed(user, server)) = 1;
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
    [~,serverNumber,sub_bandNumber] = size(x);
    for server = 1:serverNumber
        [Us,n] = genUs(x,server);
        multiplexingNumber = zeros(sub_bandNumber,1);
        for band = 1:sub_bandNumber
            multiplexingNumber(band) = sum(x(:,server,band));
        end
        if n > 0
            for user = 1:n
                Pi = getPi(x,user,server,Us(user,2),sub_bandNumber,multiplexingNumber(Us(user,2)),para.beta_time,para.beta_enengy,para.tu_local,para.Eu_local,para.Tu,para.Pu,para.Ht,para.Sigma_square,para.W);
                Jx = Jx + para.lamda(Us(user,1)) * (1 - Pi);
            end
        end
    end
    Jx = (Jx - res_cra);
end

function Pi = getPi(x,user,server,band,sub_bandNumber,multiplexingNumber,beta_time,beta_enengy,tu_local,Eu_local,Tu,Pu,Ht,Sigma_square,W)
%GetPi ����Pi_us
    B = W / sub_bandNumber;
    Pi = beta_time(user)/tu_local(user) + beta_enengy(user)/Eu_local(user)*Pu(user);
    Gamma_us = getGamma(x,Pu,Sigma_square,Ht,user,server,band);
    Pi = Pi * Tu(user).data / B / log2(1 + Gamma_us) / multiplexingNumber;
end

function Gamma = getGamma(G,Pu,Sigma_square,H,user,server,band)
%GetGamma ����Gamma_us
    [~,serverNumber,~] = size(G);
    denominator = 0;
    for i = 1:serverNumber
        if i ~= server
            [Us,n] = genUs(G,i);
            for k = 1:n
                denominator = denominator + G(Us(k,1),i,band) * Pu(Us(k,1)) * H(Us(k,1),i,band);
            end
        end
    end
    denominator = denominator + Sigma_square;
    Gamma = Pu(user)*H(user,server,band)/denominator;
end

