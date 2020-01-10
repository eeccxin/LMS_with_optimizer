function [W, err,err_mean] = LMS_TRAIN(xn, dn, param)  
% xn       输入信号，带有误差的原始信号  
% dn       期望输出  
% param    Structure for using LMS, must include at least  
%          .w        - 初始化权值  
%          .u        - 学习率  
%          .M        - 滤波器阶数  
%          .max_iter - 最大迭代次数  
%  
% W        输出权重
% error    误差输出  

W = param.w;  % 初始权值  
M = param.M;  % 滤波器阶数  
  
if length(W) ~= M  
    error('param.w的长度必须与滤波器阶数相同.\n');  
end  



iter = 1;
N=length(xn)
for i = 1:param.max_iter
    for k = M:N
        x    = xn(k:-1:k-M+1);   % 滤波器M个抽头的输入  
        y    = (W')*x;  
        err(iter)  = dn(k) - y;  
          
        % 更新滤波器权值系数  
        W = W + param.u*(err(iter))*x;  
        iter = iter + 1;
    end  
    err_mean(i)=mean(abs(err(iter-1-(N-M):iter-1))); 


end
mean(abs(err))
end

