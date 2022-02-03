%% ------------------------------ Single Factor SA --------------------- %%
clear all
tic

%% select path for data %%
warning('off')
%remove path if indirect process is selected: 
rmpath('Indirect Process')
rmpath(genpath('Indirect Process'))

%add folder to directory
folder = what('Direct Process');
addpath(genpath(folder.path)) 

warning('on')


%% Import correct scenario assumptions

%% Sensitivity analysis
step = 30; %number of steps for sensitivity analysis
v_scenarios = 2; % number of scenario used

%Import sensitvity analysis restrictions
[SENSI_NUM,SENSI_TXT,~] = xlsread('Control_Sheet_V3_0_1.xlsx','Assumptions','H60:O100');

%% import for script
%% Import all other factors from Excel sheet:
% All factors are imported using an excel sheet and 4 different matrices.
% The different matrixes are imported here, once. For multiple runs of the
% alter factors directly and do not reimport the factors each step (time
% issues).

I1_initial = zeros(130,3);
I2_initial = zeros(130,3);
I3_initial = zeros(130,10);
I4_initial = zeros(130*12);

I1_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','C3:E132','basic');
I2_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','H3:J132','basic');
I3_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','M3:V132','basic');
I4_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','Y3:AJ132','basic');


%% set all resutls matrices

Result_C_total_fu = zeros(step,SENSI_NUM(3,7));
Result_Rev_total_fu = zeros(step,SENSI_NUM(3,7));
Result_Profit_total = zeros(step,SENSI_NUM(3,7));
%%
%create x-axis sensitivity analysis: 
for v_1 = 1:SENSI_NUM(3,7) 
    values_sensi =linspace(SENSI_NUM(v_1,2),SENSI_NUM(v_1,3),step);
    values_sensi = reshape(values_sensi,step,1);
    X_sensi(:,v_1) = values_sensi;
end
%%
for v = 1: SENSI_NUM(3,7) % if only one variable should be changed, alter this in the excel script
    
%create vector for sensivity analysis 
x_sensi = X_sensi(:,v);

% set import matrices into initial state: 
I1 = I1_initial;
I2 = I2_initial;
I3 = I3_initial;
I4 = I4_initial; 

 
% Select correct scenario:
[length_sensi, ~] = size(SENSI_NUM);


fu_cement_replacement = 272000;
%% Run sensitivity analysis

for w=1:step
      
 % replace sensitive variable from input matrix:
  if SENSI_NUM(v,4) == 1 % check for right input array to alter sensitive variables
    I1(SENSI_NUM(v,5),SENSI_NUM(v,6)) = x_sensi(w);
 elseif SENSI_NUM(v,4) == 2 % check for right input array to alter sensitive variables
    I2(SENSI_NUM(v,5),SENSI_NUM(v,6)) = x_sensi(w);
 elseif SENSI_NUM(v,4) == 4 % check for right input array to alter sensitive variables
    I4(SENSI_NUM(v,5),SENSI_NUM(v,6)) = x_sensi(w);
 else
     %disp('No variable in Matrix found that can be altered. This calculation wont have any results. Change input input matrix in Excel sheet !!!!!!!!!')
 end
 
run Mass_Balance_V3_0.m
run Energy_Balance_V3_0.m
run CapEx_V3_0.m
run OpEx_V3_0.m
run Revenue_Model_V3_0.m

% Calculate total costs & relative costs to produced Carbonate
Result_C_total_fu(w,v) = c_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_Rev_total_fu(w,v) = rev_total /fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_Profit_total(w,v) = rev_total - c_total; % in[EUR/a]
end

end
disp ('Calculations are done.')

%% Run for initial  outcome: 

I1 = I1_initial;
I2 = I2_initial;
I3 = I3_initial;
I4 = I4_initial; 

% set values for scenarios------------------------------------------------

fu_cement_replacement = 272000;

run Mass_Balance_V3_0.m
run Energy_Balance_V3_0.m
run CapEx_V3_0.m
run OpEx_V3_0.m
run Revenue_Model_V3_0.m

% Calculate total costs & relative costs to produced Carbonate
result_c_total_initial = c_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
result_rev_initial = rev_total /fu_cement_replacement; % in [EUR/tonne cement replacement]
result_profit_inital = rev_total - c_total; % in[EUR/a]

toc


%% ------------------------------Indirect Process --------------------%%
clearvars -except result_c_total_initial result_rev_initial result_profit_inital Result_C_total_fu Result_Rev_total_fu Result_Profit_total step SENSI_NUM X_sensi

%Remove and Add paths

warning('off')
%remove path if indirect process is selected: 
rmpath('Direct Process')
rmpath(genpath('Direct Process'))

%add folder to directory
folder = what('Indirect Process');
addpath(genpath(folder.path)) 
warning('on')
%% Import variables
M1_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','C4:C51','basic');
M2_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','I4:K211','basic');
M3_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','O4:O16','basic');
M4_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','S4:X22','basic');
M5_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','AA4:AA100','basic');
M6_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','AF5:AK6','basic');

[~,Mass_i_o_TXT,~] = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','N19:N48','basic');

%import SA restrictions 
[SENSI_NUM_indirect,SENSI_TXT,~] = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','AF10:AM100','basic');

%create x-axis sensitivity analysis: 
for v_1 = 1:SENSI_NUM_indirect(3,7) 
    values_sensi =linspace(SENSI_NUM_indirect(v_1,2),SENSI_NUM_indirect(v_1,3),step);
    values_sensi = reshape(values_sensi,step,1);
    X_sensi_indirect(:,v_1) = values_sensi;
end

%create output matrices:
Result_total_cost_fu_indirect=zeros(step,SENSI_NUM_indirect(3,7));
Result_total_rev_fu_indirect=zeros(step,SENSI_NUM_indirect(3,7));
Result_total_profit_indirect=zeros(step,SENSI_NUM_indirect(3,7));


for v = 1: SENSI_NUM_indirect(3,7)

%create vector for sensivity analysis 
x_sensi = X_sensi_indirect(:,v);

M1 = M1_initial;
M2 = M2_initial;
M3 = M3_initial;
M4 = M4_initial; 
M5 = M5_initial;
M6 = M6_initial; 


for w=1:step
      
 % replace sensitive variable from input matrix:
  if SENSI_NUM_indirect(v,4) == 1 % check for right input array to alter sensitive variables
    M1(SENSI_NUM_indirect(v,5),SENSI_NUM_indirect(v,6)) = x_sensi(w);
 elseif SENSI_NUM_indirect(v,4) == 3 % check for right input array to alter sensitive variables
    M3(SENSI_NUM_indirect(v,5),SENSI_NUM_indirect(v,6)) = x_sensi(w);
 elseif SENSI_NUM_indirect(v,4) == 5 % check for right input array to alter sensitive variables
    M5(SENSI_NUM_indirect(v,5),SENSI_NUM_indirect(v,6)) = x_sensi(w);
 else
     %disp('No variable in Matrix found that can be altered. This calculation wont have any results. Change input input matrix in Excel sheet !!!!!!!!!')
 end

fu_cement_replacement = 272000;

run Mass_Balance_indirect.m
run Energy_Balance_indirect.m 
run CAPEX_Model_indirect.m
run OPEX_Model_indirect.m
run Revenue_Model_indirect.m

Result_total_cost_fu_indirect(w,v) = Cost_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_total_rev_fu_indirect(w,v) = revenue_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_total_profit_indirect(w,v) = revenue_total-Cost_total; % in[EUR/a]


end
end
%% Run for initial  outcome: 

M1 = M1_initial;
M2 = M2_initial;
M3 = M3_initial;
M4 = M4_initial; 
M5 = M5_initial;
M6 = M6_initial; 

[result_total_cost_fu_indirect_initial, result_total_rev_fu_indirect_initial, result_total_profit_indirect_initial] = TEA_indirect_standalone(M1,M2,M3,M4,M5,M6,Mass_i_o_TXT, 1,fu_cement_replacement,0,0,0);

toc

%% Plot results --------------------------------------------------------%%
%create x axis direct:
for i_plot = 1: length(SENSI_NUM)
X_axis(:,i_plot) = (X_sensi(:,i_plot)./SENSI_NUM(i_plot))-1;
end

% create x axis indirect
for i_plot = 1: length(SENSI_NUM_indirect)
X_axis_indirect(:,i_plot) = (X_sensi_indirect(:,i_plot)./SENSI_NUM_indirect(i_plot))-1;
end

%% COsts
figure

plotstyle={'-s','-+', '-o','--s','--+','--o',':s', ':+',':o','-.s','-.+','-.o','-^','-d', '-h','--^','--d','--h',':^', ':d',':h','-.^','-.d','-.h'}; % no marker

clf; hold on
graph_tiles = tiledlayout(2,2);
Font_size_labels = 8;

%%---------------------Direct Costs--------------------------------------%%
ax1 = nexttile
hold on
    for i=1:length(SENSI_NUM)  % a loop, plot y1 against each column of X
      ph(i) = plot(X_axis(:,i)*100,((Result_C_total_fu(:,i)./result_c_total_initial).*100)-100, plotstyle{i}, 'LineWidth',1, 'MarkerSize',2);
    end
title('Direct,costs')
%legend(SENSI_TXT(2:SENSI_NUM(3,7)+1,1),'Location','EastOutside')
xlabel('Change in variable','FontSize',Font_size_labels)
ylabel('Change in LCOP','FontSize',Font_size_labels)
ytickformat('percentage');
xtickformat('percentage');
xlim( [-75 75])
ylim([-50 50])
set(gca,'FontSize',12) 
hold off;

%Profit

%%---------------------Direct profit--------------------------------------%%

ax2 = nexttile
hold on
    for i=1:length(SENSI_NUM)  % a loop, plot y1 against each column of X
      ph(i) = plot(X_axis(:,i)*100,((Result_Profit_total(:,i)./result_profit_inital).*100)-100, plotstyle{i}, 'LineWidth',1, 'MarkerSize',2);
    end
    title('Direct,profit')
%legend(SENSI_TXT(2:SENSI_NUM(3,7)+1,1),'Location','EastOutside')
xlabel('Change in variable','FontSize',Font_size_labels)
ylabel('Change in profit','FontSize',Font_size_labels)
ytickformat('percentage');
xtickformat('percentage');
xlim( [-60 60])
ylim([-60 60])
xticks([-50 0 50])
yticks([-50 0 50])
set(gca,'FontSize',12) 
hold off

%%--------------------Indirect costs--------------------------------------%%
ax3 = nexttile
hold on
    for i=1:length(SENSI_NUM_indirect)  % a loop, plot y1 against each column of X
      ph(i) = plot(X_axis_indirect(:,i)*100,((Result_total_cost_fu_indirect(:,i)./result_total_cost_fu_indirect_initial).*100)-100, plotstyle{i}, 'LineWidth',1, 'MarkerSize',2);
    end
 title('Indirect,costs')
xlabel('Change in variable','FontSize',Font_size_labels)
ylabel('Change in LCOP','FontSize',Font_size_labels)
ytickformat('percentage');
xtickformat('percentage');
xlim( [-60 60])
ylim([-60 60])
xticks([-50 0 50])
yticks([-50 0 50])
set(gca,'FontSize',12) 
hold off;

%%%---------------------------------Indirect profit------------------------
ax4 = nexttile
hold on
    for i=1:length(SENSI_NUM_indirect)  % a loop, plot y1 against each column of X
      ph(i) = plot(X_axis_indirect(:,i)*100,((Result_total_profit_indirect(:,i)./result_total_profit_indirect_initial).*100)-100, plotstyle{i}, 'LineWidth',1, 'MarkerSize',2);
    end
    title('Indirect,profit')
%legend(SENSI_TXT(2:SENSI_NUM_indirect(3,7)+1,1),'Location','EastOutside')
xlabel('Change in variable','FontSize',Font_size_labels)
ylabel('Change in profit','FontSize',Font_size_labels)
ytickformat('percentage');
xtickformat('percentage');
xlim( [-60 60])
ylim([-60 60])
xticks([-50 0 50])
yticks([-50 0 50])
set(gca,'FontSize',12) 
hold off

figure
clf


hold on
    for i=1:length(SENSI_NUM_indirect)  % a loop, plot y1 against each column of X
      ph(i) = plot(X_axis_indirect(:,i)*100,((Result_total_profit_indirect(:,i)./result_total_profit_indirect_initial).*100)-100, plotstyle{i}, 'LineWidth',1, 'MarkerSize',2);
    end
%legend(SENSI_TXT(2:SENSI_NUM_indirect(3,7)+1,1),'Location','EastOutside')
xlabel('change in variable','FontSize',Font_size_labels)
ylabel('change in profit','FontSize',Font_size_labels)
ytickformat('percentage');
xtickformat('percentage');
xlim( [-60 60])
ylim([-60 60])
xticks([-50 0 50])
yticks([-50 0 50])
set(gca,'FontSize',16) 
hold off
legend(SENSI_TXT(2:SENSI_NUM_indirect(3,7)+1,1),'Location','NorthOutside','Orientation','Horizontal','NumColumns', 6);
lh.Layout.Tile = 'North'; % <----- relative to tiledlayou
