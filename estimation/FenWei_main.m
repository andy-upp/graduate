clc;clear all;close all;
%% ����ԭʼ�ź�
fs_a=1*10^9;
fs_d=400*10^3;
T=100*10^-3;
N=2;
tao=T/N;
t_a=0:1/fs_a:T;
t_d=0:1/fs_d:T;
tao_a=0:1/fs_a:tao;
tao_d=0:1/fs_d:tao;
B=10*10^3;
f_low_a=0;
f_high_a=B;
k=B/tao;
% s_a=chirp(tao_a,f_low_a,tao,f_high_a);
s_a=exp(1j*2*pi*(f_low_a*tao_a+1/2*k*tao_a.^2));
s_a=[s_a zeros(1,(length(s_a) - 1)*(N-1))];
y_a1=s_a;
% td_ini=2.3524e-05;
td_ini=200*10^-9;
fd_ini=329.08;
s_a2=exp(1j*2*pi*((f_low_a+fd_ini)*tao_a+1/2*k*tao_a.^2));
s_a2=[s_a2 zeros(1,(length(s_a2) - 1)*(N-1))];
y_a2=recreation(s_a2, td_ini, 0, fs_a);
y_d1=resample(y_a1,fs_d,fs_a);
y_d2=resample(y_a2,fs_d,fs_a);
% SNR=10;
% %% �����ͨ�˲���
% Bn=100*10^3;
% fn_h=Bn;
% Wn=fn_h/(fs_d/2);
% [b,a]=butter(8,Wn,'low');
% %% ���Լ��ĺ���������
% % NOISE1 = noisegen(y_d1,SNR);
% % NOISE2 = noisegen(y_d2,SNR);
% %% ��wgn������
% y_d1_power=sum(abs(y_d1).^2)/length(y_d1);
% y_d2_power=sum(abs(y_d2).^2)/length(y_d2);
% NOISE1_power=y_d1_power / ( 10^(SNR/10) );
% NOISE2_power=y_d2_power / ( 10^(SNR/10) );
% NOISE1=wgn(1,length(y_d1),10*log10(NOISE1_power),'complex');
% NOISE2=wgn(1,length(y_d2),10*log10(NOISE2_power),'complex');
% %% �����������
% NOISE_band1=filter(b,a,NOISE1);
% NOISE_band2=filter(b,a,NOISE2);
% NOISE_band1=NOISE_band1*sqrt(NOISE1_power/(std(NOISE_band1)^2));
% NOISE_band2=NOISE_band2*sqrt(NOISE2_power/(std(NOISE_band2)^2));
% y_dn1=y_d1+NOISE_band1;
% y_dn2=y_d2+NOISE_band2;
% %% �����ͨͨ�˲���
% B=10*10^3;
% f_low_a=0;
% f_high_a=B;
% Wn=fn_h/(fs_d/2);
% [b,a]=butter(8,Wn,'low');
%% ��������
y_dn1=y_d1;
y_dn2=y_d2;
% snr1=SNR_singlech(y_d1,y_dn1);
% snr2=SNR_singlech(y_d2,y_dn2);
% %% ����Ƶ��
% L=length(y_dn1);
% Nf=2^nextpow2(2*L-1);
% % delta_f=fs_d/Nf;
% y_dn1=[y_dn1 zeros(1,Nf-L)];
% y_dn2=[y_dn2 zeros(1,Nf-L)];
% Y_dn1=fft(y_dn1,Nf)/Nf;
% % f=fs_d/2*linspace(0,1,NF/2+1);
% % plot(f,abs(Y_dn1(1:NF/2+1)));
% Y_dn2=fft(y_dn2,Nf)/Nf;
% Y_dn1=fftshift(Y_dn1);
% Y_dn2=fftshift(Y_dn2);
% %% ÿһ·�źŵĹ�����
% R1=conj(Y_dn1).*Y_dn1;
% R2=conj(Y_dn2).*Y_dn2;
% %% ÿһ·�źŵ�����غ���
% r1=ifft(R1,Nf);
% r2=ifft(R2,Nf);
% r1=ifftshift(r1);
% r2=ifftshift(r2);
% r1_jiequ=r1(Nf/2+1-(L-1)/2:Nf/2+1+(L-1)/2);
% r2_jiequ=r2(Nf/2+1-(L-1)/2:Nf/2+1+(L-1)/2);
%% ��xcorr�������
r1_jiequ=xcorr(y_dn1);
r2_jiequ=xcorr(y_dn2);
%% ������غ�������M����ȡ
fs_pie=1000;
M=fs_d/fs_pie;
% L_pie=Nf/M;
r1_pie=downsample(r1_jiequ,M);
r2_pie=downsample(r2_jiequ,M);
% r1_pie=r1_jiequ;
% r2_pie=r2_jiequ;
%% ��������غ���֮��
kesi=r2_pie./r1_pie;
kesi_L=length(kesi);
% kesi=downsample(kesi,M);
%% �Ӵ�����
win = hann(kesi_L);
kesi = kesi.*win';
%% ����غ���֮�Ȳ���
delta_f=0.1;
N_pie=2^nextpow2(fs_pie/delta_f);
% N_pie=kesi_L;
% kesi_pie=[kesi(1:(kesi_L+1)/2) zeros(1,N_pie-kesi_L) kesi((kesi_L+1)/2+1:kesi_L)];
kesi_pie=[kesi zeros(1,N_pie-length(kesi))];
% N_pie=512;
%% ��������غ���֮�ȵ�Ƶ��
Fai=fft(kesi_pie,N_pie)/N_pie;
%% ����Ƶ�ף��õ���ֵ
[Fai_max,k_max]=max(abs(Fai));
fd=k_max*fs_pie/N_pie;