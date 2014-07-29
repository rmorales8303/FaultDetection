clear all
clc
tic
%%%%%%%%%%%%%%%%%% seleccionar datos de excel %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%selcciona de la celda B1 a la celda E34
T=xlsread('2_Bases de Reglas.xlsx','Datos','b1:e34');
titulo1={'TIEMPO','TURBIEDAD','PENDIENTE TURBIEDAD','OXIGENO','PENDIENTE OXIGENO','pH','PENDIENTE pH','CONDUCTIVIDAD','PENDIENTE CONDUCTIVIDAD'};
titulo2={'TIEMPO','TURBIEDAD','PENDIENTE TURBIEDAD','OXIGENO','PENDIENTE OXIGENO','pH','PENDIENTE pH','CONDUCTIVIDAD','PENDIENTE CONDUCTIVIDAD'};
xlswrite('Reportes.xlsx',titulo1,'REPORTE', 'A1');
xlswrite('Reportes.xlsx',titulo2,'DIAGNOSTICO', 'A1');

%%%%%%%%%% definicion de variables %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tsimul=15;%tiempo de simulación (para adquisición de datos)

s1=[];  s2=[];  s3=[];  s4=[];%define matrices vacias para el futuro arreglo

tj=[]; tm=[]; tn=[]; tmsm1=[]; tmsm2=[];%define almacenadores de vectores
oj=[]; om=[]; on=[]; omsm1=[]; omsm2=[];%define almacenadores de vectores
pj=[]; pm=[]; pn=[]; pmsm1=[]; pmsm2=[];%define almacenadores de vectores
cj=[]; cm=[]; cn=[]; cmsm1=[]; cmsm2=[];%define almacenadores de vectores

tki=0; tkj=0; %define contadores TURBIEDAD
oki=0; okj=0;%define contadores OXIGENO
pki=0; pkj=0;%define contadores pH
cki=0; ckj=0;%define contadores CONDUCTIVIDAD

%%%%%%%%%%%%%%% Determinación de  valores limites %%%%%%%%%%%%%%%%%%%%%%%%%
HTURB=3000;%banda superior turbiedad
LTURB=20;%banda inferior turbiedad
HPTURB=300;%banda superior pendiente turbiedad
LPTURB=-300;%banda inferior pendiente turbiedad

HOD=7.5;%banda superior OD
LOD=3.5;%banda inferior OD
HPOD=4;%banda superior pendiente OD
LPOD=-4;%banda inferior pendiente OD

HPH=7.5;%banda superior pH
LPH=6.5;%banda inferior PH
HPPH=3;%banda superior pendiente PH
LPPH=-3;%banda inferior pendiente PH

HCONDT=100;%banda superior CONDUT
LCONDT=50;%banda inferior CONDUT
HPCONDT=30;%banda superior pendiente PH
LPCONDT=-30;%banda inferior pendiente PH


%%%%%%%%%%%%%%%%%%%%%%%%% CICLO DE DETECCIÓN %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   for i=1:tsimul%Inicia ciclo
 
%%%%%%%%%%%% determinacion de las columnas leidas de excel %%%%%%%%%%%%%%%%
TURB=T(i,1);%Valor Absoluto para TURBIEDAD
OD=T(i,3);%Valor Absoluto para OXIGENO
PH=T(i,2);%Valor Absoluto para pH
CONDT=T(i,4);%Valor Absoluto para CONDUCTIVIDAD

%obtencion de los valores y creacion del arreglo
s1=[s1 TURB];
s2=[s2 PH];
s3=[s3 OD];
s4=[s4 CONDT];

%%%%%%%% ANALISIS VALOR ABSOLUTO %%%%%%%%%%%%
V_TURB=[i,TURB];%VECTOR Valor Absoluto TURBIEDAD
V_OD=[i,OD];%VECTOR Valor Absoluto OXIGENO
V_PH=[i,PH];%VECTOR Valor Absoluto pH
V_CONDT=[i,CONDT];%VECTOR Valor Absoluto CONDUCTIVIDAD


%%%%%%%% ANALISIS VALOR TENDENCIAS %%%%%%%%%%%%
if (i-1)<=0;
   tki=T((i),1);
   tkj=T((i),1);
   else
   tki=T((i-1),1);
   tkj=T((i),1);
end

PEND_TURB=(tkj-tki)/(i+1-i);%Valor pendiente TURBIEDAD

if (i-1)<=0;
    oki=T((i),3);
    okj=T((i),3);
    else
    oki=T((i-1),3);
    okj=T((i),3);
end

PEND_OX=(oki-okj)/(i+1-i);%Valor pendiente OXIGENO

if (i-1)<=0;
    pki=T((i),2);
    pkj=T((i),2);
    else
    pki=T((i-1),2);
    pkj=T((i),2);
end

PEND_PH=(pki-pkj)/(i+1-i);%Valor pendiente pH

if (i-1)<=0;
    cki=T((i),4);
    ckj=T((i),4);
    else
    cki=T((i-1),4);
    ckj=T((i),4);
end

PEND_CONDT=(cki-ckj)/(i+1-i);%Valor pendiente CONDUCTIVIDAD

%%%%%%%%%%%%%%% Grafica de la variable TURBIEDAD %%%%%%%%%%%%%%%%%%%%%
Ti(i)=TURB;
LHTURB(i)=HTURB;
LLTURB(i)=LTURB;
subplot(2,2,1);
 plot(Ti);
 hold;
 plot(LHTURB,'-.r');
 plot(LLTURB,'-.r');
 drawnow;
 hold;
title('TURBIEDAD AGUA CRUDA');
xlabel('Tiempo (s)');
ylabel('Turbiedad (UNT)');
grid on;
pause(0.3);

%%%%%%%%%%%%%%% Grafica de la variable OXIGENO %%%%%%%%%%%%%%%%%%%%%
Oi(i)=OD;
LHOD(i)=HOD;
LLOD(i)=LOD;
subplot(2,2,2);
 plot(Oi);
 hold;
 plot(LHOD,'-.r');
 plot(LLOD,'-.r');
 drawnow;
 hold;
title('OXIGENO DISUELTO AGUA CRUDA');
xlabel('Tiempo (s)');
ylabel('Oxigeno Disuelto (mg/L)');
grid on;
pause(0.3);

%%%%%%%%%%%%%%% Grafica de la variable PH %%%%%%%%%%%%%%%%%%%%%
Pi(i)=PH;
LHPH(i)=HPH;
LLPH(i)=LPH;
subplot(2,2,3);
 plot(Pi);
 hold;
 plot(LHPH,'-.r');
 plot(LLPH,'-.r');
 drawnow;
 hold;
title('pH AGUA CRUDA');
xlabel('Tiempo (s)');
ylabel('pH');
grid on;
pause(0.3);

%%%%%%%%%%%%%%% Grafica de la variable CONDUCTIVIDAD %%%%%%%%%%%%%%%%%%%%%
COi(i)=CONDT;
LHCONDT(i)=HCONDT;
LLCONDT(i)=LCONDT;
subplot(2,2,4);
 plot(COi);
 hold;
 plot(LHCONDT,'-.r');
 plot(LLCONDT,'-.r');
 drawnow;
 hold;
title('CONDUCTIVIDAD AGUA CRUDA');
xlabel('Tiempo (s)');
ylabel('CONDUCTIVIDAD (\mu/cm)');
grid on;
pause(0.3);

%%%%%%%%%%%%%% ESCRITURA EN EXCEL DEL LAS FALLAS DETECTADAS %%%%%%%%%%%%%%%
cond_TURB=(TURB<=LTURB || TURB>=HTURB || PEND_TURB<=LPTURB || PEND_TURB>=HPTURB);
cond_OD=(OD<=LOD || OD>=HOD || PEND_OX<=LPOD || PEND_OX>=HPOD);
cond_PH=(PH<=LPH || PH>=HPH || PEND_PH<=LPPH || PEND_PH>=HPPH);
cond_CONDT=(CONDT<=LCONDT || CONDT>=HCONDT || PEND_CONDT<=LPCONDT || PEND_CONDT>=HPCONDT);

if cond_TURB || cond_OD || cond_PH || cond_CONDT;
    
    tj=[tj i];
    tm=[tm TURB];%contador de la variable TURBIEDAD
    tn=[tn PEND_TURB];%contador de la pendiente TURBIEDAD
    om=[om OD];
    on=[on PEND_OX];
    pm=[pm PH];
    pn=[pn PEND_PH];
    cm=[cm CONDT];
    cn=[cn PEND_CONDT];
    
    datos_reporte=[tj' tm' tn' om' on' pm' pn' cm' cn']%reporte de anomalias
    W=xlswrite('Reportes.xlsx',datos_reporte,'REPORTE','A2'); 
    
%%%%%%%%%%%%%%%%% condicion de rangos de TURBIEDAD %%%%%%%%%%%%%%%%
  if TURB<=LTURB || TURB>=HTURB ;
        if TURB<=LTURB
            Tmessage1={'bajo'};
            %disp('la TURBIEDAD es muy baja') 
        end
    
        if TURB>=HTURB
            Tmessage1={'alto'};
            %disp('la TURBIEDAD es muy alta')
        end
   else
          Tmessage1={'normal'};
  end
%%%%%%%%%%%% condicion de rangos de PENDIENTE TURBIEDAD %%%%%%%%%%%%%%%%
  if  PEND_TURB<=LPTURB || PEND_TURB>=HPTURB;
        if PEND_TURB<=LPTURB;
            Tmessage2={'pendiente baja'};
           % disp('la pendientes es muy baja')
        end

        if PEND_TURB>=HPTURB;
            Tmessage2={'pendiente alta'};
            %disp('la pendientes es muy alta')
        end
  else
      Tmessage2={'pendiente normal'};
  end
%%%%%%%%%%%%%%%%% condicion de rangos de OXIGENO %%%%%%%%%%%%%%%%  
  if OD<=LOD || OD>=HOD ;
        if OD<=LOD 
            Omessage1={'bajo'};
            %disp('El OXIGENO es muy bajo') 
        end
    
        if OD>=HOD
            Omessage1={'alto'};
            %disp('El OXIGENO es muy alto')
        end
   else
          Omessage1={'normal'};
  end
%%%%%%%%%%%% condicion de rangos de PENDIENTE OXIGENO %%%%%%%%%%%%%%%%  
  if  PEND_OX<=LPOD || PEND_OX>=HPOD;
        if PEND_OX<=LPOD;
            Omessage2={'pendiente baja'};
            %disp('la pendientes es muy baja')
        end

        if PEND_OX>=HPOD;
            Omessage2={'pendiente alta'};
            %disp('la pendientes es muy alta')
        end
  else
      Omessage2={'pendiente normal'};
  end
  
%%%%%%%%%%%%%%%%% condicion de rangos de PH %%%%%%%%%%%%%%%%  
  if PH<=LPH || PH>=HPH ;
        if PH<=LPH 
            Pmessage1={'bajo'};
            %disp('El pH es muy bajo') 
        end
    
        if PH>=HPH
            Pmessage1={'alto'};
           % disp('El pH es muy alto')
        end
   else
          Pmessage1={'normal'};
  end
%%%%%%%%%%%% condicion de rangos de PENDIENTE pH %%%%%%%%%%%%%%%%  
  if  PEND_PH<=LPPH || PEND_PH>=HPPH;
        if PEND_PH<=LPPH;
            Pmessage2={'pendiente baja'};
           % disp('la pendientes es muy baja')
        end

        if PEND_PH>=HPPH;
            Pmessage2={'pendiente alta'};
            %disp('la pendientes es muy alta')
        end
  else
      Pmessage2={'pendiente normal'};
  end
  
  %%%%%%%%%%%%%%%%% condicion de rangos de CONDUCTIVIDAD %%%%%%%%%%%%%%%%  
  if CONDT<=LCONDT || CONDT>=HCONDT ;
        if CONDT<=LCONDT
            Cmessage1={'bajo'};
            %disp('La CONDT es muy baja') 
        end
    
        if CONDT>=HCONDT
            Cmessage1={'alto'};
            %disp('La CONDT es muy alta')
        end
   else
          Cmessage1={'normal'};
  end
%%%%%%%%%%%% condicion de rangos de PENDIENTE CONDUCTIVIDAD %%%%%%%%%%%%%%%%  
  if  PEND_CONDT<=LPCONDT || PEND_CONDT>=HPCONDT;
        if PEND_CONDT<=LPCONDT;
            Cmessage2={'pendiente baja'};
           % disp('la pendientes es muy baja')
        end

        if PEND_CONDT>=HPCONDT;
            Cmessage2={'pendiente alta'};
            %disp('la pendientes es muy alta')
        end
  else
      Cmessage2={'pendiente normal'};
  end  

%%%%%%%%%%%%%%%%%%%%%%%%%%% ESCRITURA DE MENSAGES %%%%%%%%%%%%%%%%%%%%%%  
  tmsm1=[tmsm1 Tmessage1];
  tmsm2=[tmsm2 Tmessage2];
  omsm1=[omsm1 Omessage1];
  omsm2=[omsm2 Omessage2];
  pmsm1=[pmsm1 Pmessage1];
  pmsm2=[pmsm2 Pmessage2];
  cmsm1=[cmsm1 Cmessage1];
  cmsm2=[cmsm2 Cmessage2];
  
    xlswrite('Reportes.xlsx',[tj'],'DIAGNOSTICO', 'A2');
    xlswrite('Reportes.xlsx',[tmsm1'],'DIAGNOSTICO', 'B2');
    xlswrite('Reportes.xlsx',[tmsm2'],'DIAGNOSTICO', 'C2');
    xlswrite('Reportes.xlsx',[omsm1'],'DIAGNOSTICO', 'D2');
    xlswrite('Reportes.xlsx',[omsm2'],'DIAGNOSTICO', 'E2');
    xlswrite('Reportes.xlsx',[pmsm1'],'DIAGNOSTICO', 'F2');
    xlswrite('Reportes.xlsx',[pmsm2'],'DIAGNOSTICO', 'G2');
    xlswrite('Reportes.xlsx',[cmsm1'],'DIAGNOSTICO', 'H2');
    xlswrite('Reportes.xlsx',[cmsm2'],'DIAGNOSTICO', 'I2');
  
  
else
end

   end
 toc 
  