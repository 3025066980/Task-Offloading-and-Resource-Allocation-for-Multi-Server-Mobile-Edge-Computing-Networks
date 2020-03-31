function [P,Q] = pra(G,beta_time,beta_enengy,Tu,tu_local,Eu_local,lamda,W,Ht,Pu,Sigma,r,Epsilon,beta)
%uplink power resourses allocation ������·������Դ����
    [userNumber,serverNumber,~] = size(G);
    P = sym('p',[1 userNumber]);   %�û����书�ʷ������
    for server = 1:serverNumber
       [Us,n] = genUs(G,server);
        if n > 0
            for user = 1:n
                Pi = getPi(G,Pu,Sigma,Ht,user,server);
                Phi_user = beta_time(Us(user)) * Tu(Us(user)).data * lamda(Us(user)) / tu_local(Us(user)) / W;
                Theta_user = beta_enengy(Us(user)) * Tu(Us(user)).data * lamda(Us(user)) / Eu_local(Us(user)) / W;
                if server == 1 && user== 1
                    f = ( Phi_user + Theta_user * P(Us(user)) ) / log2( 1 + P(Us(user)) * Pi );
                else
                    f = f + ( Phi_user + Theta_user * P(Us(user)) ) / log2( 1 + P(Us(user)) * Pi );
                end
                if server == 1 && user== 1
                    g = r * ( log(P(Us(user))) + log( Pu(Us(user)) - P(Us(user)) ) );
                else
                    g = g + r * ( log(P(Us(user))) + log( Pu(Us(user)) - P(Us(user)) ) );
                end
                f = f - r * ( log(P(Us(user))) + log( Pu(Us(user)) - P(Us(user)) ) );
            end
        end
    end
    %F = convertToAcceptArray(matlabFunction(f));
    x0 = ones(1,userNumber);
    g = gradient(f);
    %G = convertToAcceptArray(matlabFunction(g));
    while subs(f,P,X0) < Epsilon
        [x1,res,~] = newtons(f,g,x0,100);
        x0 = x1;
        r = beta * r;
    end
    Q = res;
    P = x0;
end

function f = convertToAcceptArray(old_f)
%���������ת��Ϊ�ܽ��վ��������
    function r = new_f(X)
        X = num2cell(X);
        r = old_f(X{:});
    end
    f = @new_f;
end
