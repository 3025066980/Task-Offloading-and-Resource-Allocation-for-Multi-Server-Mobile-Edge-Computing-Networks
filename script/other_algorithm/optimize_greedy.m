function [J, X, F] = optimize_greedy(Fu,Fs,Tu,W,Pu,H,...
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
%TA Task allocation,��������㷨������ģ���˻��㷨

    X = zeros(userNumber, serverNumber,sub_bandNumber);
    
    for user = 1:userNumber
       [~,server,~] = ind2sub(size(X),find(para.Ht == max(para.Ht(user,:,1))));
       if ~isempty(server)
            sub_band = find(~any(X(:,server(1),:)));
            if ~isempty(sub_band)
                X(user,server(1),sub_band(1)) = 1;
            else
                sub_band = randi(sub_bandNumber);
                X(user,server(1),sub_band) = 1;
            end
       end
    end
    [J, F] = Fx(X,para);
end
