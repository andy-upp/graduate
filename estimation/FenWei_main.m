clc;clear all;close all;
%% 生成原始信号
fs_a=1*10^9;
fs_d=1*10^6;
T=100*10^-3;
N=2;
tao=T/N;
t_a=0:1/fs_a:T;
t_d=0:1/fs_d:T;
tao_a=0:1/fs_a:tao;
tao_d=0:1/fs_d:tao;
B=100*10^3;
f_low_a=50*10^3;
f_high_a=f_low_a+B;
s_a=chirp(tao_a,f_low_a,tao,f_high_a);
s_a=[s_a zeros(1,(length(s_a) - 1)*(N-1))];
y_a1=s_a;
% td_ini=2.3524e-05;
td_ini=78*10^-9;
fd_ini=44.4524;
y_a2=recreation(s_a, td_ini, fd_ini, fs_a);
y_d1=resample(y_a1,fs_d,fs_a);
y_d2=resample(y_a2,fs_d,fs_a);
SNR=20;
%% 构造低通滤波器
fn_h=400*10^3;
Wn=fn_h/(fs_d/2);
[b,a]=butter(8,Wn);
%% 用自己的函数加噪声
% NOISE1 = noisegen(y_d1,SNR);
% NOISE2 = noisegen(y_d2,SNR);
%% 用wgn加噪声
y_d1_power=sum(abs(y_d1).^2)/length(y_d1);
y_d2_power=sum(abs(y_d2).^2)/length(y_d2);
NOISE1_power=y_d1_power / ( 10^(SNR/10) );
NOISE2_power=y_d2_power / ( 10^(SNR/10) );
NOISE1=wgn(1,length(y_d1),10*log10(NOISE1_power));
NOISE2=wgn(1,length(y_d2),10*log10(NOISE2_power),'complex');
%% 构造带限噪声
NOISE_band1=filter(b,a,NOISE1);
NOISE_band2=filter(b,a,NOISE2);
NOISE_band1=NOISE_band1*sqrt(NOISE1_power/(std(NOISE_band1)^2));
NOISE_band2=NOISE_band2*sqrt(NOISE2_power/(std(NOISE_band2)^2));
y_dn1=y_d1+NOISE_band1;
y_dn2=y_d2+NOISE_band2;
% snr1=SNR_singlech(y_d1,y_dn1);
% snr2=SNR_singlech(y_d2,y_dn2);
%% 计算频谱
L=length(y_dn1);
Nf=2^nextpow2(2*L-1);
% delta_f=fs_d/Nf;
y_dn1=[y_dn1 zeros(1,Nf-L)];
y_dn2=[y_dn2 zeros(1,Nf-L)];
Y_dn1=fft(y_dn1,Nf)/Nf;
% f=fs_d/2*linspace(0,1,NF/2+1);
% plot(f,abs(Y_dn1(1:NF/2+1)));
Y_dn2=fft(y_dn2,Nf)/Nf;
% Y_dn1=fftshift(Y_dn1);
% Y_dn2=fftshift(Y_dn2);
%% 每一路信号的功率谱
R1=conj(Y_dn1).*Y_dn1;
R2=conj(Y_dn2).*Y_dn2;
%% 每一路信号的自相关函数
r1=ifft(R1,Nf);
r2=ifft(R2,Nf);
r1=ifftshift(r1);
r2=ifftshift(r2);
r1_jiequ=r1(Nf/2+1-(L-1)/2:Nf/2+1+(L-1)/2);
r2_jiequ=r2(Nf/2+1-(L-1)/2:Nf/2+1+(L-1)/2);
%% 对自相关函数进行M倍抽取
fs_pie=1000;
M=fs_d/fs_pie;
% L_pie=Nf/M;
r1_pie=downsample(r1_jiequ,M);
r2_pie=downsample(r2_jiequ,M);
% r1_pie=r1_jiequ;
% r2_pie=r2_jiequ;
%% 计算自相关函数之比
kesi=r2_pie./r1_pie;
%% 自相关函数补零
delta_f=0.1;
N_pie=2^nextpow2(fs_pie/delta_f);
% N_pie=2^nextpow2(2*length(kesi)-1);
kesi_L=length(kesi);
kesi_pie=[kesi(1:(kesi_L+1)/2) zeros(1,N_pie-kesi_L) kesi((kesi_L+1)/2+1:kesi_L)];
% kesi_pie=[kesi zeros(1,N_pie-length(kesi))];
% N_pie=512;
%% 计算自相关函数的频谱
Fai=fft(kesi_pie,N_pie)/N_pie;
%% 搜索频谱，得到峰值
[Fai_max,k_max]=max(abs(Fai));
fd=k_max*fs_pie/N_pie;