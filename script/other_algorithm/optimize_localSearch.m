function [J, X, F] = optimize_localSearch(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                       % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber,...
    maxtime ...                 % ����������
    )

%optimize ����ִ���Ż��������ֲ������㷨
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
    
%     p = [-5.32758370173747e-36,1.09167336016681e-32,-1.03802502719758e-29,6.07935588719153e-27,-2.45478823556481e-24,7.24877156748154e-22,-1.62027614166011e-19,2.79969318773410e-17,-3.78649533020796e-15,4.03403674219988e-13,-3.39081920039635e-11,2.24284299382135e-09,-1.15967362545011e-07,4.63633298897616e-06,-0.000141072653394454,0.00319619818685363,-0.0523399612167956,0.595502552120247,-4.49373884727681,22.4592906556806,308.641802772312];
%     maxtime = polyval(p,userNumber);

    maxtime = 5 * log(1e-9/50)/log(0.97);
    
   [J, X, F] = ta( ...
    userNumber,...              % �û�����
    serverNumber,...            % ����������
    sub_bandNumber,...          % �Ӵ�����
    para,...                    % �������
    maxtime ...                 % ����������
    );

end

function [J, X, F] = ta( ...
    userNumber,...              % �û�����
    serverNumber,...            % ����������
    sub_bandNumber,...          % �Ӵ�����
    para,...                    % �������
    maxtime ...                 % ����������
)
%TA Task allocation,��������㷨�����þֲ������㷨

%     X = genOriginX(userNumber, serverNumber,sub_bandNumber,para);    %����õ���ʼ��
    
    X = zeros(userNumber, serverNumber,sub_bandNumber);
    
    [fx, F] = Fx(X,para);
    J = fx;
    
    picture = zeros(2,1);
    iterations = 1;
    
    while(iterations<maxtime)
        x_new  = getneighbourhood(X,userNumber, serverNumber,sub_bandNumber);
        [fx_new, F_new] = Fx(x_new,para);
        delta = fx_new-fx;
        if (delta>0)
            X = x_new;
            fx = fx_new;
            J = fx_new;
            F = F_new;
        end
        picture(iterations,1) = iterations;
        picture(iterations,2) = J;
        if iterations > 100 && var(picture(end-100:end,2)) < 1e-6
            break
        end
        iterations = iterations + 1;
    end
%     figure
%     plot(picture(:,1),picture(:,2),'b-.');
%     title('�ֲ������㷨������������Ż�');
%     xlabel('��������');
%     ylabel('Ŀ�꺯��ֵ');
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

