% function diagnosis = inferenciaMallarino (vector,probs)
close all;
clear all;
clc;

nodos_sintomas=4;   
nodos_fallas=7;   

% names = {'f1','f2','f3','g1','g2','f4','f5','s1','s2','s3','s4'};
% ss = length(names);
% 
% intrac = {'f1','g1';
%     'f2','g1';
%     'f3','g1';
%     'f3','g2';
%     'g1','s1';
%     'g1','s2';
%     'g1','s3';
%     'g1','s4';
%     'g2','s1';
%     'g2','s2';
%     'g2','s3';
%     'g2','s4';
%     'f4','s1';
%     'f4','s2';
%     'f4','s3';
%     'f4','s4';
%     'f5','s1';
%     'f5','s2';
%     'f5','s3';
%     'f5','s4'};
%     
%  
% [intra, names] = mk_adj_mat(intrac,names,1);
% interc = {
%     };
N=nodos_sintomas+nodos_fallas;    %numero de variables del sistema%
dag=zeros(N,N);

%hacer: llamar string de falla ingresada en prob y asignarle un numero
 f1=1; 
 f2=2; 
 f3=3; 
 g1=4;
 g2=5;
 f4=6; 
 f5=7; 
 s1=8; 
 s2=9; 
 s3=10; 
 s4=11;
 
dag(f1,g1)=1;   %relacion de nodos como red naive bayes
dag(f2,g1)=1;
dag(f3,[g1 g2])=1;
dag([g1 g2 f4 f5],s1)=1;
dag([g1 g2 f4 f5],s2)=1;
dag([g1 g2 f4 f5],s3)=1;
dag([g1 g2 f4 f5],s4)=1;

Names={'f1','f2','f3','g1','g2','f4','f5','s1','s2','s3','s4'};

no_falla=1;   
falla=2;
normal=1;  bajo=2; alto=3;

%ns=2*ones(1,N); %nodos binarios
ns=[2 2 2 2 2 2 2 3 3 3 3]; %definicion de los estados de cada nodo [f1 f2 f3 f4 f5 f6 f7 f8 f9 s1 s2 s3 s4 s5 s6]

bnet = mk_bnet(dag, ns, 'names', Names, 'discrete', 1:N);

bnet.CPD{f1} = tabular_CPD(bnet, f1, [0.5 0.5]);
bnet.CPD{f2} = tabular_CPD(bnet, f2, [0.5 0.5]);
bnet.CPD{f3} = tabular_CPD(bnet, f3, [0.5 0.5]);
bnet.CPD{f4} = tabular_CPD(bnet, f4, [0.5 0.5]);
bnet.CPD{f5} = tabular_CPD(bnet, f5, [0.5 0.5]);
bnet.CPD{s1} = tabular_CPD(bnet, s1, [0.9	0.05	0.05	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.05	0.9	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.9	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05] );
bnet.CPD{s2} = tabular_CPD(bnet, s2, [0.9	0.9	0.9	0.9	0.05	0.9	0.9	0.9	0.05	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.05	0.05	0.05	0.05	0.9	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.9	0.05	0.05	0.05	0.05	0.05	0.05	0.05] );
bnet.CPD{s3} = tabular_CPD(bnet, s3, [0.9	0.9	0.9	0.9	0.05	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.05	0.05	0.05	0.05	0.9	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05] );
bnet.CPD{s4} = tabular_CPD(bnet, s4, [0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.05	0.9	0.9	0.9	0.9	0.9	0.9	0.9	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.05	0.9	0.05	0.05	0.05	0.05	0.05	0.05	0.05] );

bnet.CPD{g1} = tabular_CPD(bnet, g1, [0.9	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.1	0.9	0.9	0.9	0.9	0.9	0.9	0.9] );
bnet.CPD{g2} = tabular_CPD(bnet, g2, [0.9	0.1	0.1	0.9] );


G = bnet.dag;
draw_graph(G,Names);

% Evidencias y posibles fallas

% Se evidencia que hay una anormalidad en el caudal de la salida del tanque
% 3, entonces se da la probabilidad de que halla falla en la presion 1,
% valvula1 o en la valvula 2; luego se evidencia una altura diferente en el
% tanque 1 y luego un anormalidad en el caudal 2(entrada tanque2)

% Se evidencia que en el modo de carga hay un

motorinf{1} = jtree_inf_engine(bnet);                     % motor de inferencia joint three
motorinf{2} = likelihood_weighting_inf_engine(bnet);      % motor de inferencia likelihood

engine = jtree_inf_engine(bnet); 
% Se evidencia la variable Q3 caudal en la salida del tanque 2 presenta una
% anormalidad, se dan las probabilidades de posibles fallas dada Q3=anormal

% Usando motor de inferencia joint three (motorinf{1}) y luego
% likelihood(motorinf{2})

clear evidencia;
vector = [2 1 1 1];
evidencia  = cell(1,N);
evidencia{s1} = vector(1);
evidencia{s2} = vector(2);
evidencia{s3} = vector(3);
evidencia{s4} = vector(4);

[engine, loglik] = enter_evidence(engine, evidencia);

mf1 = marginal_nodes(engine, f1);
mf2 = marginal_nodes(engine, f2);
mf3 = marginal_nodes(engine, f3);
mf4 = marginal_nodes(engine, f4);
mf5 = marginal_nodes(engine, f5);
mg1 = marginal_nodes(engine, g1);
mg2 = marginal_nodes(engine, g2);

fprintf('P(f1|g1)=%5.3f, P(f2|g1)=%5.3f, P(f3|g1,g2)=%5.3f, P(f4|s1,s2,s3,s4)=%5.3f, P(f5|s1,s2,s3,s4)=%5.3f\n', mf1.T(falla), mf2.T(falla), mf3.T(falla), mf4.T(falla), mf5.T(falla));
fprintf('P(g1|s1,s2,s3,s4)=%5.3f, P(g2|s1,s2,s3,s4)=%5.3f\n', mg1.T(falla), mg2.T(falla));;

figure;
x=[mf1.T(falla), mf2.T(falla), mf3.T(falla), mf4.T(falla), mf5.T(falla), mg1.T(falla), mg2.T(falla)];
B=bar(x);
grid on;
axis([0 10 0 1]);
% Add title and axis labels
xlabel('evidencia');
ylabel('Probability');

