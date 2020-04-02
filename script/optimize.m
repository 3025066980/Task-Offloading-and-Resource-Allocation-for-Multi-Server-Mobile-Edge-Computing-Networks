function [J, X, P, F] = optimize(Fu,Fs,Tu,W,Pur,Pu,Ps,Ht,Hr,lamda,Sigma,Epsilon,beta,r,beta_time,beta_enengy,userNumber,serverNumber,sub_bandNumber)
%optimize ����ִ���Ż�����
    tu_local = zeros(userNumber,1);
    for i = 1:userNumber    %��ʼ���������
        tu_local(i) = Tu(i).circle/Fu(i);   %���ؼ���ʱ�����
    end
    k = rand;
    Eu_local = k * (Fu.*Fu) * Tu.circle;    %���ؼ����ܺľ���
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
    
   [J, X, P, F] = ta( ...
    userNumber,...              % �û�����
    serverNumber,...            % ����������
    sub_bandNumber,...          % �Ӵ�����
    T,...                       % ��ʼ���¶�ֵ
    T_min,...                   % �¶��½�
    alpha,...                   % �¶ȵ��½���
    k, ...                      % �����ռ�Ĵ�С
    minimal_cost,...            % ��СĿ��ֵ������ֵԽС������Ӧ��Խ�ߣ�
    para...                     % �������
    );

end