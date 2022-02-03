%% --------------Standalone Script Indirect Process ------------------- %%

function [Result_Levelised_costs_of_product,Result_Revenue,Result_Profit,Result_GHG_reduction, Result_GHG_total] = Economic_analysis_indirect_mineralisation(numbr_of_model_runs, Capacity, Price_ETS, Price_Cement , Silica_content_in_cement, Inert_content_in_cement, Distance_transport, GHG_intensity_electricity, GHG_intensity_NG )

%% select path for data %%
warning('off')
%remove path if indirect process is selected: 
rmpath('Direct Process')
rmpath(genpath('Direct Process'))

%add folder to directory
folder = what('Indirect Process');
addpath(genpath(folder.path)) 

warning('on')

%%  Import all other factors from Excel sheet:
% All factors are imported using an excel sheet with 6 different matrices.
% The different matrixes are imported here, once. For multiple runs,
% alter factors directly and do not reimport the factors of each step (time
% issues).

M1 = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','C4:C51','basic');
M2 = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','I4:K211','basic');
M3 = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','O4:O16','basic');
M4 = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','S4:X22','basic');
M5 = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','AA4:AA100','basic');
M6 = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','AF5:AK6','basic');

[~,Mass_i_o_TXT,~] = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','N19:N48','basic');

%% create output matrixes
Result_Levelised_costs_of_product = zeros(numbr_of_model_runs,1);
Result_Revenue = zeros(numbr_of_model_runs,1);
Result_Profit = zeros(numbr_of_model_runs,1);
Result_GHG_reduction = zeros(numbr_of_model_runs,1);
CO2_captured_indirect = zeros(numbr_of_model_runs,1);

for i_TEA_Model=1 : numbr_of_model_runs
    
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
M5(51,1) = Price_ETS(i_TEA_Model);
elseif isempty(Price_ETS) == 1
    %dont't change anything if the variable does not have a value
elseif length(Price_ETS) == 1
M5(51,1) = Price_ETS(1);
end
end

if exist('Price_Cement','var')
if length(Price_Cement) >1
M5(50,1) = Price_Cement(i_TEA_Model);
elseif isempty(Price_Cement) == 1
    %dont't change anything if the variable does not have a value
elseif length(Price_Cement) == 1
M5(50,1) = Price_Cement(1);
end
end

if exist('Distance_transport','var')
if length(Distance_transport) >1
M5(36,1) = Distance_transport(i_TEA_Model);
elseif isempty(Distance_transport) == 1
    %dont't change anything if the variable does not have a value
elseif length(Distance_transport) == 1
M5(36,1) = Distance_transport(1);
end
end


if exist('Silica_content_in_cement','var')
if length(Silica_content_in_cement) >1
M5(39,1) = Silica_content_in_cement(i_TEA_Model);
elseif isempty(Silica_content_in_cement) == 1
    %dont't change anything if the variable does not have a value
elseif length(Silica_content_in_cement) == 1
M5(39,1) = Silica_content_in_cement(1);
end
end

if exist('Inert_content_in_cement','var')
if length(Inert_content_in_cement) >1
M5(40,1) = Inert_content_in_cement(i_TEA_Model);
elseif isempty(Inert_content_in_cement) == 1
    %dont't change anything if the variable does not have a value
elseif length(Inert_content_in_cement) == 1
M5(40,1) = Inert_content_in_cement(1);
end
end

if exist('GHG_intensity_electricity','var')
if length(GHG_intensity_electricity) >1
M5(52,1) = GHG_intensity_electricity(i_TEA_Model);
elseif isempty(GHG_intensity_electricity) == 1
    %dont't change anything if the variable does not have a value
elseif length(GHG_intensity_electricity) == 1
M5(52,1) = GHG_intensity_electricity(1);
end
end

if exist('GHG_intensity_NG','var')
if length(GHG_intensity_NG) >1
M5(53,1) = GHG_intensity_NG(i_TEA_Model);
elseif isempty(GHG_intensity_NG) == 1
    %dont't change anything if the variable does not have a value
elseif length(GHG_intensity_NG) == 1
M5(53,1) = GHG_intensity_NG(1);
end
end

run Mass_Balance_indirect.m
run Energy_Balance_indirect.m 
run CAPEX_Model_indirect.m
run OPEX_Model_indirect.m
run Revenue_Model_indirect.m


% Calculate total costs & relative costs to produced Carbonate
Result_Levelised_costs_of_product(i_TEA_Model) = Cost_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_Revenue(i_TEA_Model) = revenue_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_Profit(i_TEA_Model) = revenue_total-Cost_total; % in[EUR/a]
Result_GHG_reduction (i_TEA_Model) = 1-(size_cement_plant*ghg_cement+ghg_total)/(size_cement_plant*ghg_cement); % GHG reduction in % to benchmark (w/o carbonation)
CO2_captured_indirect(i_TEA_Model) = m_CO2_stored / (size_cement_plant*ghg_cement/1000);
Result_GHG_total(i_TEA_Model,:) = Ghg_total;
end


end