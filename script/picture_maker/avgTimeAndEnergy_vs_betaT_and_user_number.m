clear;
serverNumber = 9;
sub_bandNumber = 3;
gapOfServer = 25;
Fs = 20e9 * ones(serverNumber,1);   %������������������

task_circle = 1000e6;
task_size = 420 * 1024 * 8; %480KB
T0.data = [];   %���������ݴ�С����������ʱ���������������С���
T0.circle = [];    

Sigma_square = 1e-13;
W = 20e6;   %ϵͳ�ܴ���
k = 5e-27;

%���Բ�ͬ���ŵ����µ�ƽ��Ŀ�꺯��ֵ
outter_index = 1;

time_mean = zeros(5,3);
energy_mean = zeros(5,3);
    
for beta_t = 0.05:0.15:0.95
    inner_index = 1;
    for userNumber = [20,50,90]
        
        Fu = 1e9 * ones(userNumber,1);  %�û�������������
        lamda = ones(userNumber,1);
        H = genGain(userNumber,serverNumber,sub_bandNumber,gapOfServer);   %�û������������������
        Pu = 0.001 * 10^2 * ones(userNumber,1);    %�û�������ʾ���
        Tu = repmat(T0,userNumber,1);
        for i = 1:userNumber    %��ʼ���������
            Tu(i).data = task_size;
            Tu(i).circle = task_circle;
        end

        beta_time = beta_t * ones(userNumber,1);
        beta_enengy = ones(userNumber,1) - beta_time;

        test_time = 10;  %ÿ���㷨ѭ������

        time_consumption = zeros(test_time,1);
        energy_consumption = zeros(test_time,1);

        %�˻��㷨
        for time = 1: test_time  
            [J2,X2,F2,tconsumption,econsumption] = picture_used_annealing_optimize(Fu,Fs,Tu,W,Pu,H,...
            lamda,Sigma_square,beta_time,beta_enengy,...
            k,...                           % оƬ�ܺ�ϵ��
            userNumber,serverNumber,sub_bandNumber,...
            10e-9,...                       % �¶��½�
            0.97,...                        % �¶ȵ��½���
            5 ...                           % �����ռ�Ĵ�С
            );
            time_consumption(time) = tconsumption/userNumber;
            energy_consumption(time) = econsumption/userNumber;
        end

        time_mean(outter_index,inner_index) = mean(time_consumption);
        energy_mean(outter_index,inner_index) = mean(energy_consumption);
        inner_index = inner_index + 1;
    end
    outter_index = outter_index + 1;
end
   
figure
x = 0.05:0.15:0.95;
plot(x,time_mean(:,1),'-s');
hold on
plot(x,time_mean(:,2),'-o');
hold on
plot(x,time_mean(:,3),'-d');
xlabel('�û���ʱ���ƫ��ֵ');
ylabel('ƽ��ÿ���û��ļ���ʱ��');
grid on
legend('�û���Ϊ20','�û���Ϊ50','�û���Ϊ90');

figure
plot(x,energy_mean(:,1),'-s');
hold on
plot(x,energy_mean(:,2),'-o');
hold on
plot(x,energy_mean(:,3),'-d');
xlabel('�û���ʱ���ƫ��ֵ');
ylabel('ƽ��ÿ���û�����������');
grid on
legend('�û���Ϊ20','�û���Ϊ50','�û���Ϊ90');