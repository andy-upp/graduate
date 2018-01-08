% layers=1:10;
% rmse_2=[23.6277	21.9592	20.1993	19.6858	17.9334	15.9849	13.7434	9.57052	8.38092	8.09834
% ];
% rmse_3=[3.65621	2.77304	2.7908	2.78507	2.28492	2.37031	2.59633	2.17535	2.16501	1.91767
% ];
% rmse_4=[2.69865	2.07223	1.89261	1.80978	1.28196	1.22726	0.927972	0.913283	0.708205	0.741649
% ];
% figure(1)
% plot(layers,rmse_2,'-ro','LineWidth',1.8,'markersize',7);hold on;
% plot(layers,rmse_3,'-bx','LineWidth',1.8,'markersize',7);hold on;
% plot(layers,rmse_4,'-g+','LineWidth',1.8,'markersize',7);hold on;
% grid on;
% xlabel('隐藏层个数');
% ylabel('均方根误差/km');
% legend('2个参数','3个参数','4个参数');

train_cv_rmse=[
% 0 1184.45 1193.02
500 8.92053 11.6186
1000 8.00548 10.9935
1500 6.59771 8.8331
2000 6.20256 8.13171
2500 5.9111 7.41143
3000 5.15858 6.64566
3500 4.28777 5.44416
4000 3.9873 4.97086
4500 5.67333 6.58277
5000 4.54739 5.29682
5500 3.43566 4.18512
6000 4.74329 5.52478
6500 3.48912 4.18327
7000 3.22057 3.84563
7500 3.21073 3.87152
8000 3.12201 3.71213
8500 3.44307 3.96697
9000 3.38237 4.17776
9500 2.97656 3.51159
10000 3.21391 3.75346
10500 3.02079 3.51714
11000 3.1779 3.64094
11500 3.04321 3.58394
12000 2.8665 3.54631
12500 3.41882 4.01938
13000 3.1247 3.67278
13500 2.93024 3.69379
14000 2.90536 3.47091
14500 3.06072 4.01542
15000 3.01961 4.17193
15500 2.81956 3.48085
16000 2.92159 3.80581
16500 3.05705 3.52841
17000 2.90844 3.97226
17500 2.92845 3.87243
18000 2.96431 4.18707
18500 3.16291 3.95878
19000 2.72769 3.86848
19500 2.72206 3.88084];
plot(train_cv_rmse(:,1),train_cv_rmse(:,2),'-ro','LineWidth',1.8,'markersize',7);hold on;
plot(train_cv_rmse(:,1),train_cv_rmse(:,3),'-bx','LineWidth',1.8,'markersize',7);hold on;
grid on;
xlabel('迭代次数');
ylabel('均方根误差/km');
legend('训练组','交叉验证组');