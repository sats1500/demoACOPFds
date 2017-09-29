function [c,ceq]=nlc(x,Ybus,n,linedata,bus_spec,ng)
c=[];

for i=1:n
    [rf,~]=find(linedata(:,1)==i);
    [rt,~]=find(linedata(:,2)==i);
    [r1,~]=find(ng==i);
    if isempty(r1)
        ceq(2*i-1,1)=[-real(bus_spec(i,7))-x(n+i)*sum(x(n+1:2*n).*abs(Ybus(i,:)).*cos(angle(Ybus(i,:))-x(i)+x(1:n)))];
        ceq(2*i,1)=[-imag(bus_spec(i,7))+x(n+i)*sum(x(n+1:2*n).*abs(Ybus(i,:)).*sin(angle(Ybus(i,:))-x(i)+x(1:n)))];
    else
        ceq(2*i-1,1)=[x(2*n+find(ng==r1))-real(bus_spec(i,7))-x(n+i)*sum(x(n+1:2*n).*abs(Ybus(i,:)).*cos(angle(Ybus(i,:))-x(i)+x(1:n)))];
        ceq(2*i,1)=[x(2*n+numel(ng)+find(ng==r1))-imag(bus_spec(i,7))+x(n+i)*sum(x(n+1:2*n).*abs(Ybus(i,:)).*sin(angle(Ybus(i,:))-x(i)+x(1:n)))];
    end
end
% ceq=[ceq;x(1);];
end