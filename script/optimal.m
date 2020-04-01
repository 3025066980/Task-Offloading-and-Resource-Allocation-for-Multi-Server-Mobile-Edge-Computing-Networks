function [J, X, P, F] = optimize(Fu,Fs,Tu,G,B,W,Pur,Pu,Ht,Hr,lamda,beta_time,beta_enengy,userNumber,serverNumber,sub_bandNumber)
%optimize ����ִ���Ż�����
    tu_local = Tu.circle./Fu;   %���ؼ���ʱ�����
    k = rand;
    Eu_local = k * (Fu.*Fu) * Tu.circle;    %���ؼ����ܺľ���
    Eta_user = zero(userNumber,1);
    for i=1:userNumber  %����CRA����Ħ�
        Eta_user(i) = lamda * Tu(i).circle * lamda(i) / tu_local(i);
    end
    
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