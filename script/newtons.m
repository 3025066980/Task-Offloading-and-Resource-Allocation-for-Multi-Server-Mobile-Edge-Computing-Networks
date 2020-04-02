function [x,fval,iter,exitflag]=newtons(fun,grad,var,x0,eps,maxiter)
%NEWTONS ţ�ٷ�Ѱ�Ҿֲ����Ž�
% X=NEWTONS(FUN,X0) ������Է�����ľֲ����Ž�,��ʼ������ΪX0
% X=NEWTONS(FUN,X0,EPS) ������Է�����ľֲ����Ž�,���ֵΪEPS
% X=NEWTONS(FUN,X0,EPS,MAXITER) ������Է�����ľֲ����Ž�,����������ΪMAXITER
%
% [X,FVAL]=NEWTONS(...) ������Է�����ľֲ����ŽⲢ���ؽ⴦�ĺ���ֵ
% [X,FVAL,ITER]=NEWTONS(...) ������Է�����ľֲ����ŽⲢ���ص�������
% [X,FVAL,ITER,EXITFLAG]=NEWTONS(...) ������Է�����ľֲ����ŽⲢ���ص����ɹ���־
%
% �������
% ---FUN, �����Է�����ķ��ű��ʽ
% ---X0, ��ʼ����������
% ---VAR, �Ա���
% ---EPS, ����Ҫ��,Ĭ��ֵΪ1e-6
% ---MAXITER, ����������,Ĭ��ֵΪ1e4
% �������
% ---X, �����Է��̵Ľ��ƽ�����
% ---FVAL, �⴦�ĺ���ֵ
% ---ITER, ��������
% ---EXITFLAG, �����ɹ���־, 1��ʾ�ɹ�,0��ʾʧ��%

    if nargin<5
        eps=1e-6;
    end
    if nargin<6
        maxiter=1e4;
    end
    
    H=hessian(fun,var);
    k=0;
    err=1;
    exitflag=1;
    while err > eps
        k=k+1;
        gi = double(subs(grad,var,x0));
        fx0 = double(subs(fun,var,x0));
        Hi = double(subs(H,var,x0));
        x1 = double(x0- (pinv(Hi) * gi).');
        err = norm(x1-x0);
        x0 = x1;
        if k>=maxiter
            exitflag=0;
            break
        end
    end
    x=x1;
    fval=fx0;
    iter=k;
end
