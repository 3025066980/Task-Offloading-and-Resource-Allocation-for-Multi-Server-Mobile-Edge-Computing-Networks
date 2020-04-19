function [J, X, F] = ta_model3(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                       % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber,...
    T,...                       % ��ʼ���¶�ֵ
    T_min,...                   % �¶��½�
    alpha,...                   % �¶ȵ��½���
    n ...                      % �����ռ�Ĵ�С
    )

%optimize ����ִ���Ż�����������˻�ʽ
    tu_local = zeros(userNumber,1);
    Eu_local = zeros(userNumber,1);
    for i = 1:userNumber    %��ʼ���������
        tu_local(i) = Tu(i).circle/Fu(i);   %���ؼ���ʱ�����
        Eu_local(i) = k * (Fu(i))^2 * Tu(i).circle;    %���ؼ����ܺľ���
    end
    Eta_user = zeros(userNumber,1);
    for i=1:userNumber  %����CRA����Ħ�
        Eta_user(i) = beta_time(i) * Tu(i).circle * lamda(i) / tu_local(i);
    end
    
    %��װ����
    para.beta_time = beta_time;
    para.beta_enengy = beta_enengy;
    para.Tu = Tu;
    para.tu_local = tu_local;
    para.Eu_local = Eu_local;
    para.W = W;
    para.Ht = H;
    para.lamda = lamda;
    para.Pu = Pu;
    para.Sigma_square = Sigma_square;
    para.Fs = Fs;
    para.Eta_user = Eta_user;
    
   [J, X, F] = ta( ...
    userNumber,...              % �û�����
    serverNumber,...            % ����������
    sub_bandNumber,...          % �Ӵ�����
    T,...                       % ��ʼ���¶�ֵ
    T_min,...                   % �¶��½�
    alpha,...                   % �¶ȵ��½���
    n, ...                      % �����ռ�Ĵ�С
    para...                    % �������
    );

end

function [max_objective, X, F] = ta( ...
    userNumber,...              % �û�����
    serverNumber,...            % ����������
    sub_bandNumber,...          % �Ӵ�����
    T,...                       % ��ʼ���¶�ֵ
    T_min,...                   % �¶��½�
    alpha,...                   % �¶ȵ��½���
    k, ...                      % �����ռ�Ĵ�С
    para...                    % �������
)
%TA Task allocation,��������㷨������ģ���˻��㷨

    %T=1000;         
    %T_min=1e-12;    
    %alpha=0.98;     
    %k=1000;         

    x_old= genOriginX(userNumber, serverNumber,sub_bandNumber,para);    %�õ���ʼ��
    
    picture = zeros(2,1);
    iterations = 1;
    
    max_objective = 0;
    
    [fx_old, F] = Fx(x_old,para);
    
    while(T>T_min)
        for I=1:k
            x_new = getneighbourhood(x_old,userNumber, serverNumber,sub_bandNumber);
            [fx_new, F_new] = Fx(x_new,para);
            delta = fx_new-fx_old;
            if (delta>0)
                x_old = x_new;
                fx_old = fx_new;
                if fx_new > max_objective
                    max_objective = fx_new;
                    X = x_new;
                    F = F_new;
                end
            else
                pro=getProbability(delta,T);
                if(pro>rand)
                    x_old = x_new;
                    fx_old = fx_new;
                end
            end
        end
        picture(iterations,1) = T;
        picture(iterations,2) = fx_old;
        iterations = iterations + 1;
        if iterations <= 7
             T=T/log(1+iterations);
        else
             T=T*alpha;
        end
    end
    figure
    plot(picture(:,1),picture(:,2),'b-.');
    set(gca,'XDir','reverse');      %��X����ת
    title('ģ���˻��㷨������������Ż�');
    xlabel('�¶�T');
    ylabel('Ŀ�꺯��ֵ');
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
    if chosen > 0.2
        if chosen < 0.75   %55%�ĸ��ʸ����û��ķ�������ѡ��offload��
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
        if chosen > 0.05  %15%�ĸ��ʽ��������û��ķ�������Ƶ��
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
        else    %5%�ĸ��ʸı���û��ľ���
            x(user,server,band) = 1 - x(user,server,band);
        end
    end
    res = x;
end
 
function p = getProbability(delta,t)
    p = exp(delta/t);
end

function seed = genOriginX(userNumber, serverNumber,sub_bandNumber,para)
%GenRandSeed    ��������Լ����������Ӿ���
    seed = zeros(userNumber, serverNumber,sub_bandNumber);
    old_J = 0;
    for user=1:userNumber
        find = 0;
        for server=1:serverNumber
            if find == 1
                break;
            end
            for band=1:sub_bandNumber
                seed(user,server,band) = 1;
                new_J = Fx(seed,para);
                if new_J > old_J
                    old_J = new_J;
                    find = 1;
                    break;
                else
                    seed(user,server,band) = 0;
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

