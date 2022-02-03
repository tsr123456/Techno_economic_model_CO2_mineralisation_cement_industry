
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

%% Scenario Analysis

%% Import all other factors from Excel sheet:
% All factors are imported using an excel sheet and 4 different matrices.
% The different matrixes are imported here, once. For multiple runs of the
% alter factors directly and do not reimport the factors each step (time
% issues).

numbr_of_model_runs = 10;

Fu_cement_replacement = linspace(10000,500000,numbr_of_model_runs) ;

%% ------------------------------Direct Process------------------------- %%


I1_initial = zeros(130,3);
I2_initial = zeros(130,3);
I3_initial = zeros(130,10);
I4_initial = zeros(130*12);

I1_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','C3:E132','basic');
I2_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','H3:J132','basic');
I3_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','M3:V132','basic');
I4_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','Y3:AJ132','basic');


%% set all resutls matrices

Result_C_total_fu_direct = zeros(numbr_of_model_runs,1);
Result_Rev_total_fu_direct = zeros(numbr_of_model_runs,1);
Result_Profit_total_direct = zeros(numbr_of_model_runs,1);
Result_CapEx_direct = zeros(numbr_of_model_runs,8);
Result_share_replaced_direct = zeros(numbr_of_model_runs,4);
NUMBR_Equipment_direct = zeros(numbr_of_model_runs,5);

 % if only one variable should be changed, alter this in the excel script
    
% set import matrices into initial state: 
I1 = I1_initial;
I2 = I2_initial;
I3 = I3_initial;
I4 = I4_initial; 

    
%% Run Calculation

for i_TEA=1 : numbr_of_model_runs

fu_cement_replacement = Fu_cement_replacement(i_TEA);
    
run Mass_Balance_V3_0.m
run Energy_Balance_V3_0.m
run CapEx_V3_0.m
run OpEx_V3_0.m
run Revenue_Model_V3_0.m

% Calculate total costs & relative costs to produced Carbonate
Result_C_total_fu_direct(i_TEA,1) = c_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_Rev_total_fu_direct(i_TEA,1) = rev_total /fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_Profit_total_direct(i_TEA,1) = rev_total - c_total; % in[EUR/a]
Result_CapEx_direct(i_TEA,:) = [capEx_crush, capEx_mill, capEx_furnace, capEx_reactor, capEx_heatexchanger, capEx_compression, capEx_capture, capEx_post_treatment];
Result_share_replaced_direct(i_TEA,:) = [share_SiO2_replaced,(1-share_SiO2_replaced),share_inert_replaced,(1-share_inert_replaced)];% share of SIO2 & inert replaced
NUMBR_Equipment_direct(i_TEA,:) = [numbr_reactor,numbr_he_1,numbr_cyclones./100, numbr_class_centrifuge,numbr_dewater_2];


end

W_total_direct = W_total;
Ng_total_direct = Ng_total;
Result_share_replaced_direct = Result_share_replaced_direct;

disp ('Calculations direct complete.')

%% -------------------Indirect Process--------------------------------- %%
clearvars -except Result_C_total_fu_direct Result_Rev_total_fu_direct Result_Profit_total_direct Result_CapEx_direct Result_share_replaced_direct NUMBR_Equipment_direct numbr_of_model_runs Fu_cement_replacement C_total W_total_direct Ng_total_direct Result_share_replaced_direct

%Remove and Add paths
warning('off')
%remove path if indirect process is selected: 
rmpath('Direct Process')
rmpath(genpath('Direct Process'))

%add folder to directory
folder = what('Indirect Process');
addpath(genpath(folder.path)) 

warning('on')

%% Create results matrices

Result_total_cost_fu_indirect = zeros(numbr_of_model_runs,1);
Result_total_rev_fu_indirect = zeros(numbr_of_model_runs,1);
Result_total_profit_indirect = zeros(numbr_of_model_runs,1);
Result_Capex_indirect = zeros(numbr_of_model_runs,15);
Result_share_replaced_indirect = zeros(numbr_of_model_runs,4);
Result_Numbr_eq_indirect = zeros(numbr_of_model_runs,15);
W_separation_indirect = zeros(numbr_of_model_runs,1);
M_replaced_total = zeros(numbr_of_model_runs,1);


%% Import variables
M1_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','C4:C72','basic');
M2_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','I4:K211','basic');
M3_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','O4:O16','basic');
M4_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','S4:X22','basic');
M5_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','AA4:AA72','basic');
M6_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','AF5:AK6','basic');

[~,Mass_i_o_TXT,~] = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','N19:N48','basic');


    
% set import matrices into initial state: 
M1 = M1_initial;
M2 = M2_initial;
M3 = M3_initial;
M4 = M4_initial; 
M5 = M5_initial;
M6 = M6_initial; 

    
%% Run Calculation


for i_TEA=1 : numbr_of_model_runs

fu_cement_replacement = Fu_cement_replacement(i_TEA);
    
run Mass_Balance_indirect.m
run Energy_Balance_indirect.m 
run CAPEX_Model_indirect.m
run OPEX_Model_indirect.m
run Revenue_Model_indirect.m

% Calculate total costs & relative costs to produced Carbonate
Result_total_cost_fu_indirect(i_TEA,1) = Cost_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_total_rev_fu_indirect(i_TEA,1) = revenue_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_total_profit_indirect(i_TEA,1) = revenue_total-Cost_total; % in[EUR/a]
M_replaced_total (i_TEA,1)= m_replaced_total;
Result_Capex_indirect(i_TEA,:) = CapEx_all;
Result_share_replaced_indirect (i_TEA,:) = [share_SiO2_replaced,(1-share_SiO2_replaced),share_inert_replaced,(1-share_inert_replaced)];% share of SIO2 & inert replaced
Result_Numbr_eq_indirect(i_TEA,:) = Numbr_eq;
W_separation_indirect(i_TEA,1) = w_separation;
end

disp ('Calculations indirect complete.')

%% -------------------------------- Plot Results------------------------ %%

color2=[0.1986, 0.7214,0.6310];
color1=[0.9856,0.7372, 0.2537];
color_area_neg =[0.9856,0.7372, 0.2537]; %[0.886, 0.250, 0.313];
color_area_pos = [0.1986 0.7214 0.6310];
area_trans =0.2;
size_font= 16;

plotstyle={'-','-', '-','--','--','--',':', ':',':','-.','-.','-.','-','-', '-','--','--','--',':', ':',':','-.','-.','-.'}; % no marker
%plotstyle={'-s','-+', '-o','--s','--+','--o',':s', ':+',':o','-.s','-.+','-.o','-^','-d', '-h','--^','--d','--h',':^', ':d',':h','-.^','-.d','-.h'}; % no marker

%% -------------------------------CapEx--------------------------------- %%
figure
graph_tiles = tiledlayout(1,2); % Requires R2019b or later
colors = [0 0.4470 0.7410; 	0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; 0.4940 0.1840 0.5560; 0.4660 0.6740 0.1880; 0.3010 0.7450 0.9330; 0.6350 0.0780 0.1840];


%Regroup results
Capex_pre_treatment_direct = Result_CapEx_direct(:,1)+ Result_CapEx_direct(:,2)+Result_CapEx_direct(:,3);
Capex_reactors_direct = Result_CapEx_direct(:,4);
Capex_heat_exchange_direct = Result_CapEx_direct(:,5);
Capex_compression_direct = Result_CapEx_direct(:,6);
Capex_capture_direct = Result_CapEx_direct(:,7);
Capex_post_treatment_direct = Result_CapEx_direct(:,8);
Result_CapEx_direct_plot = [Capex_pre_treatment_direct, Capex_reactors_direct,Capex_heat_exchange_direct,Capex_capture_direct, Capex_compression_direct, Capex_post_treatment_direct]./10^6;

result_plot_CapEx_direct = nexttile;

area_plot = area(Fu_cement_replacement, Result_CapEx_direct_plot,'FaceAlpha',area_trans ,'LineStyle','none');
%bar(Fu_cement_replacement, Result_CapEx_direct_plot,'stacked','FaceAlpha',area_trans ,'LineStyle','none');
figure_legends_capex = {'Pre-Treatment', 'Reactors', 'Heat Exchangers & furnaces','Capture', 'Compression','Post-treatment'};
xlim([1 Fu_cement_replacement(end)])
title('Direct','FontSize',size_font)
%xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',size_font)
%box off
hold on
left = 0;
for i_plot = 1:6
        line = Result_CapEx_direct_plot(:,i_plot)+ left;
    plot_line(i_plot) = plot(Fu_cement_replacement, line, 'LineStyle','-','color',colors(i_plot,:), 'LineWidth',2);
    left = left+Result_CapEx_direct_plot(:,i_plot);
end
legend(plot_line([6 5 4 3 2 1]),figure_legends_capex([6 5 4 3 2 1]),'Location','northwest','FontSize',size_font-3)
legend('boxoff')
set(gca,'FontSize',size_font-2)


Capex_pre_treatment_indirect = Result_Capex_indirect(:,1)+Result_Capex_indirect(:,2);
Capex_reactors_indirect = Result_Capex_indirect(:,3)+Result_Capex_indirect(:,4)+Result_Capex_indirect(:,5);
Capex_heat_exchange_direct = Result_Capex_indirect(:,6)+Result_Capex_indirect(:,7)+Result_Capex_indirect(:,9)+Result_Capex_indirect(:,10)+Result_Capex_indirect(:,11);
Capex_add_regeneration_indirect = Result_Capex_indirect(:,8)+Result_Capex_indirect(:,12);
Capex_capture_indirect = Result_Capex_indirect(:,15);
Capex_post_treatment_indirect = Result_Capex_indirect(:,13)+Result_Capex_indirect(:,14);
Result_CapEx_indirect_plot =[Capex_pre_treatment_indirect, Capex_reactors_indirect,Capex_heat_exchange_direct, Capex_capture_indirect, Capex_add_regeneration_indirect, Capex_post_treatment_indirect]./10^6;

result_plot_CapEx_indirect = nexttile;
area_plot2 = area(Fu_cement_replacement, Result_CapEx_indirect_plot,'FaceAlpha',area_trans ,'LineStyle','none');
%bar(Fu_cement_replacement, Result_CapEx_indirect_plot,'stacked','FaceAlpha',area_trans ,'LineStyle','none');
figure_legends_capex = {'Pre-Treatment', 'Reactors', 'Heat Exchangers & furnaces','Capture', 'Additive-Regeneration','Post-treatment'};
legend('boxoff')
title('Indirect','FontSize',size_font)

%box off
hold on
%xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',size_font)
left =0;
for i_plot = 1:6
    line = Result_CapEx_indirect_plot(:,i_plot)+ left;
    plot_line2(i_plot) = plot(Fu_cement_replacement, line, 'LineStyle','-','color',colors(i_plot,:), 'LineWidth',2);
    left = left+Result_CapEx_indirect_plot(:,i_plot);
    
end
legend(plot_line2([6 5 4 3 2 1]),figure_legends_capex([6 5 4 3 2 1]),'Location','northwest','FontSize',size_font-3)
set(gca,'FontSize',size_font-2)
xlim([1 Fu_cement_replacement(end)])
%
graph_tiles.TileSpacing = 'none';
xlabel(graph_tiles,'Plant capacity in [t_{cement replacment}/a]','FontSize',size_font)
ylabel(graph_tiles,'Total captial required in [M€]','FontSize',size_font)
linkaxes([result_plot_CapEx_direct result_plot_CapEx_indirect],'y')

hold off;



%% --------------------------- Total Costs Pie ------------------------- %%

figure
graph_tiles = tiledlayout(1,2);

%%% Direct
for i_TEA_Model = 1:5
C_total_fu = C_total(:,i_TEA_Model)./Fu_cement_replacement;
end

TCP_direct_pie = nexttile;
TP_ax_direct = gca();
TP_direct = pie (TP_ax_direct,C_total./fu_cement_replacement);
TP_ax_direct.Colormap = colors(1:5,:);
set(findobj(TP_direct,'type','text'),'fontsize',size_font-2)
set(findobj(TP_direct, '-property', 'FaceAlpha'), 'FaceAlpha', 0.6);
set(findobj(TP_direct, '-property', 'EdgeAlpha'), 'EdgeAlpha', 0.4);
labels = {'Utilities','Feedstock','Transport','Annual CapEx','Opex fixed'};
L_direct = legend(labels,'Location','northwestoutside','Orientation','vertical');
legend('boxoff')
box off

%title (strcat('Total cost of production: ',num2str(Result_C_total_fu_direct(numbr_of_model_runs)),'€/tonne'));
title ('Direct')
set(gca,'FontSize',size_font)
hold on

%%% Indirect
TCP_indirect_pie = nexttile;

TCP_utilities = results_opex_table(1)+results_opex_table(2);
TCP_minerals = results_opex_table(3);
TCP_transport = results_opex_table(4);
TCP_Annual_Cap_Ex = results_opex_table(5);
TCP_Opex_fixed =   sum(results_opex_table(6:8));

TP_ax_indirect = gca();
TP_indirect = pie (TP_ax_indirect,[TCP_utilities,TCP_minerals,TCP_transport, TCP_Annual_Cap_Ex,TCP_Opex_fixed] );
TP_ax_indirect.Colormap = colors(1:5,:);
set(findobj(TP_indirect,'type','text'),'fontsize',size_font-2)
set(findobj(TP_indirect, '-property', 'FaceAlpha'), 'FaceAlpha', 0.6);
set(findobj(TP_indirect, '-property', 'EdgeAlpha'), 'EdgeAlpha', 0.4);

%labels = {'Energy','Chemicals','Mineral','Transport','Annualized CapEx','Maintenance', 'Labour', 'Insurance & tax'};
%legend(labels,'Location','southoutside','Orientation','horizontal')
%title (strcat('Total cost of production: ',num2str( Result_total_cost_fu_indirect(numbr_of_model_runs)),'€/tonne'));
title('Indirect')
set(gca,'FontSize',size_font)

%% ---------------------------- Number of Eqipment used ---------------- %%

% Direct
% Number of Equipment used:
figure
graph_tiles = tiledlayout(1,2);

%Plot & set y limits:
equipment_plot_direct = nexttile;
plot(equipment_plot_direct, Fu_cement_replacement,NUMBR_Equipment_direct,'LineStyle','-','LineWidth',2);
ylim(equipment_plot_direct,[0 30])


%add legend & Titles
figure_legends_equipment = {'Number of Reactors', 'Number of Heat Exchangers', 'Number of Cyclones (1/100)pcs', 'Number of dewater centrifuge (stage I)', 'Number of dewater centrifuge (stage II)'};
legend(figure_legends_equipment,'Location','northwest','fontsize',size_font-2)
legend('boxoff')

box off
title('Direct')
set(gca,'FontSize',size_font)
hold on

% Indirect
%Plot & set y limits:
equipment_plot_indirect =   nexttile;
plot(equipment_plot_indirect,Fu_cement_replacement,Result_Numbr_eq_indirect,'LineStyle','-','LineWidth',2);
ylim(equipment_plot_indirect,[0 12])

%add legend & Titles
figure_legends_equipment = Equipment_CapEx;
legend(figure_legends_equipment,'Location','northwest','fontsize',size_font-2)
legend('boxoff')
box off
title('Indirect')
set(gca,'FontSize',size_font)
%add labels for entire figure
graph_tiles.TileSpacing = 'none';
xlabel(graph_tiles,'Plant capacity in [t_{cement replacment}/a]','FontSize',size_font)
ylabel(graph_tiles,'Number of Equipment','FontSize',size_font)
%linkaxes([equipment_plot_direct equipment_plot_indirect],'y')

hold off;



%% ---------------------------Mineral used ------------------------------%%
figure
graph_tiles = tiledlayout(2,2);

%%Direct
size_font = 14

nexttile
result_plot_sio_direct = area(Fu_cement_replacement, Result_share_replaced_direct (:,1:2),'FaceAlpha',area_trans+0.2,'LineStyle','none');
set(result_plot_sio_direct(1),'FaceColor',color2)
set(result_plot_sio_direct(2),'FaceColor',color1)
xlim([0 500000])
title('Direct, SiO_{2} usage','FontSize',size_font-2)
set(gca,'FontSize',size_font)

nexttile
result_plot_inert_direct = area(Fu_cement_replacement, Result_share_replaced_direct (:,3:4),'FaceAlpha',area_trans+0.2,'LineStyle','none');
set(result_plot_inert_direct(1),'FaceColor',color2)
set(result_plot_inert_direct(2),'FaceColor',color1)
xlim([0 500000])
figure_legends_capex = {'In product', 'Stored'};
legend(figure_legends_capex,'Location','northeastoutside','Fontsize', size_font)
legend('boxoff')
title('Direct, inert usage','FontSize',size_font-4)
set(gca,'FontSize',size_font)

%%Indirect

nexttile
result_plot_sio2_indirect = area(Fu_cement_replacement, Result_share_replaced_indirect (:,1:2),'FaceAlpha',area_trans+0.2,'LineStyle','none');
figure_legends_capex = {'SiO_{2} in product', 'SiO_{2} stored'};
set(result_plot_sio2_indirect(1),'FaceColor',color2)
set(result_plot_sio2_indirect(2),'FaceColor',color1)
xlim([0 500000])
title('Indirect, SiO_{2} usage','FontSize',size_font-4)
set(gca,'FontSize',size_font)

nexttile
result_plot_inert_indirect = area(Fu_cement_replacement, Result_share_replaced_indirect (:,3:4),'FaceAlpha',area_trans+0.2,'LineStyle','none');
set(result_plot_inert_indirect(1),'FaceColor',color2)
set(result_plot_inert_indirect(2),'FaceColor',color1)
xlim([0 500000])
title('Indirect, inert usage','FontSize',size_font-4)
set(gca,'FontSize',size_font)

graph_tiles.TileSpacing = 'none';
xlabel(graph_tiles,'Capacity in [t_{SCM}/a]','FontSize',size_font)
ylabel(graph_tiles,'Share of material usage','FontSize',size_font)


toc
