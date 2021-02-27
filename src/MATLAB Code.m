%% CH4 predict
% clean all
% clear
% clc
%% 1 Data
A = xlsread('data-12-4.xlsx','BT');
B = xlsread('data-12-4.xlsx','ACS');
PCA = xlsread('data-12-4.xlsx','PCA-1');

model = 'all'; % all or pow
datasource = 'nor'; % PCA or nor or cor or two

if model == 'all'
    a_row = [42:119];
    b_row = [1:65];
    c_row = [1:65];
    PCA_col = [4:6];       
    PAC_row = [1:240];
    a_pre = [6,8,9];%6,11
    b_pre = [9,13,15];%9,17
    c_pre = [10,14,16];%10,18
    reg_tar = [6,7];
    if datasource == 'nor'
        reg_tar = [6,7,8];
    end  
elseif model == 'pow'
    a_row = [56:110];
    b_row = [46:65];
    c_row = [46:65];
    PCA_col = [1:2];
    PAC_row = [1:95];
    a_pre = [11];%6,11,8,9
    b_pre = [17];%9,17,13,15
    c_pre = [18];%10,18,14,16
    reg_tar = [4];
    if datasource == 'nor'
        reg_tar = [6];
        a_pre = [11];%6,11,8,9
        b_pre = [17];%9,17,13,15
        c_pre = [18];%10,18,14,16
    elseif datasource == 'two'
        reg_tar = [9];
    end     
end

if datasource == 'nor'
    a_tra = [1,2,3,4,12];% 1 2 3 4 8 9
    b_tra = [1,2,3,5,19];%1 2 3 5 13 15
	c_tra = [1,2,3,6,20];% 1 2 3 6 14 16
    reg_in = [1:5];
elseif datasource == 'two'
    a_tra = [1,2,3,4,12,13,14,15];% 1 2 3 4 8 9
    b_tra = [1,2,3,5,19,21,22,23];%1 2 3 5 13 15
	c_tra = [1,2,3,6,20,24,25,26];% 1 2 3 6 14 16
    reg_in = [1:8];
elseif datasource == 'cor'
    a_tra = [1,2,3];% 1 2 3 4 8 9
	b_tra = [1,2,3];%1 2 3 5 13 15
	c_tra = [1,2,3];% 1 2 3 6 14 16
    reg_in = [1:3];
end

%% 2 Normalize

input_a = A(a_row,a_tra)';
[input_a_in,ps_input_a] = mapminmax(input_a);

target_a =  A(a_row,a_pre)';
[target_a_in,ps_target_a] = mapminmax(target_a);

input_b = B(b_row,b_tra)';
[input_b_in,ps_input_b] = mapminmax(input_b);

target_b =  B(b_row,b_pre)';
[target_b_in,ps_target_b] = mapminmax(target_b);

input_c = B(c_row,c_tra)';
[input_c_in,ps_input_c] = mapminmax(input_c);

target_c =  B(c_row,c_pre)';
[target_c_in,ps_target_c] = mapminmax(target_c);



input_all = [];
for i = 1:length(input_a)
    input_all(:,i) =  input_a(:,i);
end
l_b = length(input_all);
for i = 1:length(input_b)
    input_all(:,l_b+i) =  input_b(:,i);
end
l_c = length(input_all);
for i = 1:length(input_c)
    input_all(:,l_c+i) =  input_c(:,i);
end
input_plot = input_all;

target_all = [];
for i = 1:length(target_a)
    target_all(:,i) =  target_a(:,i);
end
l_b = length(target_all);
for i = 1:length(target_b)
    target_all(:,l_b+i) =  target_b(:,i);
end
l_c = length(target_all);
for i = 1:length(target_c)
    target_all(:,l_c+i) =  target_c(:,i);
end



if datasource == 'PCA'
    input_all = PCA(PAC_row,PCA_col)';
    reg_in = [1:2];
    reg_tar = [3];
end

[inputall_in,ps_inputall] = mapminmax(input_all);
[targetall_in,ps_targetall] = mapminmax(target_all);
 
regression = [];
regression(reg_in,:) = inputall_in;
regression(reg_tar,:) = targetall_in;

fid=fopen('data.txt','w');
% fprintf(fid,'%.8f\t%.8f\t%.8f\t%.8f\t%.8f\t%.8f\t%.8f\t%.8f\t%.8f\r\n',regression);
fprintf(fid,'%.8f\t%.8f\t%.8f\t%.8f\t%.8f\t%.8f\r\n',regression);
fclose(fid);

% network1_outputs = cell2mat(output);
network1_outputs = output_BP_10_noPCA;
prediction = mapminmax('reverse',network1_outputs,ps_targetall);
% predictionb = mapminmax('reverse',network2_outputs,ps_targetall);
% predictionc = mapminmax('reverse',network2_outputs,ps_targetall);

% Power-on BP-NN noPCA
l=length(input_all);
x = [1:l];
figure(2)
plot(x,target_all(1,:),"-o");
hold on
plot(x, prediction(1,:));
legend("Exprimental value of CH4 yield via DET", "Predictive value of CH4 yield via DET");
xlabel('Time(d)','FontWeight','bold')
ylabel('Yield(mg COD/L)','FontWeight','bold')



% plot(prediction,target_all)

%%3 Plot
l=length(input_all);
x = [3:l];
% figure(1)
% plot(x,target_all(1:2,:),"-o");
% hold on
% plot(x, prediction(1:2,:));
% legend("Exprimental value of CH4 yield","Exprimental value of CH4 yield via DET",...
%   "Predictive value of CH4 yield", "Predictive value of CH4 yield via DET" );
% xlabel('Time(d)','FontWeight','bold')
% ylabel('Yield(mgCOD/L)','FontWeight','bold')

figure(2)
plot(x,target_all(1,3:l),"-o");
hold on
plot(x, prediction(1,:));
legend("Exprimental value of CH4 yield via DET", "Predictive value of CH4 yield via DET");
xlabel('Time(d)','FontWeight','bold')
ylabel('Yield(mg COD/L)','FontWeight','bold')

figure(3)
plot(x,target_all(2:3,3:l),"-o");
hold on
plot(x, prediction(2:3,:));
legend("Exprimental value of TIC yield","Exprimental value of CO2 yield","Predictive value of TIC yield","Predictive value of CO2 yield" );
xlabel('Time(d)','FontWeight','bold')
ylabel('Yield(m mol/L)','FontWeight','bold')

% figure(4)
% plot(x,target_all(3,3:l),"-o");
% hold on
% plot(x, prediction(3,:));
% legend("Exprimental value of TIC yield","Predictive value of TIC yield" );
% xlabel('Time(d)','FontWeight','bold')
% ylabel('Yield(m mol)','FontWeight','bold')

% % fitting all term
% plot(t,CH4,"-o");
% hold on
% plot(t,CH4_p1);
% legend("real","predict")
% fitting on power-on term
% plot(t(S2_int:S2_fin),CH4(S2_int:S2_fin),"-o");
% hold on
% plot(t(S2_int:S2_fin),CH4_p2);
% legend("real","predict")
% plot(t(28:53),Stab_1,"*");
% hold on 
% plot(t(54:102),Stab_2,"*");


figure(5)
bar(x,cell2mat(error1'))
hold on 
legend("Errors of predictive CH4 yield", "Errors of predictive CH4 yield via DET",...
    "Errors of predictive TIC yield")
xlabel('Time(d)')
ylabel('Normalized error')
