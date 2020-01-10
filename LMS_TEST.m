function [yn,err] = LMS_TEST(xn1,xn, W, M) 
% xn1      输入信号，带有误差的原始信号  
% xn       期望信号
% W        滤波器使用的权重系数    
% M        - 滤波器阶数
%  
% yn       滤波之后的输出 


% 求最优时滤波器的输出序列  
yn = inf * ones(size(xn1));  
for k = M:length(xn1)  
    x = xn1(k:-1:k-M+1);  
    yn(k) = (W')* x;
    err(k)=xn(k)-yn(k);
end 

end
