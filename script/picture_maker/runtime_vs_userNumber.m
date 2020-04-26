clear;
serverNumber = 9;
sub_bandNumber = 3;
Fs = 20e9 * ones(serverNumber,1);   %������������������
T0.data = [];   %���������ݴ�С����������ʱ���������������С���
T0.circle = [];
gapOfServer = 25;
    
%���Բ�ͬ�û����µ��㷨�ļ���ʱ��
index = 1;

annealing_time_mean = zeros(11,1);

annealing_objective_mean = zeros(11,1);
    
for userNumber = 5:10:105
    H = genGain(userNumber,serverNumber,sub_bandNumber,gapOfServer);   %�û������������������
    Fu = 1e9 * ones(userNumber,1);  %�û�������������
    task_circle = 1000e6;
    task_size = 420 * 1024 * 8; %480KB
    Tu = repmat(T0,userNumber,1);
    for i = 1:userNumber    %��ʼ���������
        Tu(i).data = task_size;
        Tu(i).circle = task_circle;
    end
    lamda = ones(userNumber,1);
    beta_time = 0.5 * ones(userNumber,1);
    beta_enengy = ones(userNumber,1) - beta_time;

    Pu = 0.001 * 10^2 * ones(userNumber,1);    %�û�������ʾ���

    Sigma_square = 1e-13;
    W = 20e6;   %ϵͳ�ܴ���
    k = 5e-27;

    test_time = 20;  %ÿ���㷨ѭ������

    annealing_time = zeros(test_time,1);
    annealing_objective = zeros(test_time,1);

    %�˻��㷨
    parfor time = 1: test_time  
    tic;
    [J2,X2,F2] = optimize_annealing(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                           % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber,...
    10e-9,...                       % �¶��½�
    0.97,...                        % �¶ȵ��½���
    5 ...                           % �����ռ�Ĵ�С
    );
    annealing_time(time) = toc;
    annealing_objective(time) = J2;
    end

    annealing_time_mean(index) = mean(annealing_time);
    annealing_objective_mean(index) = mean(annealing_objective);
    
    index = index + 1;
end
   
figure
x =  5:10:105;
plot(x,annealing_time_mean);
xlabel('�û���');
ylabel('ƽ������ʱ��');