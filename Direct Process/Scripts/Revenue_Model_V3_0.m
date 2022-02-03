%%-------------------------%% Revenue Model V2%%------------------------%%
% The revenue model is linked to an application of the reacted mineral in
% cement production.  

%% Calculate LCA Data

% Emission reduction factors: 
ghg_elec   = I1(70,1); %in kgCO2/MWh
ghg_ng     = I1(71,1); %in kgCO2/MWh
ghg_train  = I1(72,1); %kgCO2/km*t
ghg_truck  = I1(73,1); %kgCO2/km*t
ghg_ship  = I1(81,1); %kgCO2/km*t
e_mining = I1(74,1);     %kWh/t
ghg_water  = I1(75,1);  %kgCO2/t
ghg_construction = I1(76,1); %kgCO2/ktCO2_stored
ghg_cement =I1(77,1); %kgCO2/t
ghg_NaHCO3 =I1(78,1);   %kgCO2/t
ghg_NaCl = I1(79,1);%kgCO2/t
ghg_MEA = I1(80,1);%kgCO2/t




%% Reference flow: How much material is used in the cement?
% the reference flow is selected as one ton of cement replacement material.
% this depends on how efficient the separation of the product is. It
% consists of three different mass flows; unreacted mineral, 

% The reference flow is also the material that is going to be mixed with
% cement:
separation_factor = 1;% first the separation factor (between 0-1) has to be defined. for all the calculations a factor of 1 has been used. 

blending_ratio = ratio_cement_CEMI_max(2)/ratio_cement_CEMI_max(1);
size_cement_plant = I1(1,1); % capacity of cement in t /a 
distance_truck_storage = I1(61,1);% distance to storage site in km
pc_cement = I1(56,1) ;% cement price in EUR/tonne
emission_reduction_factor = I1(58,1);% emission reduction per tonne of CO2 reacted %%%%%%CHECKL
pc_ETS = I1(57,1) ;%price ETS certificate in EUR/tonne of CO2

    
    m_SiO2_replaced = min(m_SiO2_out,ratio_cement_CEMI_max(1)*size_cement_plant);
    m_inert_replaced = min(m_SiO2_replaced*(blending_ratio),ratio_cement_CEMI_max(2)*size_cement_plant);
    m_MgCO3_replaced = m_inert_replaced*(m_MgCO3_out_carb/(m_MgCO3_out_carb+m_mineral_out_carb)); % for the MgCO3 and unreacted olivine it is assumed, that they will be in found in the inert part of the cement replacement in the same ratios as produced.  
    m_unreacted_mineral_replaced = m_inert_replaced*(m_mineral_out_carb/(m_MgCO3_out_carb+m_mineral_out_carb));
    
    m_replaced_total = m_SiO2_replaced +m_inert_replaced;  %how much replacement material is produced has to be consistent with the envisioned reference flow
    
% All additional material that is produced has to be stored. 

    m_SiO2_stored = max(m_SiO2_out-m_SiO2_replaced,0);%the Silica that is going to storage is the silica, which is not used in the cement replacing
    m_inert_stored =  max((m_MgCO3_out_carb+m_mineral_out_carb) -  m_inert_replaced,0);
    m_MgCO3_stored = m_inert_stored*(m_MgCO3_out_carb/(m_MgCO3_out_carb+m_mineral_out_carb)); % for the MgCO3 and unreacted olivine it is assumed, that they will be in found in the inert part of the cement replacement in the same ratios as produced.  
    m_unreacted_mineral_stored = m_inert_stored*(m_mineral_out_carb/(m_MgCO3_out_carb+m_mineral_out_carb)); 


    m_stored_total = m_SiO2_stored + m_inert_stored; % the total material needs to be calculated, this is transported back to the mine
    

% calcualte share of mass that is going to storage and going into cement
% replacement. 

share_SiO2_replaced = m_SiO2_replaced/(m_SiO2_replaced + m_SiO2_stored);
share_inert_replaced = m_inert_replaced/(m_inert_replaced+ m_inert_stored);


%% Revenue calculation

% Add costs together: in [€/a]
c_mineral_transport = c_mineral_transport+m_stored_total*distance_truck_storage*pc_truck; % it needs to addedd, that material has to transported to the storage site, if necessary. 
c_utilities_total = c_naturalgas_total+c_electricity_total+c_cool_total+c_chemical_capture;

C_total =[c_utilities_total,c_feedstock_total,c_mineral_transport,annual_CapEx,c_opex_fixed];
c_total = sum(C_total);

% total revenue calculation
%LCA data:

%GHG_emission_reduction in [kgCO2/a]
ghg_cemenent_replaced = -(m_replaced_total*ghg_cement);
ghg_transport_reduced = - (m_replaced_total*distance_truck_storage*ghg_truck);
ghg_transport_increased = m_mineral_in_carb*distance_train*ghg_train+m_mineral_in_carb*distance_truck*ghg_truck+m_mineral_in_carb*distance_ship*ghg_ship+m_stored_total*distance_truck_storage*ghg_truck;
ghg_CO2_stored = -1000*(m_CO2_in_carb);

%GHG emissions produced in [kgCO2/a]
ghg_electricity_prod = (sum(W_total))*ghg_elec;
ghg_ng_prod          = (sum(Ng_total))*ghg_ng;
ghg_water_prod      = (Mass_in_out(10,3)*(1-factor_recycling_H2O))*ghg_water;
ghg_constr_prod    = ghg_construction*m_CO2_in_carb/1000;
ghg_mining_prod = e_mining*m_mineral_in_carb/1000*ghg_elec; %[kwh/t]*[t/a]/1000*[tCO2/MWh] = tCO2/a
ghg_NaHCO3_prod =  Mass_in_out(11,3)*(1-factor_recycling_H2O)*ghg_NaHCO3;
ghg_NaCl_prod = Mass_in_out(12,3)*(1-factor_recycling_H2O)*ghg_NaCl;
ghg_MEA_prod = Mass_in_out(15,7)*ghg_MEA;


Ghg_total = [ghg_cemenent_replaced ,ghg_transport_reduced, ghg_transport_increased, ghg_CO2_stored, ghg_electricity_prod, ghg_ng_prod, ghg_water_prod, ghg_constr_prod, ghg_mining_prod, ghg_NaHCO3_prod, ghg_NaCl_prod, ghg_MEA_prod];
ghg_total = sum(Ghg_total);
rev_total = m_replaced_total*pc_cement + pc_ETS*(-ghg_total)/1000;


%% Tabulate results LCA ----------------------------------------------------%%%

Labels_GHG = {'ghg_cemenent_replaced';'ghg_transport_increased';'ghg_CO2_stored';'ghg_electricity_prod';'ghg_ng_prod ';'ghg_water_prod';'ghg_constr_prod';'ghg_mining_prod';'ghg_NaHCO3_prod';'ghg_NaCl_prod';'ghg_MEA_prod'};
GHG_plot = [ghg_cemenent_replaced ;ghg_transport_increased; ghg_CO2_stored; ghg_electricity_prod; ghg_ng_prod; ghg_water_prod; ghg_constr_prod; ghg_mining_prod; ghg_NaHCO3_prod; ghg_NaCl_prod; ghg_MEA_prod];
GHG_plot_fu = GHG_plot./fu_cement_replacement;
Result_GHG = table(Labels_GHG,GHG_plot,GHG_plot_fu);
Result_GHG.Properties.VariableNames ={'Description'; 'GHG';'Spec. GHG' };
