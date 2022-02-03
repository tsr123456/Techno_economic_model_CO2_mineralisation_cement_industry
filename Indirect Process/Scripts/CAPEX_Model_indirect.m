%% ---------------- Calculate Total Direct Costs (TDC) ----------------- %%
% in the following lines the equipment costs are calculated for each
% process unit seperately and converted to GBP using day rates

%% Import data 

m_mineral_in = Mass_in_out(1,1)/factor_mineral_purity; %Mineral in [t/a]

rho_serpentine  = M1(36,1);
rho_steel       = M1(38,1); %density of reactor material
rho_AS          = M1(35,1); %density in t/m3
rho_H2O         = M1(34,1);

temp_r1         = M3(2,1); %Input S5
temp_r2         = M3(4,1); %Input S9
temp_r3         = M3(6,1); %Input S13

% Reactor vessel Calc.
thick_wall_max      = M5(10,1);%maximum wall thickness reactor
joint_eff        = M5(11,1);%joint efficiency reactor
sf               = M5(12,1);%security factor for used pressure in reactor
material        = M5(13,1);%material reactor, 0=CS, 1=SS
max_r1_size     = M5(44,1); % maximum reactor size in m3
max_r2_size      = M5(45,1); % maximum reactor size in m3
max_r3_size     = M5(46,1);% maximum reactor size in m3
factor_gasphase   = M5(15,1);%gasphase in reactor as a factor, when no gasphase reaction occurs set it to 0.1
ASME           = M4(14:18,1:5);%copy ASME 

% Heat exchanger calc.
k_hx_liquid_liquid         = 1000; % heat exchange coefficient in [W/m2K]
k_hx_liquid_gas            = 40; % heat exchange [W/m2K]
k_hx_steam_evaporation     = 1950; % heat exchange [W/m2K] (900-3000)
k_hx_drying                = 293; %% heat exchange coefficient in [W/m2K]

p_outside                  = 1; %outside pressure in bar
max_hx_size    = M5(18,1); % maximum size of heat exchanger in [m2]
opt_hrs         = M5(8,1);
interest        = M5(16,1);% interest rate on capital
lifetime        = M5(17,1);% expected lifetime of the plant

process_contingency = M5(23,1); %factors to take into account based on CEMCAP calc.
project_contingency = M5(24,1);
owners_costs   =       M5(25,1);
indirect_cost       = M5(22,1);
factor_learning_rate = M5(65,1);
numbr_plants_NOAK = M5(64,1);
time_constr = M5(66,1);

%% Calculate Crushing and Grinding Equipment----------------------------%%%

% Calculate TDC- Crusher
tdc_crusher = direct_cost_crusher(m_mineral_in/opt_hrs);% total direct cost of crusher [€]

% Calculate TDC - Grinding [€]
tdc_grinder = direct_cost_ball_mill(w_grinding/opt_hrs*1000);% total direct cost of ball mill [€]

%% Calculate Reactor Costs ---------------------------------------------%%%

% R1-Mineral dissolution-------------------------------------------------%%

%calculate the costs of the reactor as a pressure vessel
[numbr_reactor_r1, size_reactor_r1,~,thick_wall_max_r1] = design_reactor(thick_wall_max,max_r1_size,total_vol_r1*(1+factor_gasphase),p_r1,sf,material,joint_eff,rho_steel,temp_r1,ASME);
tdc_reactor_vessel_r1 = direct_cost_reactor(p_r1,size_reactor_r1)*numbr_reactor_r1;

%add the agitator:
tdc_agitator_r1 = direct_cost_agitator_v3((w_md_stirring_R1/opt_hrs)/numbr_reactor_r1)*numbr_reactor_r1;

%add the pump:
tdc_pump_r1 = direct_cost_centr_pump_v3(total_vol_r1/time_reaction,p_r1);

%sum up the tdc for R1:
tdc_r1 = tdc_reactor_vessel_r1+tdc_agitator_r1+tdc_pump_r1;

% R2-PH Adjustment ------------------------------------------------------%%

%calculate the costs of the reactor as a pressure vessel
[numbr_reactor_r2, size_reactor_r2,~,thick_wall_max_r2] = design_reactor(thick_wall_max,max_r2_size,total_vol_R2*(1+factor_gasphase),p_r2,sf,material,joint_eff,rho_steel,temp_r2,ASME);
tdc_reactor_vessel_r2 = direct_cost_reactor(p_r2,size_reactor_r2)*numbr_reactor_r2;

%add the agitator:
tdc_agitator_r2 = direct_cost_agitator_v3((w_md_stirring_R2/opt_hrs)/numbr_reactor_r2)*numbr_reactor_r2;

%add the pump:
tdc_pump_r2 = direct_cost_centr_pump_v3(total_vol_R2/time_reaction,p_r2);

%sum up the tdc for R2:
tdc_r2 = tdc_reactor_vessel_r2+tdc_agitator_r2+tdc_pump_r2;

% R3-Carbonation reaction------------------------------------------------%%

%calculate the costs of the reactor as a pressure vessel
[numbr_reactor_r3, size_reactor_r3,~,thick_wall_max_r3] = design_reactor(thick_wall_max,max_r3_size,total_vol_R3*(1+factor_gasphase),p_r3,sf,material,joint_eff,rho_steel,temp_r3,ASME);
tdc_reactor_vessel_r3 = direct_cost_reactor(p_r3,size_reactor_r3)*numbr_reactor_r3;

%add the agitator:
tdc_agitator_r3 = direct_cost_agitator_v3((w_md_stirring_R3/opt_hrs)/numbr_reactor_r3)*numbr_reactor_r3;

%add the pump:
tdc_pump_r3 = direct_cost_centr_pump_v3(total_vol_R3/time_reaction,p_r3);

%sum up the tdc for R3:
tdc_r3 = tdc_reactor_vessel_r3+tdc_agitator_r3+tdc_pump_r3;


%% Heat Exchange Equipment----------------------------------------------%%%

% HE 1 
[numbr_he_1,area_he_1_maxium_size] = design_heat_exchanger(t_in_he_1_warm,t_out_he_1_warm,t_in_he_1_cold,t_out_he_1_cold,q_he_1,k_hx_liquid_liquid,max_hx_size); %design heat exchanger
tdc_he_1 = direct_cost_hx(area_he_1_maxium_size,p_r1).*numbr_he_1; % calculate total direct costs in EUR
% HE 3
[numbr_he_3,area_he_3_maxium_size] = design_heat_exchanger(t_in_he_3_warm,t_out_he_3_warm,t_in_he_3_cold,t_out_he_3_cold,q_he_3,k_hx_liquid_liquid,max_hx_size); %design heat exchanger
tdc_he_3 = direct_cost_hx(area_he_3_maxium_size,p_r3).*numbr_he_3; 


%% Furnaces-------------------------------------------------------------%%%

% FU 1
tdc_fu_1 = direct_cost_furnace(q_fu_1,total_vol_r1/space_time_R1);

% FU 3
tdc_fu_3 = direct_cost_furnace(q_fu_3,total_vol_R3/space_time_R3);

% FU 4:
tdc_fu_4 = 0;

%% Crystalizer and Rotary kiln -----------------------------------------%%%

%calculate heat exchange area, use heat exchanger design function:
% HE4 / crystalizer
[length_cry, area_cry] = design_crystalizer_mech(t_in_he_4_warm,t_out_he_4_warm,t_in_he_4_cold,t_out_he_4_cold,q_he_4,k_hx_steam_evaporation); %design heat exchanger
[numbr_cry,tdc_cry] = direct_cost_crystalizer(length_cry); 

%FU 5 / Dryer
[numbr_he_dry,area_he_dry_maxium_size] = design_heat_exchanger(400,(t_delta_min+t_in_fu_5),t_in_fu_5,t_out_fu_5,q_fu_5,k_hx_drying,185); %design heat exchanger
[numbr_dry,tdc_dry] = direct_cost_crystalizer(numbr_he_dry*area_he_dry_maxium_size);


%% CO2 Capture  --------------------------------------------------%%%

%Capture is calculated using the TEA results from literature
m_CO2_captured = Mass_in_out(12,6)+ Mass_in_out(12,15);
tdc_capture = direct_costs_chilled_ammonia_capture(m_CO2_captured/opt_hrs);


%% Separation ----------------------------------------------------------%%%

% Centrifuge 1 - Silica (1µm)S6
tdc_dewater1 = direct_cost_solid_bowl_centrifuge(l_dewater_1,d_dewater_1);


% Centrifuge 3 - MgCO3 (5µm)S14

tdc_dewater_3 = direct_cost_solid_bowl_centrifuge(l_dewater_3,d_dewater_3);


%% Factor in contingencies and indirect costs, CEMCAP method

TDC_all = [tdc_crusher; tdc_grinder; tdc_r1; tdc_r2; tdc_r3; tdc_he_1;tdc_he_3;tdc_cry;tdc_fu_1;tdc_fu_3;tdc_fu_4;tdc_dry;tdc_dewater1;tdc_dewater_3;tdc_capture];

total_direct_cost = sum(TDC_all);

% Total Engineering,Procurement,Construction cost (EPC) = TDC*(1-indirect_cost)in[€]
total_epc = total_direct_cost*(1+indirect_cost);

% Total Plant cost (TPC) = EPC*process_contingency*project_contingency in[€]
total_plant_cost = total_epc*(1+process_contingency)*(1+project_contingency);

% Adapt capital costs with learning rate.
factor_b_learning = -log(1-factor_learning_rate)/log(2);
tpc_total_NOAK = (total_plant_cost/fu_cement_replacement)*(numbr_plants_NOAK^-factor_b_learning);
tpc_total_NOAK = tpc_total_NOAK*fu_cement_replacement;

%Add interest during construction & owner's costs: Total Captial requirment
interest_during_constr = tpc_total_NOAK*interest*time_constr;
tcr_total = tpc_total_NOAK*(1+owners_costs)+interest_during_constr;

capEx_total = tcr_total;


%% Annualized CapEx 

annual_CapEx = (interest/(1-((1+interest)^-lifetime)))*capEx_total ;

%% Tabulate results ----------------------------------------------------%%%

Equipment_CapEx = {'Crusher';'Grinder';'Reactor R1';'Reactor R2';'Reactor R3';'Heat Exchanger 1';'Heat Exchanger 3';'Crystalizer';'Furnace 1';'Furnace 3';'Furnace 4';'Rotary Dryer';'Centrifuge 1';'Centrifuge 2';'CO2 capture'};
TDC_all_fu = TDC_all./fu_cement_replacement;
Numbr_eq = [1;1; numbr_reactor_r1; numbr_reactor_r2; numbr_reactor_r3;numbr_he_1;numbr_he_3;numbr_cry;1;1;1;numbr_cry;numbr_dewater_1;numbr_dewater_3;1];
size_eq = [0;0;size_reactor_r1;size_reactor_r2;size_reactor_r3;area_he_1_maxium_size;area_he_3_maxium_size;length_cry;0;0;0;area_he_dry_maxium_size;l_dewater_1;l_dewater_3;0];
CapEx_all = (TDC_all./total_direct_cost).*capEx_total;
Result_TDC = table(Equipment_CapEx,TDC_all,TDC_all_fu, Numbr_eq,size_eq,CapEx_all);
Result_TDC.Properties.VariableNames ={'Equipment'; 'Total direct costs in [€]';'Spec. Total direct costs in [€/t]';'Number of Equipment';'Equipment size in [m3],[m2],[m]';'Capital Expenditures in [€]' };

