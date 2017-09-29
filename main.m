clc;
clear all;
warning off;

SATS_input17;
[Ybus,n]=SATS_formybus(linedata,bus_spec(:,10));

ng=find(bus_spec(:,2)==0|bus_spec(:,2)==1); % generator bus numbers
% VARIABLES 1. Angles 2. Voltage 3. PG 4. QG
x0=[zeros(1,n) 1.0*ones(1,n) zeros(1,2*numel(ng))];
A=[];
b=[];
Aeq=[];beq=[];

% FOR GENERATOR BUSES FIX THE VOLTAGE AND REAL POWER BY KEEPING SAME VALUE
% IN lb AND ub
lb=[0 -pi*ones(1,n-1) 1 0.8*ones(1,n-1) zeros(1,numel(ng)) -10*ones(1,numel(ng))];
ub=[0 pi*ones(1,n-1) 1 1.1*ones(1,n-1) 5*ones(1,numel(ng)) 10*ones(1,numel(ng))];

opts = optimset('Algorithm','interior-point','Display','iter');
[x,fval,exitflag,output,lambda,GRD, HESS] = fmincon(@(x) 1,x0,A,b,Aeq,beq,lb,ub,@(x) SATS_nlc(x,Ybus,n,linedata,bus_spec,ng),opts);
x
fval
exitflag
V=transpose(complex(x(n+1:2*n),x(1:n)))
f1=V(linedata(:,1)).*conj(((V(linedata(:,1))-linedata(:,5).*V(linedata(:,2)))./((abs(linedata(:,5))).^2))./(linedata(:,3))+V(linedata(:,1)).*(linedata(:,4)));
f2=V(linedata(:,2)).*conj((V(linedata(:,2))-V(linedata(:,1)))./(linedata(:,3).*linedata(:,5))+V(linedata(:,2)).*(linedata(:,4)+(linedata(:,5)-1)./(linedata(:,5).*linedata(:,3))));
Loss=sum(f1+f2)*1000