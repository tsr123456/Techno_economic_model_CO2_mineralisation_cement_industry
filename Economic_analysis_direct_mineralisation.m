function [Result_Levelised_costs_of_product,Result_Revenue,Result_Profit,Result_GHG_reduction,Result_GHG_total ] = Economic_analysis_direct_mineralisation(numbr_of_model_runs, Capacity, Price_ETS, Price_Cement ,Silica_content_in_cement, Inert_content_in_cement,Distance_transport, GHG_intensity_electricity, GHG_intensity_NG )
%% select path for data %%
warning('off')
%remove path if indirect process is selected: 
rmpath('Indirect Process')
rmpath(genpath('Indirect Process'))

%add folder to directory
folder = what('Direct Process');
addpath(genpath(folder.path)) 

warning('on')

%% Import all other factors from Excel sheet:
% All factors are imported using an excel sheet and 4 different matrices.
% The different matrixes are imported here, once. For multiple runs of the
% alter factors directly and do not reimport the factors each step (time
% issues).

I1 = zeros(130,3);
I2 = zeros(130,3);
I3 = zeros(130,10);
I4 = zeros(130,12);

I1 = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','C3:E132','basic');
I2 = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','H3:J132','basic');
I3 = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','M3:V132','basic');
I4 = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','Y3:AJ132','basic');

% I1 is the import array one; fixed assumptions
% I2 is the import array two; time or location dependent factors
% I3 is the import array three;  

%% set all resutls matrices

Result_Levelised_costs_of_product = zeros(numbr_of_model_runs,1);
Result_Revenue = zeros(numbr_of_model_runs,1);
Result_Profit = zeros(numbr_of_model_runs,1);
Result_CapEx = zeros(numbr_of_model_runs,8);
Result_Share_mineral_used = zeros(numbr_of_model_runs,4);
Result_table_number_of_equipment_designed = zeros(numbr_of_model_runs,5);
Result_GHG_reduction = zeros(numbr_of_model_runs,1);

%% Set default for capacity if not specified -----------------------------

Fu_cement_replacement = linspace(10000,272000,numbr_of_model_runs) ; %1.7760e+06  1700000[t/a].The functional unit used, will be the amount of cement replacement/ clinker replacement produced. It consist of Silica (50%) and (50%)inert material. As the stoichiometry shows us, that more Silica is produced in the reaction. The calculations focus on this production. 
   
global max_diameter 
max_diameter = 0.5;

%% run all scripts
for i_TEA_Model = 1:numbr_of_model_runs

     
%replace inputs, if needed:  
if exist('Capacity','var')    
if length(Capacity) >1 
fu_cement_replacement = Capacity(i_TEA_Model);
elseif isempty(Capacity) == 1
 fu_cement_replacement = Fu_cement_replacement(i_TEA_Model); %dont't change anything if the variable does not have a value
elseif length(Capacity) == 1     
fu_cement_replacement = Capacity(1); 
end
end

if exist('Price_ETS','var')
if length(Price_ETS) >1
I1(57,1) = Price_ETS(i_TEA_Model);
elseif isempty(Price_ETS) == 1
    %dont't change anything if the variable does not have a value
elseif length(Price_ETS) ==1
I1(57,1) = Price_ETS(1);
end
end

if exist('Price_Cement','var')
if length(Price_Cement) >1
I1(56,1) = Price_Cement(i_TEA_Model);
elseif isempty(Price_Cement) == 1
    %dont't change anything if the variable does not have a value
elseif length(Price_Cement) ==1
I1(56,1) = Price_Cement(1);
end
end

if exist('Silica_content_in_cement','var')
if length(Silica_content_in_cement) >1
I1(59,1) = Silica_content_in_cement(i_TEA_Model);% set silica content in produced cement
elseif isempty(Silica_content_in_cement) == 1
    %dont't change anything if the variable does not have a value
elseif length(Silica_content_in_cement) ==1
I1(59,1) = Silica_content_in_cement(1);    
end
end

if exist ('Inert_content_in_cement','var')
if length(Inert_content_in_cement) >1
I1(60,1) = Inert_content_in_cement(i_TEA_Model); %set inert content in product
elseif isempty(Inert_content_in_cement) == 1
    %dont't change anything if the variable does not have a value
elseif length(Inert_content_in_cement) ==1
I1(60,1) = Inert_content_in_cement(1);
end
end

if exist('Distance_transport','var')
if length(Distance_transport) >1
I1(48,1) = Distance_transport(i_TEA_Model);
elseif isempty(Distance_transport) == 1
    %dont't change anything if the variable does not have a value
elseif length(Distance_transport) ==1
  I1(48,1) = Distance_transport(1);  
end
end

if exist('GHG_intensity_electricity','var')
if length(GHG_intensity_electricity) >1
I1(70,1) = GHG_intensity_electricity(i_TEA_Model);
elseif isempty(GHG_intensity_electricity) == 1
    %dont't change anything if the variable does not have a value
elseif length(GHG_intensity_electricity) ==1
  I1(70,1) = GHG_intensity_electricity(1);  
end
end

if exist('GHG_intensity_NG','var')
if length(GHG_intensity_NG) >1
I1(71,1) = GHG_intensity_NG(i_TEA_Model);
elseif isempty(GHG_intensity_NG) == 1
    %dont't change anything if the variable does not have a value
elseif length(GHG_intensity_NG) ==1
  I1(71,1) = GHG_intensity_NG(1);  
end
end

run Mass_Balance_V3_0.m
run Energy_Balance_V3_0.m
run CapEx_V3_0.m
run OpEx_V3_0.m
run Revenue_Model_V3_0.m

Result_Levelised_costs_of_product(i_TEA_Model,1) = c_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_Revenue(i_TEA_Model,1) = rev_total/fu_cement_replacement ; % in [EUR/tonne cement replacement]
Result_Profit(i_TEA_Model,1) = rev_total - c_total; % in[EUR/a]
Result_CapEx(i_TEA_Model,:) = [capEx_crush, capEx_mill, capEx_furnace, capEx_reactor, capEx_heatexchanger, capEx_compression, capEx_capture, capEx_post_treatment];
Result_Share_mineral_used (i_TEA_Model,:) = [share_SiO2_replaced,(1-share_SiO2_replaced),share_inert_replaced,(1-share_inert_replaced)];% share of SIO2 & inert replaced
Result_table_number_of_equipment_designed (i_TEA_Model,:) = [numbr_reactor,numbr_he_1,numbr_cyclones./100, numbr_class_centrifuge,numbr_dewater_2];
Result_GHG_reduction(i_TEA_Model) = 1-(size_cement_plant*ghg_cement+ghg_total)/(size_cement_plant*ghg_cement); % in[EUR/a]
Result_GHG_total (i_TEA_Model,:) = Ghg_total;

%Result_GHG = table(Labels_GHG,GHG_plot,GHG_plot_fu)
%Result_GHG.Properties.VariableNames ={'Description'; 'GHG';'Spec. GHG' }
end
end