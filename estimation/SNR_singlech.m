function snr=SNR_singlech(I,In)
% ��������Ⱥ���
% I :original signal
% In:noisy signal(ie. original signal + noise signal)
snr=0;
I_L=length(I);
In_L=length(In);
if In_L>I_L
    I=[I zeros(1,In_L-I_L)];
end
Ps=sum(abs(I).^2)/I_L;
Pn=sum(abs(In-I).^2)/In_L;
% Ps=sum(sum((I-mean(mean(I))).^2));%signal power
% Pn=sum(sum((I-In).^2));           %noise power
snr=10*log10(Ps/Pn);
% ����I�Ǵ��źţ�In�Ǵ����źţ�snr�������
end