function tests = taTest
    tests = functiontests(localfunctions);
end
 
%% testTa
function testTa(~)
    userNumber = 3;
    serverNumber = 2;
    sub_bandNumber = 1;
    Fs = 10 + 40 * rand(serverNumber,1);  %������������������
    Fu = 10 + 40 * rand(userNumber,1);  %�û�������������
    T0.data = [];   %���������ݴ�С����������ʱ���������������С���
    T0.circle = [];
    T0.output = [];
    Tu = repmat(T0,userNumber);
    tu_local = zeros(userNumber,1);
    Eu_local = zeros(userNumber,1);
    k = rand;
    for i = 1:userNumber    %��ʼ���������
        Tu(i).data = 10 + 40 * rand;
        Tu(i).circle = 40 * rand;
        Tu(i).output = 4 * rand;
        tu_local(i) = Tu(i).circle/Fu(i);   %���ؼ���ʱ�����
        Eu_local(i) = k * (Fu(i))^2 * Tu(i).circle;    %���ؼ����ܺľ���
    end
    Eta_user = zeros(userNumber,1);
    lamda = rand(userNumber,1);
    beta_time = rand(userNumber,1);
    beta_enengy = ones(userNumber,1) - beta_time;
    for i=1:userNumber  %����CRA����Ħ�
        Eta_user(i) = beta_time(i) * Tu(i).circle * lamda(i) / tu_local(i);
    end
    Ht = rand(userNumber,serverNumber,sub_bandNumber);   %�û������������������
    Hr = rand(userNumber,serverNumber,sub_bandNumber);
    Pu = ones(userNumber,1);    %�û�������ʾ���
    Pur = ones(userNumber,1);   %�û����չ��ʾ���
    Ps = ones(userNumber,1);    %���������书�ʾ���
    
    Sigma = rand;
    Epsilon = 0.001*rand;
    beta = rand;
    r = 0.001*rand;
    W = 20e6;   %ϵͳ�ܴ���
    
    
    para.beta_time = beta_time;
    para.beta_enengy = beta_enengy;
    para.Tu = Tu;
    para.tu_local = tu_local;
    para.Eu_local = Eu_local;
    para.W = W;
    para.Hr = Hr;
    para.Ht = Ht;
    para.Pur = Pur;
    para.Ps = Ps;
    para.lamda = lamda;
    para.Pu = Pu;
    para.Sigma = Sigma;
    para.r = r;
    para.Epsilon = Epsilon;
    para.beta = beta;
    para.Fs = Fs;
    para.Eta_user = Eta_user;
    
   [J, X, F] = ta( ...
    userNumber,...              % �û�����
    serverNumber,...            % ����������
    sub_bandNumber,...          % �Ӵ�����
    1,...                       % ��ʼ���¶�ֵ
    0.1,...                     % �¶��½�
    0.95,...                    % �¶ȵ��½���
    3, ...                      % �����ռ�Ĵ�С
    40,...                     % ��СĿ��ֵ������ֵԽС������Ӧ��Խ�ߣ�
    para...                     % �������
    );
    
    J
    X
    F
end