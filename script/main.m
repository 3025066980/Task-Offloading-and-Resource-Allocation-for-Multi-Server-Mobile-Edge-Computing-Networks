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
B = 20e6;   %ϵͳ�ܴ���
sub_bandNumber = 10;    %�Ӵ�����
W = B/sub_bandNumber;   %�Ӵ���С
sub_band = 1:sub_bandNumber;    %�Ӵ�����
Ground = zeros(userNumber,serverNumber,sub_bandNumber);  %Ƶ���ͷ������������
Pu = zeros(userNumber,1);    %�û����������ʾ���
for i = 1:userNumber
    Pu(i) = 10 + 40 * rand;
end
Pur = zeros(userNumber,1);   %�û����չ��ʾ���
for i = 1:userNumber
    Pu(i) = 10 + 40 * rand;
end
Ht = rand(userNumber,serverNumber,sub_bandNumber);   %�û������������������
Hr = rand(userNumber,serverNumber,sub_bandNumber);   %���������û����������
F = zeros(userNumber,serverNumber);  %������������Դ�������
P = zeros(userNumber,1); %�û����书�ʷ������
[G,F,P] = optimal(U,Fu,S,Su,Tu,sub_band,B,W,Pur,Pu,Ht,Hr,userNumber,serverNumber,sub_bandNumber);