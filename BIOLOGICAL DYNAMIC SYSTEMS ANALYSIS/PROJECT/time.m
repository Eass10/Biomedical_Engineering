function time()    
    %%%%%% This programe is for the COMPLICATED-mTOR model
    delt=0.01;
    tfinal=5000;%%%取值到7000
    time=0:delt:tfinal;
    
    k1=0.72;        %0.72   
    k2=0.72;        %0.72
    k3=0.007;         %0.007
    k4=0.007;         %0.007
    dsyn=15;        %15
    ksyn=8.5;       %8.5
    s1=2;         %2   s1=1，找三种稳态
    s2=1;           %1  s2=1.2找两种稳态
    s3=1;           %1  s3=0.9，找三种稳态
    k5=2.7;          %2.7
    k6=1;          %1
    k7=0.5;       %kaers=0.5;      
    k8=1;         %kiers=1;        
    k9=2;         %kamtor=2;       
    k10=10;       %kamtor1=10;   
    k11=0.4;      %kimtor=0.4;    
    k12=7;        %kimtor1=7;      
    k13=2;        %kabe=2;         
    k14=4;        %kabe1=4;        
    k15=1;        %kibe=1;         
    k16=10;       %kibe1=10;     
    k17=0.6;      %kibe2=0.6;      
    Jbe=1;        %1
    k18=1;        %kaca=1;         
    k19=2;        %kaca1=2;       
    k20=2;        %kaca2=2;        
    k21=2;        %kica=2;         
    k22=4.5;      %kica1=4.5;      
    Jca=0.04;     %0.04
    ERST=2;       %2
    mTORT=1;      %mTOR会改变自噬凋亡的启动时间
    BecaT=1;     
    CaspT=1;     
    
    tnum=fix(tfinal/delt)+1;
    save tnum tnum;
    
    Ros=zeros(1,tnum);
    Syn=zeros(1,tnum);
    ERS=zeros(1,tnum);
    mTOR=zeros(1,tnum);
    Beca=zeros(1,tnum);
    Casp=zeros(1,tnum);
    
    
    Ros(1)=0;
    Syn(1)=0;
    ERS(1)=0;
    mTOR(1)=1;
    Beca(1)=0;
    Casp(1)=0;
    
    
    for  i=1:(tnum-1)
       
       Ros(i+1)=Ros(i)+Ros_fun(k1,s1,dsyn,Syn(i),ksyn,k2,Ros(i),s2)*delt;
       Syn(i+1)=Syn(i)+Syn_fun(k3,Ros(i),s3,k4,Syn(i),k5,Beca(i),mTOR(i))*delt;
       ERS(i+1)=ERS(i)+ERS_fun(k6,Syn(i),k7,ERST,ERS(i),k8)*delt;
       mTOR(i+1)=mTOR(i)+mTOR_fun(k9,k10,ERS(i),mTORT,mTOR(i),k11,k12,Beca(i))*delt; 
       Beca(i+1)=Beca(i)+Beca_fun(k13,k14,ERS(i),BecaT,Beca(i),Jbe,k15,k16,Casp(i),k17,mTOR(i))*delt;
       Casp(i+1)=Casp(i)+Casp_fun(k18,k19,ERS(i),k20,mTOR(i),CaspT,Casp(i),Jca,k21,k22,Beca(i))*delt;
       
    %    save Syn Syn;
    %    save Casp Casp;
    %    save Beca Beca;
    %   
    end
    
    
    figure;
    plot(time,Ros,'color','r','Linewidth',2);
    title('ROS');
    xlabel('Time');
    ylabel('Concentration');
    
    figure;
    plot(time,Syn,'color','k','Linewidth',2);
    title('αSyn');
    xlabel('Time');
    ylabel('Concentration');
    
    figure;
    plot(time,ERS, 'color', 'y', 'Linewidth',2)
    title('ERS');
    xlabel('Time');
    ylabel('Concentration');
    
    figure;
    plot(time,mTOR,'color','m','Linewidth',2);
    title('mTOR');
    xlabel('Time');
    ylabel('Concentration');
    
    figure;
    plot(time,Beca,'color','g','Linewidth',2);
    title('Beclin1');
    xlabel('Time');
    ylabel('Concentration');
    
    figure;
    plot(time,Casp,'color','b','Linewidth',2);
    title('Caspases');
    xlabel('Time');
    ylabel('Concentration');
    
    %plot(Beca,Casp,'-','color','b','Linewidth',2);
    %xlabel('Time');
    %ylabel('Concentration');

    set(get(gca,'xlabel'),'fontsize',16);
    set(get(gca,'ylabel'),'fontsize',16);
    set(gca,'fontsize',16);

    % text(32,2,'S_{1}=1.5','color',[0.3 0.3 0.3],'fontsize',18);
    % axis([0 300 0 1]);
    % text(-220,15.2,'I','FontSize',24)  %-220
end

function [Rosvalue]=Ros_fun(k1,s1,dsyn,Syn,ksyn,k2,Ros,s2)
         Rosvalue=v1_fun(k1,s1,dsyn,Syn,ksyn)-v2_fun(k2,Ros,s2);
end
function [v1value]=v1_fun(k1,s1,dsyn,Syn,ksyn)
          v1value=k1*(1+s1+dsyn*((Syn/ksyn)^4)/(1+(Syn/ksyn)^4));
end
function [v2value]=v2_fun(k2,Ros,s2)
          v2value=k2*Ros*s2;
end
function [Synvalue]=Syn_fun(k3,Ros,s3,k4,Syn,k5,Beca,mTOR)
          Synvalue=v3_fun(k3,Ros,s3)-v4_fun(k4,Syn,k5,Beca,mTOR);
end
function [v3value]=v3_fun(k3,Ros,s3)
          v3value=k3*Ros*s3;
end
function [v4value]=v4_fun(k4,Syn,k5,Beca,mTOR)
          v4value=k4*Syn*k5*Beca*mTOR;
end
function [ERSvalue]=ERS_fun(k6,Syn,k7,ERST,ERS,k8)
          ERSvalue=k6*Syn*k7*(ERST-ERS)-k8*ERS;
end
function  [mTORvalue]=mTOR_fun(k9,k10,ERS,mTORT,mTOR,k11,k12,Beca) 
           mTORvalue=(k9+k10*ERS)*(mTORT-mTOR)-(k11+k12*Beca)*mTOR;
end
function [Becavalue]=Beca_fun(k13,k14,ERS,BecaT,Beca,Jbe,k15,k16,Casp,k17,mTOR)
          Becavalue=(k13+k14*ERS)*(BecaT-Beca)/(Jbe+BecaT-Beca)-(k15+k16*Casp+k17*mTOR)*Beca/(Jbe+Beca);
end
function [Caspvalue]=Casp_fun(k18,k19,ERS,k20,mTOR,CaspT,Casp,Jca,k21,k22,Beca)
          Caspvalue=(k18+k19*ERS+k20*mTOR)*(CaspT-Casp)/(Jca+CaspT-Casp)-(k21+k22*Beca)*Casp/(Jca+Casp);
end
