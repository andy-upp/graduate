function X=doa_tdoa_computing(delta_t,angle0,angle1,S0,S1)
X=[0 0]';r0=[0 0]';
c=3*10^8;
delta_r=delta_t*c;
x0=S0(1);y0=S0(2);x1=S1(1);y1=S1(2);
k=0.5*(delta_r^2+(x0^2+y0^2)-(x1^2+y1^2));
A=[x0-x1 y0-y1;tan(angle0) -1];
revA=pinv(A);
e=revA(1,1)*delta_r;f=revA(1,1)*k+revA(1,2)*(tan(angle0)*x0-y0);
g=revA(2,1)*delta_r;h=revA(2,1)*k+revA(2,2)*(tan(angle0)*x0-y0);
m=f-x0;n=h-y0;
j=e^2+g^2-1;p=2*(e*m+g*n);q=m^2+n^2;
r0(1)=(-p+sqrt(p^2-4*j*q))/(2*j);
r0(2)=(-p-sqrt(p^2-4*j*q))/(2*j);
if r0(1)>0&&r0(2)<0
    X(1)=e*r0(1)+f;X(2)=g*r0(1)+h;
elseif r0(2)>0&&r0(1)<0
    X(1)=e*r0(2)+f;X(2)=g*r0(2)+h;
elseif r0(2)>0&&r0(1)>0
    Y=[0 0;0 0];
    Y(1,1)=e*r0(1)+f;Y(2,1)=g*r0(1)+h;
    Y(1,2)=e*r0(2)+f;Y(2,2)=g*r0(2)+h;
    if abs((Y(2,1)-y1)/(Y(1,1)-x1)-tan(angle1))<=abs((Y(2,2)-y1)/(Y(1,2)-x1)-tan(angle1))
        X=Y(:,1);
    else
        X=Y(:,2);
    end
else
    X(1)=(tan(angle0)*x0-tan(angle1)*x1-y0+y1)/(tan(angle0)-tan(angle1));
    X(2)=y0+tan(angle0)*(X(1)-x0);
end
end