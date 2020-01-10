clc;  
clear;
close all;  

%%
N1=1:500;
N2=501:1000;

x = [sin(2*pi*0.015*N1),0.5*sin(2*pi*0.015*N2)]; %1*N
x = x(:);  %size N*1
sx = size(x,1);  
  
subplot(3,2,1);  
plot(x);
title('原信号/期望信号 d(n)');
xlabel('抽样点N');
axis([0 sx -2 2]);  

  
% 添加高斯噪声   
noise = 0.2*randn(size(x));  % 均值为0，方差为0.5的标准正态噪声  
x1 = x + noise;  
subplot(3,2,2);  
plot(x1);
title('带噪信号x(n)');
xlabel('抽样点N');
axis([0 sx -2 2]);  

  

% %再造一个带有噪声的输入信号 lunge
noise = 0.2*randn(size(x));  % 均值为0，方差为0.5的标准正态噪声  
x2 = x + noise; 
% figure,  
% plot(x2)
  
%% LMS自适应滤波  
param.M        = 32;  
param.w        = ones(param.M, 1) * 0.1;  
param.u        = 0.002;  
param.max_iter = 100;  
param.min_err  = 0.01;
 


[W, err,err_mean] = LMS_TRAIN(x1, x, param);
[W_1, err_1,err_mean_1] = LMS_with_AdaGrad_TRAIN(x1, x, param);
[W_2, err_2,err_mean_2] = LMS_with_RMSProp_TRAIN(x1, x, param);
[W_3, err_3,err_mean_3] = LMS_with_adam_TRAIN(x1, x, param);

%%测试
% x2为测试集
% x2 = x1;
[yn,err] = LMS_TEST(x1,x, W, param.M);
[yn_1,err_1] = LMS_TEST(x1,x, W_1, param.M);
[yn_2,err_2] = LMS_TEST(x1,x, W_2, param.M);
[yn_3,err_3] = LMS_TEST(x1,x, W_3, param.M);

%%画出期望信号、带噪信号和四种算法滤波后的信号  
subplot(3,2,3);
plot(yn,'-');
title('LMS输出y(n)');
xlabel('抽样点N');
subplot(3,2,4);
plot(yn_1,'-')
title('AdaGrad输出y(n)');
xlabel('抽样点N');
subplot(3,2,5);
plot(yn_2,'-')
title('RMSProp输出y(n)');
xlabel('抽样点N');
subplot(3,2,6);
plot(yn_3,'-')
title('Adam输出y(n)');
xlabel('抽样点N');

%%画出训练过程中的平均误差
figure
plot(err_mean,'-');
hold on
plot(err_mean_1,'.-');
plot(err_mean_2,'*-');
plot(err_mean_3,'--');
axis([0 param.max_iter 0 0.2]);
legend({'LMS','AdaGrad','RMSProp','Adam'});
xlabel('迭代周期');
title('训练平均err');

%%画出测试误差 
figure
subplot(2,2,1)
plot(abs(err),'-');
xlabel('抽样点N');
axis([0 sx 0 0.2]);  
title('LMS测试误差err');
% hold on
subplot(2,2,2)
plot(abs(err_1),'-');
xlabel('抽样点N');
axis([0 sx 0 0.2]);  
title('AdaGrad测试误差err');
subplot(2,2,3)
plot(abs(err_2),'-');
xlabel('抽样点N');
axis([0 sx 0 0.2]);  
title('RMSProp测试误差err');
subplot(2,2,4)
plot(abs(err_3),'-');
xlabel('抽样点N');
axis([0 sx 0 0.2]);  
title('Adam测试误差err');


 
