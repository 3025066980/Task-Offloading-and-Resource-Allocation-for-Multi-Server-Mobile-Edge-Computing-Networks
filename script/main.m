%�������
%������������
userNumber = 20;
serverNumber = 2;
sub_bandNumber = 7;
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
Pu = ones(userNumber,1);    %�û����������ʾ���
Pur = ones(userNumber,1);   %�û����չ��ʾ���
Ps = ones(userNumber,1);    %���������书�ʾ���

Sigma = rand;
Epsilon = 0.001*rand;
beta = rand;
r = 0.001*rand;
W = 20e6;   %ϵͳ�ܴ���
k = rand;

[J, X, P, F] = optimize(Fu,Fs,Tu,W,Pur,Pu,Ps,Ht,Hr,...
lamda,Sigma,Epsilon,beta,r,beta_time,beta_enengy,...
k,...                       % оƬ�ܺ�ϵ��
userNumber,serverNumber,sub_bandNumber,...
1,...                       % ��ʼ���¶�ֵ
0.1,...                   % �¶��½�
0.9,...                   % �¶ȵ��½���
3, ...                      % �����ռ�Ĵ�С
-30 ...             % ��СĿ��ֵ������ֵԽС������Ӧ��Խ�ߣ�
);