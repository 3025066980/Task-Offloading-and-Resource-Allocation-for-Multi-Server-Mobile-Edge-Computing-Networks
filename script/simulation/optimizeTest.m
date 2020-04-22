function tests = optimizeTest
    tests = functiontests(localfunctions);
end
 
%% testTa
function testOptimize(~)
    userNumber = 12;
    serverNumber = 4;   %����һ���ܿ���������
    sub_bandNumber = 2;
    Fs = 20e9 * ones(serverNumber,1);   %������������������
    Fu = 1e9 * ones(userNumber,1);  %�û�������������
    T0.data = [];   %���������ݴ�С����������ʱ���������������С���
    T0.circle = [];
    Tu = repmat(T0,userNumber,1);
    parfor i = 1:userNumber    %��ʼ���������
        Tu(i).data = 420 * 1024 * 8;
        Tu(i).circle = 1000e6;
    end
    lamda = ones(userNumber,1);
    beta_time = 0.2 * ones(userNumber,1);
    beta_enengy = ones(userNumber,1) - beta_time;
    
    gapOfServer = 25;
    H = genGain(userNumber,serverNumber,sub_bandNumber,gapOfServer);   %�û������������������
    Pu = 0.001 * 10^2 * ones(userNumber,1);    %�û�������ʾ���
    
    Sigma_square = 1e-13;
    W = 20e6;   %ϵͳ�ܴ���
    k = 5e-27;
    
    %���Ը����㷨������
    
    test_time = 10;  %ÿ���㷨ʹ�ô���
    annealing_time = zeros(test_time,1);
    ta_model2_time = zeros(test_time,1);
    ta_model3_time = zeros(test_time,1);
    localSearch_time = zeros(test_time,1);
    annealing_objective = zeros(test_time,1);
    ta_model2_objective = zeros(test_time,1);
    ta_model3_objective = zeros(test_time,1);
    localSearch_objective = zeros(test_time,1);
    
    %��ٷ�
%     tic;
%     [J0, ~, ~] = optimize_exhausted(Fu,Fs,Tu,W,Pu,H,...
%     lamda,Sigma_square,beta_time,beta_enengy,...
%     k,...                           % оƬ�ܺ�ϵ��
%     userNumber,serverNumber,sub_bandNumber ...
%     );
%     exhausted_time = toc
%     exhausted_objective = J0
     
    %������˻��㷨
%     for time = 1: test_time
%         tic;
%         [J1,X1,F1] = optimize_annealing(Fu,Fs,Tu,W,Pu,H,...
%         lamda,Sigma_square,beta_time,beta_enengy,...
%         k,...                           % оƬ�ܺ�ϵ��
%         userNumber,serverNumber,sub_bandNumber,...
%         10e-9,...                       % �¶��½�
%         0.95,...                        % �¶ȵ��½���
%         5 ...                           % �����ռ�Ĵ�С
%         );
%         annealing_time (time) = toc;
%         annealing_objective(time) = J1;
%     end
    
    %���õ�����������ѭ���жϵ��˻��㷨
%     for time = 1: test_time
%         tic;
%         [J2,X2,F2] = ta_model2(Fu,Fs,Tu,W,Pu,H,...
%         lamda,Sigma_square,beta_time,beta_enengy,...
%         k,...                           % оƬ�ܺ�ϵ��
%         userNumber,serverNumber,sub_bandNumber,...
%         userNumber,...                  % ��ʼ���¶�ֵ
%         1500,...                        % ����������
%         0.95,...                        % �¶ȵ��½���
%         5 ...                           % �����ռ�Ĵ�С
%         );
%         ta_model2_time (time) = toc;
%         ta_model2_objective(time) = J2;
%     end
    
    %��Ͻ��µ�ģ���˻��㷨
%     for time = 1: test_time
%         tic;
%         [J3,X3,F3] = ta_model3(Fu,Fs,Tu,W,Pu,H,...
%         lamda,Sigma_square,beta_time,beta_enengy,...
%         k,...                           % оƬ�ܺ�ϵ��
%         userNumber,serverNumber,sub_bandNumber,...
%         10e-9,...                       % �¶��½�
%         0.95,...                        % �¶ȵ��½���
%         5 ...                           % �����ռ�Ĵ�С
%         );
%         ta_model3_time(threshold-2,time) = toc;
%         ta_model3_objective(threshold-2,time) = J3;
%     end
    
    %�ֲ������㷨
%     for time = 1: test_time
%         tic;
%         [J4,X4,F4] = optimize_localSearch(Fu,Fs,Tu,W,Pu,H,...
%         lamda,Sigma_square,beta_time,beta_enengy,...
%         k,...                           % оƬ�ܺ�ϵ��
%         userNumber,serverNumber,sub_bandNumber,...
%         2320 ...                          % ����������
%         );
%         localSearch_time (time) = toc;
%         localSearch_objective(time) = J3;
%     end

%     annealing_time_mean = mean(annealing_time)
%     ta_model2_time_mean = mean(ta_model2_time)
%     ta_model3_time_mean = mean(ta_model3_time)
%     localSearch_time_mean = mean(localSearch_time)
%     annealing_time_var = var(annealing_time)
%     ta_model2_time_var = var(ta_model2_time)
%     ta_model3_time_var = var(ta_model3_time)
%     localSearch_time_var = var(localSearch_time)
%     annealing_objective_mean = mean(annealing_objective)
%     ta_model2_objective_mean = mean(ta_model2_objective)
%     ta_model3_objective_mean = mean(ta_model3_objective)
%     localSearch_objective_mean = mean(localSearch_objective)
%     annealing_objective_var = var(annealing_objective)
%     ta_model2_objective_var = var(ta_model2_objective)
%     ta_model3_objective_var = var(ta_model3_objective)
%     localSearch_objective_var = var(localSearch_objective)
    
    %���β���
    tic;
    [J0,X0,F0] = optimize_hJTORA(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                           % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber ...
    );
    hJTORA_time = toc
    hJTORA_objective = J0
 
%     tic;
%     [J1,X1,F1] = optimize_annealing(Fu,Fs,Tu,W,Pu,H,...
%     lamda,Sigma_square,beta_time,beta_enengy,...
%     k,...                           % оƬ�ܺ�ϵ��
%     userNumber,serverNumber,sub_bandNumber,...
%     10e-9,...                       % �¶��½�
%     0.95,...                        % �¶ȵ��½���
%     5 ...                           % �����ռ�Ĵ�С
%     );
%     annealing_time = toc
%     annealing_objective = J1
    
    tic;
    [J2,X2,F2] = ta_model3(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                           % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber,...
    10e-9,...                       % �¶��½�
    0.95,...                        % �¶ȵ��½���
    5 ...                           % �����ռ�Ĵ�С
    );
    model3_time = toc
    model3_objective = J2

    tic;
    [J3,X3,F3] = optimize_greedy(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                           % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber ...
    );
    greedy_time = toc
    greedy_objective = J3

    tic;
    [J4,X4,F4] = optimize_localSearch(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                           % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber,...
    10 ...                         % ����������
    );
    localSearch_time  = toc
    localSearch_objective = J4
    
    tic;
    [J5,X5,F5] = optimize_exhausted(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                           % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber...
    );
    exhausted_time (time) = toc;
    exhausted_objective(time) = J5;

%     x = [1 2 3];
%     vals = [2 3 6; 11 23 26];
%     b = bar(x,vals);

end