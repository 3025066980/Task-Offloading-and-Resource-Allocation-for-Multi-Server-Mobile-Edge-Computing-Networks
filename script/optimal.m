function [G,F,P] = optimal(U,Fu,S,Fs,Tu,sub_band,B,W,Pur,Pu,Ht,Hr,lamda,beta_time,beta_enengy,userNumber,serverNumber,sub_bandNumber)
%����ִ���Ż�����
    tu_local = Tu.circle./Fu;   %���ؼ���ʱ�����
    k = rand;
    Eu_local = k * (Fu.*Fu) * Tu.circle;    %���ؼ����ܺľ���
    Eta_user = zero(userNumber,1)
    for i=1:userNumber
        Eta_user(i) = lamda * Tu(i).circle * lamda(i) / tu_local(i);
    end
end