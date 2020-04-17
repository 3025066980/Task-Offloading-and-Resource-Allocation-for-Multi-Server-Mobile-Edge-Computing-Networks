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
    for i = 1:userNumber    %��ʼ���������
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
    
    tic;
    [J, X, F] = optimize(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                           % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber,...
    1500,...                        % ��ʼ���¶�ֵ
    1e-8,...                        % �¶��½�
    0.95,...                        % �¶ȵ��½���
    5, ...                          % �����ռ�Ĵ�С
    300 ...                         % ��СĿ��ֵ������ֵԽС������Ӧ��Խ�ߣ�
    );
    toc;
    
    %J
    %X
    %F
end