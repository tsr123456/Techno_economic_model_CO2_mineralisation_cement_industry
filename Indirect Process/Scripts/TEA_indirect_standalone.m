%% --------------Standalone Script Indirect Process ------------------- %%

function [Result_total_cost_fu_indirect,Result_total_rev_fu_indirect,Result_total_profit_indirect,GHG_reduction,CO2_captured_indirect] = TEA_indirect_standalone(M1,M2,M3,M4,M5,M6,Mass_i_o_TXT, numbr_of_model_runs,Fu_cement_replacement, pc_ETS, content_SiO2, content_inert,transport_train,numbr_plants)

Result_total_cost_fu_indirect = zeros(numbr_of_model_runs,1);
Result_total_rev_fu_indirect = zeros(numbr_of_model_runs,1);
Result_total_profit_indirect = zeros(numbr_of_model_runs,1);
GHG_reduction = zeros(numbr_of_model_runs,1);
CO2_captured_indirect = zeros(numbr_of_model_runs,1);

for i_TEA=1 : numbr_of_model_runs
    
if length(Fu_cement_replacement) >1 
fu_cement_replacement = Fu_cement_replacement(i_TEA);
else 
fu_cement_replacement = Fu_cement_replacement(1); 
end

if exist('pc_ETS','var')
if length(pc_ETS) >1
M5(51,1) = pc_ETS(i_TEA);
end
end

if exist('content_SiO2','var')
if length(content_SiO2) >1
M5(39,1) = content_SiO2(i_TEA);
end
end

if exist('content_inert','var')
if length(content_inert) >1
M5(40,1) = content_inert(i_TEA);
end
end

if exist('transport_train','var')
if length(transport_train) >1
M5(36,1) = transport_train(i_TEA);
end
end

if exist('numbr_plants','var')
if length(numbr_plants) >1
M5(64,1) = numbr_plants(i_TEA);
end
end


run Mass_Balance_indirect.m
run Energy_Balance_indirect.m 
run CAPEX_Model_indirect.m
run OPEX_Model_indirect.m
run Revenue_Model_indirect.m


% Calculate total costs & relative costs to produced Carbonate
Result_total_cost_fu_indirect(i_TEA) = Cost_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_total_rev_fu_indirect(i_TEA) = revenue_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_total_profit_indirect(i_TEA) = revenue_total-Cost_total; % in[EUR/a]
GHG_reduction (i_TEA) = 1-(size_cement_plant*ghg_cement+ghg_total)/(size_cement_plant*ghg_cement); % GHG reduction in % to benchmark (w/o carbonation)
CO2_captured_indirect(i_TEA) = m_CO2_stored / (size_cement_plant*ghg_cement/1000);
end


end

