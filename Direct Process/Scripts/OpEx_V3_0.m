%------------------------%% OPEX Calculation V2 %%------------------------%

%% Import factors needed for the calculation

pc_electricity = I4(27,1);% electricity price in [€/MWh]
pc_naturalgas = I4(28,1);% natural gas price in [€/MWh]
pc_cooling = I4(29,1);% cooling water price in [€/m3]
pc_chemcial_markup = I4(11,11);%reported costs on other chemical in [€/tCO2]
pc_mineral = I4(12,1); % mineral prices in [€/t]
pc_H2O = I4(17,1); % process water price in [€/t]
pc_NaHCO3 = I4(19,1); % Additive price in [€/t]
pc_NaCl = I4(20,1); % Additive price in [€/t]
pc_oxalic_acid = I4(22,1); % Additive price in [€/t]
pc_ascorbic_acid = I4(23,1);% Additive price in [€/t]
pc_MEA= I4(21,1);% MEA price in [€/t]

pc_truck = I1(45,1); % €/tonne mineral
pc_train = I1(46,1); % €/tonne mineral
pc_ship = I1(47,1); % km/tonne mineral
distance_mineral = I1(48,1); % km/tonne mineral

factor_opex_isurance = I2(93,1); %factors for opex calculation
factor_opex_maintenance = I2(94,1);%factors for opex calculation
Factor_opex_labor = [I2(95,1);I2(96,1)];%factors for opex calculation
factor_recycling_H2O = I1(35,1);


th_capture = I4(4,11); % heating requirement CO2 capture in [GJ/tCO2] captured
cooling_capture = I4(5,11); % cooling water requirement CO2 capture in [m3/tCO2]

%% Calculation of varibale OpEx-----------------------------------------------
%variable opex are energy consumption, utilities and feedstock

%% Calculate Cost of electricity in €/a

 C_electricity_total = (W_total).*pc_electricity; %Electricity requiremments in [MWh]* electricity price in[€/MWh]
 c_electricity_total = sum(C_electricity_total);

%%Calculoate natural gas requierments in MWh/a

%natural gas consumption in GJ/a
ng_capture = max(((Mass_in_out(4,3)*th_capture)- q_mea_capture),0); %[tCO2/a]*[GJ/tCO2] - [GJ/a]
%convert into Mwh/a
ng_capture = (ng_capture/3.6);

ng_heating = q_he_2*operating_hours/1000; %kW*working hours/1000 = [MWh/a]

Ng_total = [ng_capture,ng_heating];

%% calcualte the costs of Natural gas in €/a
c_ng_capture = ng_capture * pc_naturalgas; %ng required * price of ng 
c_ng_heating = ng_heating * pc_naturalgas; %ng required * price of ng 

C_naturalgas_total = [c_ng_capture, c_ng_heating]; %ng required * price of ng
c_naturalgas_total = sum(C_naturalgas_total);

%% Calculate cooling water requirements in €/a
cool_capture = Mass_in_out(4,3)*cooling_capture; %CO2_input * cooling water needed in [m3/a]

%% Calculate the costs of cooling water in €/a
c_cool_total = cool_capture*pc_cooling; %cooling water required* cooling water price 

%% Calculate the costs of other chemicals in €/a
c_chemical_capture = Mass_in_out(4,3)* pc_chemcial_markup; %Costs for other chemicals capture

%% Calculate Feedstock requirements
%Derive Feed matrix, to automatically derive the needed inputs for any
%given Feedstock, some adjustments have to be made in order to use the
%Mass_in_out matrix

c_mineral = Mass_in_out(2,3)* pc_mineral; % costs of mineral mining in [€/a]
c_H2O = (v_reactor_h2o + (Mass_in_out(10,3)*(1-factor_recycling_H2O))/d_H2O)*pc_H2O;% costs of mineral mining in [€/a]. Markup + Startup

c_NaHCO3 = Mass_in_out(11,3)*(1-factor_recycling_H2O)*pc_NaHCO3;
c_NaCl = Mass_in_out(12,3)*(1-factor_recycling_H2O)*pc_NaCl;
c_oxalic_acid = Mass_in_out(13,3)*(1-factor_recycling_H2O)*pc_oxalic_acid;
c_ascorbic_acid = Mass_in_out(14,3)*(1-factor_recycling_H2O)*pc_ascorbic_acid;

c_MEA = Mass_in_out(15,7)*pc_MEA;

% sum all feedstock costs
C_additives_total = [c_NaHCO3; c_NaCl; c_oxalic_acid; c_ascorbic_acid]; % sum all additives.
c_additives_total = (c_NaHCO3+c_NaCl+c_oxalic_acid+c_ascorbic_acid); % sum all additives.

c_feedstock_total = c_mineral+c_H2O+c_additives_total+c_MEA; % sum all feedstock costs in [€/a]

%% calculate costs for mineral transport
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
c_mineral_transport = Mass_in_out(2,3)*(pc_truck*distance_truck + pc_train*distance_train + pc_ship*distance_ship);

%% Calcuatle the variable costs:

C_opex_var = [c_electricity_total;c_naturalgas_total;c_cool_total;c_chemical_capture; c_feedstock_total];
c_opex_var = sum(C_opex_var);

%% Calculate the Fixed cost of production

%C_opex_fixed = zeros (10,1); % create fixed opex array

%Cost for Workers
%Calculate Working hours needed for the plant as a rough estimate
% first define which equation to use
a = I1(33,1); %selects which function to choose from
b = (fu_cement_replacement/I1(6,1))*24; % MgCO3 produced /working hours* 24 = capacity in tonnes/day
c_labour_direct = (I3(a+14,1)*(b)^I3(a+14,2))*I1(32,1); %Cost for Salary  = a1*capacity^b1 * cost of worker per hour in [€/day]
c_labour_direct = (c_labour_direct(1,1) / 24)*I1(6,1); %Cost of Salary = cost of salary/24 * Working hours of plant

% calculate the indirect costs following CemCap's approach
c_insurance = capEx_total*(factor_opex_isurance);
c_maintenance = capEx_total*(factor_opex_maintenance);
c_labour_indirect = Factor_opex_labor(1)*(c_labour_direct+Factor_opex_labor(2)*c_maintenance);
c_opex_fixed = c_insurance+c_maintenance+c_labour_direct+c_labour_indirect;


