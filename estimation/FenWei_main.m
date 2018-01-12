clc;clear all;close all;
%% ����ԭʼ�ź�
fs_a=1*10^9;
fs_d=1*10^6;
T=0.1;
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
td_ini=0.03;
fd_ini=44.4524;
y_a2=recreation(s_a, td_ini, fd_ini, fs_a);
y_d1=resample(y_a1,fs_d,fs_a);
y_d2=resample(y_a2,fs_d,fs_a);
SNR=15;
%% �����ͨ�˲���
fn_h=400*10^3;
Wn=fn_h/(fs_d/2);
[b,a]=butter(8,Wn);
%% ���Լ��ĺ���������
% NOISE1 = noisegen(y_d1,SNR);
% NOISE2 = noisegen(y_d2,SNR);
%% ��wgn������
y_d1_power=sum(abs(y_d1).^2)/length(y_d1);
y_d2_power=sum(abs(y_d2).^2)/length(y_d2);
NOISE1_power=y_d1_power / ( 10^(SNR/10) );
NOISE2_power=y_d2_power / ( 10^(SNR/10) );
NOISE1=wgn(1,length(y_d1),10*log10(NOISE1_power));
NOISE2=wgn(1,length(y_d2),10*log10(NOISE2_power),'complex');
%% �����������
NOISE_band1=filter(b,a,NOISE1);
NOISE_band2=filter(b,a,NOISE2);
NOISE_band1=NOISE_band1*sqrt(NOISE1_power/(std(NOISE_band1)^2));
NOISE_band2=NOISE_band2*sqrt(NOISE2_power/(std(NOISE_band2)^2));
y_dn1=y_d1+NOISE_band1;
y_dn2=y_d2+NOISE_band2;
snr1=SNR_singlech(y_d1,y_dn1);
snr2=SNR_singlech(y_d2,y_dn2);
%% �۲�Ƶ��
% L=length(y_dn1);
% NFFT=2^nextpow2(2*L-1);
% delta_f=fs_d/NFFT;
% Y_dn1=fft(y_dn1,NFFT)/L;
% f=fs_d/2*linspace(0,1,NFFT/2+1);
% plot(f,abs(Y_dn1(1:NFFT/2+1)));