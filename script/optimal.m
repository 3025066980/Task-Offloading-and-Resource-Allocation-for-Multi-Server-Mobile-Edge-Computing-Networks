function [G,F,P] = optimal(U,Fu,S,Fs,Tu,B,W,Pur,Pu,Ht,Hr,lamda,beta_time,beta_enengy)
%����ִ���Ż�����
    [userNumber,serverNumber,sub_bandNumber] = size(G);
    tu_local = Tu.circle./Fu;   %���ؼ���ʱ�����
    k = rand;
    Eu_local = k * (Fu.*Fu) * Tu.circle;    %���ؼ����ܺľ���
    Eta_user = zero(userNumber,1);
    for i=1:userNumber  %����CPA����Ħ�
        Eta_user(i) = lamda * Tu(i).circle * lamda(i) / tu_local(i);
    end
end