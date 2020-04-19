function tests = optimizeTest
    tests = functiontests(localfunctions);
end
 
%% testTa
function testOptimize(~)
    userNumber = 50;
    serverNumber = 9;
    sub_bandNumber = 3;
    Fs = 20e9 * ones(serverNumber,1);   %������������������
    Fu = 1e9 * ones(userNumber,1);  %�û�������������
    T0.data = [];   %���������ݴ�С����������ʱ���������������С���
    T0.circle = [];
    Tu = repmat(T0,userNumber);
    parfor i = 1:userNumber    %��ʼ���������
        Tu(i).data = 420 * 1024 * 8;
        Tu(i).circle = 1000e6;
    end
    lamda = ones(userNumber,1);
    beta_time = 0.2 * ones(userNumber,1);
    beta_enengy = ones(userNumber,1) - beta_time;
    
    H = genGain(userNumber,serverNumber,sub_bandNumber,20);   %�û������������������
    Pu = 0.001 * 10^2 * ones(userNumber,1);    %�û�������ʾ���
    
    Sigma_square = 0.001 * 10^(-100/10);
    W = 20e6;   %ϵͳ�ܴ���
    k = 5e-27;
    
    test_time = 5;
    option1_time = zeros(test_time,1);
    option2_time = zeros(test_time,1);
    option1_objective = zeros(test_time,1);
    option2_objective = zeros(test_time,1);
    
%     tic;
%     [J0, ~, ~] = optimize_exhausted(Fu,Fs,Tu,W,Pu,H,...
%     lamda,Sigma_square,beta_time,beta_enengy,...
%     k,...                           % оƬ�ܺ�ϵ��
%     userNumber,serverNumber,sub_bandNumber ...
%     );
%     exhausted_time = toc
%     exhausted_objective = J0
    
    
    for time = 1: test_time
        tic;
        [J1, ~, ~] = ta_model1(Fu,Fs,Tu,W,Pu,H,...
        lamda,Sigma_square,beta_time,beta_enengy,...
        k,...                           % оƬ�ܺ�ϵ��
        userNumber,serverNumber,sub_bandNumber,...
        userNumber/50,...               % ��ʼ���¶�ֵ
        10e-9,...                       % �¶��½�
        0.95,...                        % �¶ȵ��½���
        5 ...                           % �����ռ�Ĵ�С
        );
        option1_time(time) = toc;
        option1_objective(time) = J1;
    end
    
%     for time = 1: test_time
%         tic;
%         [J2, ~, ~] = optimize_greedy(Fu,Fs,Tu,W,Pu,H,...
%         lamda,Sigma_square,beta_time,beta_enengy,...
%         k,...                           % оƬ�ܺ�ϵ��
%         userNumber,serverNumber,sub_bandNumber,...
%         2320 ...                          % ����������
%         );
%         option2_time (time) = toc;
%         option2_objective(time) = J2;
%     end
    
    for time = 1: test_time
        tic;
        [J2, ~, ~] = ta_model3(Fu,Fs,Tu,W,Pu,H,...
        lamda,Sigma_square,beta_time,beta_enengy,...
        k,...                           % оƬ�ܺ�ϵ��
        userNumber,serverNumber,sub_bandNumber,...
        20,...                         % ��ʼ���¶�ֵ
        1e-9,...                        % �¶��½�
        0.96,...                        % �¶ȵ��½���
        3 ...                           % �����ռ�Ĵ�С
        );
        option2_time (time) = toc;
        option2_objective(time) = J2;
    end
    
%     for time = 1: test_time
%         tic;
%         [J2, ~, ~] = ta_model2(Fu,Fs,Tu,W,Pu,H,...
%         lamda,Sigma_square,beta_time,beta_enengy,...
%         k,...                           % оƬ�ܺ�ϵ��
%         userNumber,serverNumber,sub_bandNumber,...
%         1500,...                        % ��ʼ���¶�ֵ
%         500,...                        % ����������
%         0.95,...                        % �¶ȵ��½���
%         5, ...                          % �����ռ�Ĵ�С
%         300 ...                         % ��СĿ��ֵ������ֵԽС������Ӧ��Խ�ߣ�
%         );
%         option2_time (time) = toc;
%         option2_objective(time) = J2;
%     end
    
    option1_time_mean = mean(option1_time)
    option2_time_mean = mean(option2_time)
    option1_time_var = var(option1_time)
    option2_time_var = var(option2_time)
    option1_objective_mean = mean(option1_objective)
    option2_objective_mean = mean(option2_objective)
    option1_objective_var = var(option1_objective)
    option2_objective_var = var(option2_objective)
    %J
    %X
    %F
end