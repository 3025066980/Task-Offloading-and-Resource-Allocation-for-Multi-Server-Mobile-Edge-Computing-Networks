%�������
%������������
userNumber = 100;   %�û�����
U = 1:userNumber;   %�û�����
Fu = 4 * rand(userNumber,1);    %�û�������������
serverNumber = 10;  %����������
S = 1:serverNumber; %����������
Fs = 10 + 40 * rand(userNumber,1);  %������������������
T0.data = [];   %���������ݴ�С����������ʱ���������������С���
T0.circle = [];
T0.output = [];
Tu = repmat(T0,userNumber);
for i = 1:userNumber    %��ʼ���������
    Tu(i).data = 10 + 40 * rand;
    Tu(i).circle = 40 * rand;
    Tu(i).output = 4 * rand;
end
W = 20e6;   %ϵͳ�ܴ���
sub_bandNumber = 10;    %�Ӵ�����
sub_band = 1:sub_bandNumber;    %�Ӵ�����
Ground = zeros(userNumber,serverNumber,sub_bandNumber);  %Ƶ���ͷ������������
Pu = zeros(userNumber,1);    %�û����������ʾ���
for i = 1:userNumber
    Pu(i) = 10 + 40 * rand;
end
Pur = ones(userNumber,1);   %�û����չ��ʾ���
Ps = ones(userNumber,1);    %���������书�ʾ���
for i = 1:userNumber
    Pu(i) = 10 + 40 * rand;
end
Ht = rand(userNumber,serverNumber,sub_bandNumber);   %�û������������������
Hr = rand(userNumber,serverNumber,sub_bandNumber);   %���������û����������
lamda = rand(userNumber,1);
Sigma = rand(userNumber,1);
Epsilon = rand(userNumber,1);
beta = rand(userNumber,1);
r = rand(userNumber,1);
beta_time = rand(userNumber,1);
beta_enengy = ones(userNumber,1) - beta_time;
[   J,...   %�����Զ���
    X,...   %Ƶ���ͷ������������
    F,...   %������������Դ�������
    P...    %�û����书�ʷ������
    ] = optimize(Fu,Fs,Tu,W,Pur,Pu,Ps,Ht,Hr,lamda,Sigma,Epsilon,beta,r,beta_time,beta_enengy,userNumber,serverNumber,sub_bandNumber);