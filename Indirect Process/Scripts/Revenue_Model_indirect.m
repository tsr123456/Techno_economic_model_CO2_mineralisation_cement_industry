%------------------------%% Revenue Calculation %%------------------------%

% Import data
p_mgco3 = M5(39,1); %Price of MgCO3 [USD/t]
p_cement_mix = M5(50,1);%[EUR/t]
cement_replacement_ratio = M5(41,1);
p_ETS = M5(51,1);%EUR/tonne CO2

%fu_cement_replacement  %this capacity is to be changed based on cement plant [t/a]
cap_cement_plant_old = M5(43,1); %this is required amount for SiO2 production [t-co2/a]

%% Revenue model 

% Emission reduction factors: 
ghg_elec   = M5(52,1); %in kgCO2/MWh
ghg_ng     = M5(53,1); %in kgCO2/MWh
ghg_train  = M5(54,1); %kgCO2/km*t
ghg_truck  = M5(55,1); %kgCO2/km*t
ghg_ship    = M5(67,1); %kgCO2/km*t
e_mining = M5(56,1);     %kWh/t
ghg_water  = M5(57,1);  %kgCO2/t
ghg_construction = M5(58,1); %kgCO2/ktCO2_stored
ghg_cement =M5(59,1); %kgCO2/t
ghg_AS =M5(60,1);   %kgCO2/t


%% Revenue from products [€/a]

%LCA data:

%GHG_emission_reduction in [kgCO2/a]
ghg_cemenent_replaced = -(m_replaced_total*ghg_cement);
ghg_transport_reduced = - (m_replaced_total*distance_storage*ghg_truck);
ghg_transport_increased = m_mineral_in*distance_train*ghg_train+m_mineral_in*distance_truck*ghg_truck+m_mineral_in*distance_ship*ghg_ship+m_stored_total*distance_storage*ghg_truck;
ghg_CO2_stored = -1000*(m_CO2_stored);

%GHG emissions produced in [kgCO2/a]
ghg_electricity_prod = w_total*ghg_elec;
ghg_ng_prod          = q_fu_total*ghg_ng;
ghg_water_prod      = water_markup*ghg_water;
ghg_AS_prod       = AS_markup*ghg_AS;
ghg_constr_prod    = ghg_construction*m_CO2_stored/1000;
ghg_mining_prod = e_mining*m_mineral_in/1000*ghg_elec; %[kwh/t]*[t/a]/1000*[tCO2/MWh] = tCO2/a

Ghg_total = [ghg_cemenent_replaced ,ghg_transport_reduced, ghg_transport_increased, ghg_CO2_stored, ghg_electricity_prod, ghg_ng_prod, ghg_water_prod, ghg_AS_prod, ghg_constr_prod, ghg_mining_prod];
ghg_total = sum(Ghg_total);
% Revenue from product 1
rev_1 = m_replaced_total*p_cement_mix;
rev_ETS = p_ETS*(-ghg_total)/1000;

% Total revenue 
revenue_total = rev_1 + rev_ETS;

%% Add all cost incurred [€/a]

cost_total = (OpEx_total+annual_CapEx);

%% Edit Till
Cost_total = cost_total;

%% Tabulate data

energy_cost_specific = electricity_cost/fu_cement_replacement;
chemical_cost_specific = (ng_cost+water_cost+AS_cost)/fu_cement_replacement;
mineral_cost_specific = mineral_cost/fu_cement_replacement;
transport_cost_specific = mineral_transport_cost/fu_cement_replacement;
annual_CapEx_specific = annual_CapEx/fu_cement_replacement;
p1_sale_specific = rev_1/fu_cement_replacement;
maintenance_cost_specific = maintenance_cost/fu_cement_replacement;
labour_cost_specific = labour_cost/fu_cement_replacement;
insurance_tax_cost_specific = insurance_tax_cost/fu_cement_replacement;

profit = (revenue_total-cost_total)/fu_cement_replacement;

results_opex_table = [energy_cost_specific;chemical_cost_specific;mineral_cost_specific;transport_cost_specific;annual_CapEx_specific; maintenance_cost_specific; labour_cost_specific; insurance_tax_cost_specific];
