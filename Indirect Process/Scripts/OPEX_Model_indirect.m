%------------------------%% OPEX Calculation %%------------------------%

% Data for calculation
cp_h2o        = 4.2; %[kJ/kgK]
rate_USD_EUR  = 0.88; %xe.com rates: USD>GBP0.770468 USD>EUR0.88
wage_rate     = M5(37,1);%[euro/year]
num_employees = M5(38,1);% number of assumed employees 


% Price of Utilities and Consumables
pc_electricity   = M5(26,1); %[€/MWh]
pc_process_water = M5(28,1);%[€/m3]
pc_natural_gas   = M5(29,1);%[€/MWh]
pc_mineral       = M5(30,1);%[€/t]
pc_AS           = M5(31,1);%[USD/t]

% Price and distance of transport
pc_truck = M5(33,1); %e/km-t_rocks
pc_train = M5(34,1); %e/km-t_rocks
pc_ship = M5(35,1); %[km] %e/km-t_rocks 

distance_mineral = M5(36,1); %[km]
distance_storage = M5(41,1); %[km]

%% ---------------------------Product usage-----------------------------%%

m_SiO2_out_new = Mass_in_out(4,2);
m_MgCO3_out_new = Mass_in_out(10,6);
m_FeOH3_out_new = Mass_in_out(9,4);
m_CO2_stored = Mol_in_out(10,6)*mw_CO2/1000;
size_cement_plant = 1360000; % cement production in [t/a]
ratio_cement_CEMI_max = [M5(39,1);M5(40,1)];
blending_ratio = ratio_cement_CEMI_max(2)/(ratio_cement_CEMI_max(1)+ratio_cement_CEMI_max(2));

m_SiO2_replaced = min(m_SiO2_out_new,ratio_cement_CEMI_max(1)*size_cement_plant);
m_inert_replaced = min(m_SiO2_replaced*(ratio_cement_CEMI_max(2)/ratio_cement_CEMI_max(1)),ratio_cement_CEMI_max(2)*size_cement_plant);
m_MgCO3_replaced = m_inert_replaced;
    
m_replaced_total = m_SiO2_replaced +m_inert_replaced;  %how much replacement material is produced has to be consistent with the envisioned reference flow

% All additional material that is produced has to be stored. 

m_SiO2_stored = max(m_SiO2_out_new-m_SiO2_replaced,0);%the Silica that is going to storage is the silica, which is not used in the cement replacing
m_MgCO3_stored = max(m_MgCO3_out_new-m_MgCO3_replaced,0);
m_FeOH3_stored = m_FeOH3_out_new; 
m_inert_stored = m_MgCO3_stored + m_FeOH3_stored;

m_stored_total = m_SiO2_stored + m_inert_stored; % the total material needs to be calculated, this is transported back to the mine

% Calculate share of replacement / storage
share_SiO2_replaced = m_SiO2_replaced/(m_SiO2_replaced + m_SiO2_stored);
share_inert_replaced = m_inert_replaced/(m_inert_replaced+ m_inert_stored);


%% Calculate Cost of electricity----------------------------------------%%%

electricity_cost =w_total*pc_electricity; %electricity total [MWh/a * e/MWh]

%% Calculate cost of natural gas----------------------------------------%%%

% cost of natural gas [€/a]
ng_cost = q_fu_total*pc_natural_gas; %[MWh*€/MWh] = €

%% Calculate cost of cooling water 
%{
% cooling water consumption 
%lmtd_top_1 = (t_in_warm_hx2-t_out_cold_hx2)-(t_out_warm_hx2-t_in_cold_hx2);
%lmtd_bottom_1 = log(lmtd_top_1);
%lmtd_hx1 = lmtd_top_1/lmtd_bottom_1;

%m_h2o = (q_hx2*3600)/(cp_h2o*lmtd_hx1); % Q=m*Cp_water*LMTD [kg/a]
%m_h2o = m_h2o/(rho_H2O*1000); % consumption of water [m3/a]

% cost of cooling water [GBP/a]
%cooling_water_cost = m_h2o*pc_cooling_water*rate_euro_GBP;
%}
%% Calculate cost of feedstock & untility-------------------------------%%%
factor_additive_recycling = M1(46,1); % in Wan 2013 it is assumed to be 25%
factor_AH_water_ratio = M1(47,1);% As Amonia hydoxide is bought as a solution, the weight of the water has to be taken into account. 

% Cost of NH4HSO4 [€/a](S4+S19)--------------------------------------------
AS_consumption = (Mass_in_out(6,10)); % [t/a]
AS_markup = (1-factor_additive_recycling)*AS_consumption; %[t/a]
AS_cost = AS_markup*pc_AS*rate_USD_EUR;


% Cost of serpentine [€/a](S5) --------------------------------------------
mineral_consumption = Mass_in_out(1,1)/(factor_mineral_purity); %[t/a]
mineral_cost = mineral_consumption*pc_mineral;

% Consumption of Process Water---------------------------------------------
water_consumption = (Mass_in_out(6,10)); % [t/a]
water_markup = (1-factor_additive_recycling)*water_consumption; %[t/a]
water_cost = AS_markup*pc_process_water;


% total cost of feedstock [GBP/a]
feedstock_cost = AS_cost+mineral_cost+water_cost;

%% Transport costs [GBP/a]----------------------------------------------%%%

if distance_mineral <= 60
    distance_truck = distance_mineral;
    distance_train = 0;
    distance_ship = 0;
elseif distance_mineral > 60 && distance_mineral <= 260
    distance_truck = 60;
    distance_train = distance_mineral- distance_truck;
    distance_ship = 0;
elseif distance_mineral >260
    distance_truck = 60;
    distance_train = 200;
    distance_ship = distance_mineral - distance_train - distance_truck;
end

mineral_transport_cost = mineral_consumption*(pc_truck*distance_truck+pc_train*distance_train+pc_ship*distance_ship)+m_stored_total*distance_storage*pc_truck;

%% Total OPEX-variable cost---------------------------------------------%%%

opex_var_cost = [electricity_cost;ng_cost;feedstock_cost;mineral_transport_cost];
Opex_var_cost = sum(opex_var_cost);


%% Calculate OPEX-Fixed cost--------------------------------------------%%%

% Maintenance cost [GBP/a]
maintenance_cost = 0.025*capEx_total;

% Total labour cost [GBP/a]


a = 1; %selects which function to choose from
b = (fu_cement_replacement/8000)*24; % MgCO3 produced /working hours* 24 = capacity in tonnes/day
c_labour_direct = (10.447)*(b^0.2486)*25; %Cost for Salary  = a1*capacity^b1 * cost of worker per hour in [€/day]
operating_labour_cost = (c_labour_direct(1,1)/24)*8000; %Cost of Salary = cost of salary/24 * Working hours of plant
%}
%operating_labour_cost = wage_rate*num_employees;
admin_labour_cost = 0.3*(operating_labour_cost+(0.4*maintenance_cost));

labour_cost = operating_labour_cost+admin_labour_cost;

% Insurance and local taxes [GBP/a]
insurance_tax_cost = 0.02*capEx_total;

% Total fixed cost
Opex_fixed_cost = maintenance_cost+labour_cost+insurance_tax_cost;

%% Total OPEX-----------------------------------------------------------%%%

OpEx_total = Opex_fixed_cost+Opex_var_cost;

























