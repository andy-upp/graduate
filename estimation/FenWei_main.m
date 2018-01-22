clc;clear all;close all;
%% ����ԭʼ�ź�
fs_a=1*10^9;
fs_d=200*10^3;
td_ini=19.87*10^-6;
fd_ini=19.08;
T=0.1;
N=2;
tao=0.999*T;
t_a=0:1/fs_a:T;
t_d=0:1/fs_d:T;
tao_a=0:1/fs_a:tao;
tao_d=0:1/fs_d:tao;
B=10*10^3;
f_low_a=0;
f_high_a=f_low_a+B;
k=B/tao;
% s_a=chirp(tao_a,f_low_a,tao,f_high_a);
s_a=exp(1j*2*pi*(f_low_a*tao_a+1/2*k*tao_a.^2));
s_a=[s_a zeros(1,int32(fs_a*(T-tao)))];
% s_ak=[s_a zeros(1,int32(fs_a*(T-tao)))];
y_a1=s_a;
% td_ini=2.3524e-05;
% s_a2=exp(1j*2*pi*((f_low_a+fd_ini)*tao_a+1/2*k*tao_a.^2));
% s_a2=[s_a2 zeros(1,(length(s_a2) - 1)*(N-1))];
y_a2=recreation(s_a, td_ini, fd_ini, fs_a);
SNR=20;
%% �źŲ���
y_d1=downsample(y_a1,fs_a/fs_d);
y_d2=downsample(y_a2,fs_a/fs_d);
%% ����������ͨ�˲���
Bn=50*10^3;
fn_h=Bn;
Wn=fn_h/(fs_d/2);
[b,a]=butter(8,Wn,'low');
%% ��������غ���֮�ȵ�ͨ�˲���
% fd_max=80;
% Wn_fd=fd_max/(fs_d/2);
% [b_fd,a_fd]=butter(6,Wn_fd,'low');
fd_max=40;
Wn_fd=fd_max/fs_d;
b_fd=fir1(96,Wn_fd,'low');
%% ���Լ��ĺ���������
% NOISE1 = noisegen(y_d1,SNR);
% NOISE2 = noisegen(y_d2,SNR);
%% ��wgn������
y_d1_power=sum(abs(y_d1).^2)/length(y_d1);
y_d2_power=sum(abs(y_d2).^2)/length(y_d2);
NOISE1_power=y_d1_power / ( 10^(SNR/10) );
NOISE2_power=y_d2_power / ( 10^(SNR/10) );
NOISE1=wgn(1,length(y_d1),10*log10(NOISE1_power),'complex');
NOISE2=wgn(1,length(y_d2),10*log10(NOISE2_power),'complex');
%% �����������
NOISE_band1=filter(b,a,NOISE1);
NOISE_band2=filter(b,a,NOISE2);
NOISE_band1=NOISE_band1*sqrt(NOISE1_power/(std(NOISE_band1)^2));
NOISE_band2=NOISE_band2*sqrt(NOISE2_power/(std(NOISE_band2)^2));
y_dn1=y_d1+NOISE_band1;
y_dn2=y_d2+NOISE_band2;
%% ����ԭʼ�źŴ�/��ͨͨ�˲���
% Wn_band=[f_low_a-10*10^3 f_high_a+10*10^3]/fs_d;
% b_y=fir1(48,Wn_band,'bandpass');
% y_dn1_band=filter(b_y,1,y_dn1);
% y_dn2_band=filter(b_y,1,y_dn2);
Wn_low=(f_high_a+80)/fs_d;
b_y=fir1(96,Wn_low,'low');
y_dn1_band=filter(b_y,1,y_dn1);
y_dn2_band=filter(b_y,1,y_dn2);
% y_dn1_band=y_dn1;
% y_dn2_band=y_dn2;
%% ��������
% y_dn1=y_d1;
% y_dn2=y_d2;
% snr1=SNR_singlech(y_d1,y_dn1);
% snr2=SNR_singlech(y_d2,y_dn2);
% %% ����Ƶ��
L=length(y_dn1);
Nf=2^nextpow2(2*L-1);
% delta_f=fs_d/Nf;
% y_dn1=[y_dn1 zeros(1,Nf-L)];
% y_dn2=[y_dn2 zeros(1,Nf-L)];
Y_dn1=fft(y_dn1_band,Nf);
% f=fs_d/2*linspace(0,1,Nf/2+1);
% plot(f,abs(Y_dn1(1:Nf/2+1)));
Y_dn2=fft(y_dn2_band,Nf);
% Y_dn1=fftshift(Y_dn1);
% Y_dn2=fftshift(Y_dn2);
%% ��Ƶ���ȡ
k_Nf=1:Nf;
k_l=(f_low_a)*Nf/fs_d;
k_h=(f_high_a+400)*Nf/fs_d;
Y_dn1_jiequ=Y_dn1.*(k_Nf>=k_l&k_Nf<=k_h);
Y_dn2_jiequ=Y_dn2.*(k_Nf>=k_l&k_Nf<=k_h);
%% ÿһ·�źŵĹ�����
R1=conj(Y_dn1_jiequ).*Y_dn1_jiequ;
R2=conj(Y_dn2_jiequ).*Y_dn2_jiequ;
%% ÿһ·�źŵ�����غ���
r1=ifft(R1,Nf);
r2=ifft(R2,Nf);
r1=ifftshift(r1);
r2=ifftshift(r2);
r1_jiequ=r1(Nf/2+1-(L-1)/2:Nf/2+1+(L-1)/2);
r2_jiequ=r2(Nf/2+1-(L-1)/2:Nf/2+1+(L-1)/2);
%% ��xcorr�������
% r1_jiequ=xcorr(y_dn1);
% r2_jiequ=xcorr(y_dn2);
%% ������غ�������M����ȡ
fs_pie=100;
M=fs_d/fs_pie;
% L_pie=Nf/M;
% r1_pie=downsample(r1_jiequ,M);
% r2_pie=downsample(r2_jiequ,M);
% r1_pie=r1_jiequ;
% r2_pie=r2_jiequ;
%% ��������غ���֮��
kesi=r2_jiequ./r1_jiequ;
% kesi_L=length(kesi);
% kesi=downsample(kesi,M);

kesi_f=filter(b_fd,1,kesi);

% Wn_fd=fd_max/fs_d;
% b_fd=fir1(48,Wn_fd,'low');
% kesi_f=filter(b_fd,1,kesi);

kesi_M=downsample(kesi_f,M);
kesi_L=length(kesi_M);
%% �Ӵ�����
win = hamming(kesi_L);
kesi_w = kesi_M.*win';
%% ����غ���֮�Ȳ���
delta_f=0.01;
N_pie=2^nextpow2(fs_pie/delta_f);
% N_pie=kesi_L;
% kesi_pie=[kesi_w(1:(kesi_L-1)/2) zeros(1,N_pie-kesi_L+1) kesi_w((kesi_L+1)/2+1:kesi_L)];
kesi_pie=[kesi_w zeros(1,N_pie-kesi_L)];
% N_pie=512;
%% ��������غ���֮�ȵ�Ƶ��
Fai=fft(kesi_pie,N_pie)/N_pie;
%% ����Ƶ�ף��õ���ֵ
[Fai_max,k_max]=max(abs(Fai(1:N_pie/2)));
fd=(k_max-1)*fs_pie/N_pie;

%% ����ʱ��
%% �ź�Ƶ���
% y_dn2k=[zeros(1,fix(fs_d*(T-tao))) y_dn2];
y2_xz=y_dn2_band.*exp(-1j*2*pi*fd_ini*t_d);
% y2_xz=y2_xz(fix(fs_d*(T-tao))+1:length(y2_xz));
% r=xcorr(y2_pie,y_dn1);
% [m,n]=max(abs(r));
% td=(n-(length(r)+1)/2)/fs_d;
% disp(fd);
% disp(td);
Y2_xz=fft(y2_xz,Nf);
%% Ƶ���ȡ��
% Y2_xz_jiequ=Y2_xz.*(k_Nf>=k_l&k_Nf<=k_h);
Y2_xz_jiequ=Y2_xz;
R12=conj(Y_dn1_jiequ).*Y2_xz_jiequ;
delta_t=0.1*10^-6;
%% ����
fs_pie_t=1/delta_t;
T_pie=200*10^-6;
M_t=int32(Nf/(T_pie*fs_d));
R12_M=downsample(R12,M_t);
R12_M_L=length(R12_M);
if rem(R12_M_L,2)==1
    R12_M=[R12_M(1:(R12_M_L-1)/2) R12_M((R12_M_L-1)/2+2:R12_M_L)];
end
R12_M_L=length(R12_M);
Nf_pie_t=2^nextpow2(fs_pie_t*T_pie);
% fs_pie_t=Nf_pie_t*fs_pie_t/R12_M_L;
%% �Ӵ���
% win_t = hamming(R12_M_L);
% R12_w = R12_M.*win_t';
R12_w=R12_M;
R12_pie=[R12_w(1:R12_M_L/2) zeros(1,Nf_pie_t-R12_M_L) R12_w(R12_M_L/2+1:R12_M_L)];
r12_pie=ifft(R12_pie,Nf_pie_t);
r12_pie=ifftshift(r12_pie);
[r_max,n_max]=max(abs(r12_pie));
td=(n_max-Nf_pie_t/2+0.5)*(T_pie/Nf_pie_t);
%% mine
%% ֱ�Ӱ�ifft�ĵ�������
% fs_pie_t=1/delta_t;
% Nf_pie_t=2^nextpow2(Nf*fs_pie_t/fs_d);
% fs_pie_t=Nf_pie_t*fs_d/Nf;
% r12=ifft(R12,Nf_pie_t);
% r12_shift=ifftshift(r12);
% [r_max,n_max]=max(abs(r12_shift));
% td=(n_max-Nf_pie_t/2)/fs_pie_t;
%% ��ֵ
% M=1/delta_t/fs_d;
% y2_xz_interp=interp(y2_xz,M);
% y_dn1_interp=interp(y_dn1,M);
% r12=xcorr(y2_xz_interp,y_dn1_interp);
% [m,n]=max(abs(r12));
% td=(n-(length(r12)+1)/2)*delta_t;