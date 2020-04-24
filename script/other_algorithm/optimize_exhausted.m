function [J, X, F] = optimize_exhausted(Fu,Fs,Tu,W,Pu,H,...
    lamda,Sigma_square,beta_time,beta_enengy,...
    k,...                       % оƬ�ܺ�ϵ��
    userNumber,serverNumber,sub_bandNumber ...
    )

%optimize ����ִ���Ż�����
    tu_local = zeros(userNumber,1);
    Eu_local = zeros(userNumber,1);
    for i = 1:userNumber    %��ʼ���������
        tu_local(i) = Tu(i).circle/Fu(i);   %���ؼ���ʱ�����
        Eu_local(i) = k * (Fu(i))^2 * Tu(i).circle;    %���ؼ����ܺľ���
    end
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
    para.Ht = H;
    para.lamda = lamda;
    para.Pu = Pu;
    para.Sigma_square = Sigma_square;
    para.Fs = Fs;
    para.Eta_user = Eta_user;
    
   [J, X, F] = ta( ...
    userNumber,...              % �û�����
    serverNumber,...            % ����������
    sub_bandNumber,...          % �Ӵ�����
    para ...                    % �������
    );

end

function [J, X, F] = ta( ...
    userNumber,...              % �û�����
    serverNumber,...            % ����������
    sub_bandNumber,...          % �Ӵ�����
    para ...                    % �������
)
%TA Task allocation,��������㷨��������ٷ�

    x = zeros(userNumber, serverNumber,sub_bandNumber);
    
    global array index;
    
    array = struct;
    index = 1;
    
    search(1,x,userNumber,serverNumber,sub_bandNumber,para);
    
    [J,num] = max([array.J]);
    X = array(num).F;
    F = array(num).x;
    
    clear global;
end
 
function search(user,x,userNumber,serverNumber,sub_bandNumber,para)
    global array index;
    if user <= userNumber
        for server = 1:serverNumber
            for band = 1:sub_bandNumber
                x(user,server,band) = 1;
                [J, F] = Fx(x,para);
                array(index).J = J;
                array(index).F = F;
                array(index).x = x;
                index = index + 1;
                search(user+1,x,userNumber,serverNumber,sub_bandNumber,para);
                x(user,server,band) = 0;
            end
        end
    end
end
