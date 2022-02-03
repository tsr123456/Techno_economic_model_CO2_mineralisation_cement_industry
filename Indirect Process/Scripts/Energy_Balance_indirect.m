%-----------------Energy Balance & Electricity Calc---------------------------------%

% Determine all energy required, Q(kW) from energy balance then use Q to 
% calculate electricity demand of each major equiment. 

% Heat energy, Q = m*Cp_mixture(T_mix)*(Tin-Tout)
% Enthalpy of reaction, dH = Heat_of_formation(dF) + Integral(Cp)dT
% Specific heat capacity, Cp = a+bT+cT^2+dT^3
% Integral(Cp)dT = a(T-Tref)+b/2((T^2)-(Tref^2))+c/3*((T^3)-(Tref^3))+d/4*((T^4)-(Tref^4))

%% Thermodynamic properties 
%create input matirx without heat of formation (updated from Till):
%create input matirx without heat of formation (updated from Till):
M4_w_o_HF = [M4(1:13,1:4),M4(1:13,6)];

%Create Shomate factor array:
Shomate_factors = M4_w_o_HF;

%Create factor array:
Enthalpy_formation = M4(1:13,5);

enthalpy_R1 = M1(13,1);% Enthalpy of reaction 1 [kJ]
enthalpy_R2 = M1(14,1);% Enthalpy of reaction 2 [kJ]
enthalpy_R3 = M1(15,1);% Enthalpy of reaction 3 [kJ]
enthalpy_R4 = M1(16,1);% Enthalpy of reaction 4 [kJ]
enthalpy_R5 = M1(17,1);% Enthalpy of reaction 5 [kJ]

%% Relevant values for calc

time_reaction = M1(3,1); %Hours per batch
opt_hrs = M5(8,1);

t_outside = M5(14,1); % outside air temperature
t_R1_in = M3(2,1);% Temperature in S5/R1 [C]
t_R2_in = M3(4,1);% Temperature in S9/R2 [C]
t_R3_in = M3(6,1);% Temperature in S13/R3 [C]
t_R4_in = M3(9,1);% Temperature in S17/R4 [C]
t_R5_in = M3(11,1);% Temperature in S518/R5 [C]
t_delta_min = M1(31,1);% Min temperature difference as driving force for heat exchange [C]
t_R3_out = M3(7,1); 

[t_in_he_1_cold, t_in_he_3_cold, t_in_he_4_cold] = deal(t_outside); %set all heat exchanger inputs that after separation to outside temperature. 
t_in_he_5_cold = t_R4_in; %the input of the heatexchanger after the evaporation is at 100°C.


%% Heat exchange- Reactor 1 ------------------------------------------- %%%

% Heat exchanger
% warm stream is the  is stream 6 the reaction solution after R1, cold
% stream S5
t_in_he_1_warm = t_R1_in ; %Input temperature in [°C]
t_out_he_1_warm = t_outside+t_delta_min; %Output temperature in [°C]

Enthalpy_in_he_1 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_in_he_1_warm);
Enthalpy_out_he_1 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_out_he_1_warm); 
    
% transfrom into kj/a:
Enthalpy_in_he_1 = Enthalpy_in_he_1*1000.*Mol_in_out(1:13,2);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
Enthalpy_out_he_1 = Enthalpy_out_he_1*1000.*Mol_in_out(1:13,2);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
  
% calculate the heat transfer requirement for heat exchanger 1:
q_he_1 = sum(Enthalpy_out_he_1)-sum(Enthalpy_in_he_1);
    
%transfrom into kW:
q_he_1 = (q_he_1 /(opt_hrs*3600)); %(q_carb/(operating hours *3600s))

%caluculate cp for the warm stream using shomate equation 
  %calculate cp using shomate equation
           
Cp_he_min = heat_capacity_shomate(Shomate_factors,t_outside);
Cp_he_max = heat_capacity_shomate(Shomate_factors,t_R1_in-t_delta_min);

  %calculate the average for each compound
Cp_he_cold = [Cp_he_min,Cp_he_max];
Cp_he_cold= mean (Cp_he_cold,2);
       
% derive the output temperature for the cold stream
delta_temp_he_1_cold = abs(q_he_1)/(sum(Mol_in_out(1:13,1).*Cp_he_cold ./((opt_hrs*3600)))); %[kW]/(kmol/a*kj/kmol/(operatinghours*3600s))
    
if t_in_he_1_warm -(delta_temp_he_1_cold+t_outside)< t_delta_min
   delta_temp_he_1_cold = t_in_he_1_warm- t_delta_min -t_outside; % if the minimum temperature difference is undercut, it is set to that. 
end

t_out_he_1_cold = delta_temp_he_1_cold + t_outside ;


% Furnace FU 1

%calculate the needed energy for heating up the stream going into the
%reactor (cold stream)

t_in_fu_1 = t_out_he_1_cold;%Input temperature in [°C]
t_out_fu_1 = t_R1_in; %Output temperature in [°C]

    Enthalpy_in_fu_1 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_in_fu_1);
    Enthalpy_out_fu_1 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_out_fu_1);
  
    % transfrom into kj/a:
    Enthalpy_in_fu_1 = Enthalpy_in_fu_1*1000.*Mol_in_out(1:13,1);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
    Enthalpy_out_fu_1 = Enthalpy_out_fu_1*1000.*Mol_in_out(1:13,1);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
  
    % calculate the heat transfer requirement for heat exchanger 1:
    q_fu_1 = sum(Enthalpy_out_fu_1)-sum(Enthalpy_in_fu_1);
    
    %transfrom into kW:
    q_fu_1 = abs(q_fu_1 /(opt_hrs*3600)); %(q_carb/(operating hours *3600s))

    duty_fu_1 = q_fu_1/1000 ; %kW transformed into MW
    
    
%% Heat exchange R2-----------------------------------------------------%%
q_he_2 = 0;% set the both to zero, as they will not be needed. 
q_fu_2 = 0; 

%% Heat exchange R3-----------------------------------------------------%%
% Heat exchanger R3 has as the warm stream S14 and as cold stream S13:

% Heat exchanger: 
t_in_he_3_warm = t_R3_out ; %Input temperature in [°C]
t_out_he_3_warm = t_outside+t_delta_min; %Output temperature in [°C]

Enthalpy_in_he_3 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_in_he_3_warm);
Enthalpy_out_he_3 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_out_he_3_warm); 
    
% transfrom into kj/a:
Enthalpy_in_he_3 = Enthalpy_in_he_3*1000.*Mol_in_out(1:13,6);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
Enthalpy_out_he_3 = Enthalpy_out_he_3*1000.*Mol_in_out(1:13,6);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
  
% calculate the heat transfer requirement for heat exchanger 1:
q_he_3 = sum(Enthalpy_out_he_3)-sum(Enthalpy_in_he_3);
    
%transfrom into kW:
q_he_3 = (q_he_3 /(opt_hrs*3600)); %(q_carb/(operating hours *3600s))

%caluculate cp for the warm stream using shomate equation 
  %calculate cp using shomate equation
           
Cp_he_min = heat_capacity_shomate(Shomate_factors,t_outside);
Cp_he_max = heat_capacity_shomate(Shomate_factors,t_R3_in-t_delta_min);

  %calculate the average for each compound
Cp_he_cold = [Cp_he_min,Cp_he_max];
Cp_he_cold= mean (Cp_he_cold,2);
       
% derive the output temperature for the cold stream
delta_temp_he_3_cold = abs(q_he_3)/(sum(Mol_in_out(1:13,5).*Cp_he_cold ./((opt_hrs*3600)))); %[kW]/(kmol/a*kj/kmol/(operatinghours*3600s))
    
%if t_R3_in -(delta_temp_he_3_cold+t_outside)< t_delta_min
%   delta_temp_he_3_cold = t_R3_in - t_delta_min - t_outside;% if the minimum temperature difference is undercut, it is set to that. 
%end

t_out_he_3_cold = delta_temp_he_3_cold + t_outside ;

% Furnace FU1

%calculate the needed energy for heating up the stream going into the
%reactor (cold stream)

t_in_fu_3 = t_out_he_3_cold;  %Input temperature in [°C]
t_out_fu_3 = t_R3_in; %Output temperature in [°C]

    Enthalpy_in_fu_3 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_in_fu_3);
    Enthalpy_out_fu_3 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_out_fu_3);
  
    % transfrom into kj/a:
    Enthalpy_in_fu_3 = Enthalpy_in_fu_3*1000.*Mol_in_out(1:13,5);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
    Enthalpy_out_fu_3 = Enthalpy_out_fu_3*1000.*Mol_in_out(1:13,5);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
  
    % calculate the heat transfer requirement for heat exchanger 1:
    q_fu_3 = sum(Enthalpy_out_fu_3)-sum(Enthalpy_in_fu_3);
    
    %transfrom into kW:
    q_fu_3 = abs(q_fu_3 /(opt_hrs*3600)); %(q_carb/(operating hours *3600s))

    duty_fu_3 = q_fu_3/1000 ; %kW transformed into MW


%% Heat Exchange R4 Evaporator ---------------------------------------%%%
% The warm stream for heatexchanger of the evaporator is S20, the cold
% stream S 16
shomate_factor_steam = M4(19,1:5);%use shomate factors for H2O as gas.
enthalpy_formation_steam = M4(19,6);
[~,t_in_he_4_warm] = electricity_compression_steam(1.3013,Mass_in_out(5,9)); %Input temperature in [°C]is the temperature of the compressed steam
t_out_he_4_warm = t_outside+t_delta_min; %Output temperature in [°C]

% calculate enthalpy of water vapor only
Enthalpy_in_he_4_vapor = enthalpy_calculation_shomate(shomate_factor_steam,Enthalpy_formation,t_in_he_4_warm);
Enthalpy_out_he_4_vapor = enthalpy_calculation_shomate(shomate_factor_steam,Enthalpy_formation,100); 

% calculate enthalpy of water as liquid 
Enthalpy_in_he_4_liquid= enthalpy_calculation_shomate(Shomate_factors(5,:),Enthalpy_formation,100);
Enthalpy_out_he_4_liquid = enthalpy_calculation_shomate(Shomate_factors(5,:),Enthalpy_formation,t_out_he_4_warm); 

% transfrom into kj/a:
Enthalpy_in_he_4 = (Enthalpy_in_he_4_vapor+Enthalpy_in_he_4_liquid)*1000*Mol_in_out(5,9);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
Enthalpy_out_he_4 = (Enthalpy_out_he_4_vapor+Enthalpy_out_he_4_liquid)*1000.*Mol_in_out(5,9);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
  
% calculate the heat transfer requirement for heat exchanger 1:
q_he_4 = sum(Enthalpy_out_he_4)-sum(Enthalpy_in_he_4);

q_vap_H2O = 2257*(Mass_in_out(5,7)-Mass_in_out(5,8));

q_he_4  =q_he_4-q_vap_H2O;    

%transfrom into kW:
q_he_4 = (q_he_4 /(opt_hrs*3600)); %(q_carb/(operating hours *3600s))

%caluculate cp for the warm stream using shomate equation 
  %calculate cp using shomate equation
           
Cp_he_min = heat_capacity_shomate(Shomate_factors,t_outside);
Cp_he_max = heat_capacity_shomate(Shomate_factors,t_R4_in);

  %calculate the average for each compound
Cp_he_cold = [Cp_he_min,Cp_he_max];
Cp_he_cold= mean (Cp_he_cold,2);
       
% derive the output temperature for the cold stream
delta_temp_he_4_cold = abs(q_he_4)/(sum(Mol_in_out(1:13,7).*Cp_he_cold ./((opt_hrs*3600)))); %[kW]/(kmol/a*kj/kmol/(operatinghours*3600s))
    
%if t_R4_in -(delta_temp_he_4_cold+t_outside)< t_delta_min
%   delta_temp_he_4_cold = t_R4_in - t_delta_min - t_outside;% if the minimum temperature difference is undercut, it is set to that. 
%end

t_out_he_4_cold = delta_temp_he_4_cold + t_outside;

% Furnace FU1

%calculate the needed energy for heating up the stream going into the
%reactor (cold stream)

t_in_fu_4 = t_out_he_4_cold; %Input temperature in [°C]
t_out_fu_4 = t_R4_in; %Output temperature in [°C]

    Enthalpy_in_fu_4 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_in_fu_4);
    Enthalpy_out_fu_4 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_out_fu_4);
  
    % transfrom into kj/a:
    Enthalpy_in_fu_4 = Enthalpy_in_fu_4*1000.*Mol_in_out(1:13,7);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
    Enthalpy_out_fu_4 = Enthalpy_out_fu_4*1000.*Mol_in_out(1:13,7);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
  
    % calculate the heat transfer requirement for heat exchanger 1:
    q_fu_4 = sum(Enthalpy_out_fu_4)-sum(Enthalpy_in_fu_4);
    
    %add vaporization energy:
    q_vap_H2O = 2257*Mass_in_out(5,7)-Mass_in_out(5,8);

    q_fu_4 = q_fu_4 + q_vap_H2O;
    
    %transfrom into kW:q_total
    q_fu_4 = abs(q_fu_4 /(opt_hrs*3600)); %(q_carb/(operating hours *3600s))

    duty_fu_4 = q_fu_4/1000 ; %kW transformed into MW
    
%% Heat Exchange R5 Additive regenerator -------------------------------%%%

%t_out_he_5_cold = t_R4_in + delta_temp_he_5_cold ;
t_out_he_5_cold = t_R4_in;
% Furnace FU1

%calculate the needed energy for heating up the stream going into the
%reactor (cold stream)

t_in_fu_5 = t_out_he_5_cold; %Input temperature in [°C]
t_out_fu_5 = t_R5_in; %Output temperature in [°C]

    Enthalpy_in_fu_5 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_in_fu_5);
    Enthalpy_out_fu_5 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_out_fu_5);
  
    % transfrom into kj/a:
    Enthalpy_in_fu_5 = Enthalpy_in_fu_5*1000.*Mol_in_out(1:13,10);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
    Enthalpy_out_fu_5 = Enthalpy_out_fu_5*1000.*Mol_in_out(1:13,10);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
  
    % calculate the heat transfer requirement for heat exchanger 1:
    q_fu_5 = sum(Enthalpy_out_fu_5)-sum(Enthalpy_in_fu_5);
    
    %Add regeneration enthalpy
    q_reaction_5 = enthalpy_R4*1000*Mol_in_out(13,11); %[kj/mol]*[kmol/a]*1000[mol/kmol] = kj/a
    
    %transfrom into kW:
    q_fu_5 = abs((q_fu_5+q_reaction_5) /(opt_hrs*3600)); %(q_carb/(operating hours *3600s))

    duty_fu_5 = q_fu_5/1000 ; %kW transformed into MW
    
    
% Tabluate Results: 
Energy_balance(:,1) = [q_he_1;q_fu_1;0; 0; q_he_3;q_fu_3; q_he_4;q_fu_4;q_fu_5];
Energy_balance(:,4) = [t_in_he_1_warm;0;0;0;t_in_he_3_warm;0;t_in_he_4_warm;0; 0];
Energy_balance(:,5) = [t_out_he_1_warm;0;0;0;t_out_he_3_warm;0;t_out_he_4_warm;0;0];
Energy_balance(:,2) = [t_in_he_1_cold;t_in_fu_1;0;0;t_in_he_3_cold;t_in_fu_3;t_in_he_4_cold;t_in_fu_4; t_in_fu_5];
Energy_balance(:,3) = [t_out_he_1_cold;t_out_fu_1;0;0;t_out_he_3_cold;t_out_fu_3;t_out_he_4_cold;t_out_fu_4;t_out_fu_5];
Result_Energy_balance_label = {'HE1';'Furnace1';'HE2';'Furnace2';'HE3';'Furnace3';'HE4';'Furnace4';'Furnace5'};
Result_Energy_balance_label = reshape(Result_Energy_balance_label,[9,1]);
Result_Energy_balance = table(Result_Energy_balance_label,Energy_balance(:,1),Energy_balance(:,2),Energy_balance(:,3),Energy_balance(:,4),Energy_balance(:,5));
Result_Energy_balance.Properties.VariableNames ={'Heatexchanger'; 'Q in kW/a'; 'T_in in °C (Cold)';'T_out in °C (Cold)';'T_in in °C (Warm)';'T_out in °C (Warm)'};

%% Electricity Demand Calculation 

% electricity consumption [kWh/t-mineral], [kWh/t-co2]
e_crushing   = M5(1,1); 
e_grinding   = M5(2,1);
e_co2capture = M5(4,1);

% density [kg/m3]
rho_MgSO4 = M1(33,1);
rho_h2O   = M1(34,1);
rho_AS    = M1(35,1);
rho_ABC   = M1(36,1);
rho_ABS   = M1(39,1);
rho_Imp   = M1(40,1);
rho_S     = M1(37,1);
rho_MgCO3 = M1(42,1);

% R3-carbonation MgCO3 yield [%]
MgCO3_yield = M1(9,1);
MgSO4_yield = M1(4,1);
FeO3_yield = M1(7,1);

MgCO3_k =  M1(44,1); % reaction rate constant k in 1/h
MgSO4_k = M1(43,1); %leaching rate constant k in 1/h

time_PH_adjustment = M1(45,1);

velocity_gradient=500;
g_earth = M1(32,1);
factor_pump_head = M5(7,1);
pump_eff = M5(5,1);
factor_mineral_purity = M1(41);

factor_moisture_product_1 = M1(6,1);
factor_moisture_product_2 = M1(8,1);
factor_moisture_product_3 = M1(10,1);

%global max_diameter
%max_diameter = 0.5;%max in m

thickness_centrifuge_wall = M5(47,1); %in [m]
speed_centrifuge = M5(48,1);

%Pumping:
p_r3            = M5(7,1);%pressure of carbonation reaction_in
p_r2            = M5(20,1);
p_r1            = M5(21,1);

%% electricity demand-crushing [MWh/a]
w_crushing = e_crushing*Mass_in_out(1,1)/1000;

%% electricity demand-grinding [MWh/a]
w_grinding = e_grinding*Mass_in_out(1,1)/1000;

%% electricity demand-co2 capture [MWh/a]
w_co2capture = e_co2capture*Mass_in_out(12,15)/1000;

%% electricity demand-R1-mineral dissolution [MWh/a]-----------------------

% Calculate the total vol of reactor [m3]

s_l_ratio_R1 = (Mass_in_out(1,1))/sum(Mass_in_out(:,1));% calculate solid liquid ratio 
rho_solution_R1 = density_ABS(Mol_in_out(2,1)/Mass_in_out(5,1));  % Calcualate molarity for density : [kmol/a]/[t/a] = mol/kg = mol/l
[viscos_slurry_R1,rho_reaction_R1] = viscosity_density(rho_solution_R1,rho_S,s_l_ratio_R1,t_R1_in);
rho_reaction_R1 = rho_reaction_R1/1000; % transform density into t/m3

total_vol_r1 = sum(Mass_in_out(:,1))/rho_reaction_R1/opt_hrs; % mass[t/a]/rho_reaction[t/m3]/opt_hrs[h/a]*time_reaction[h]

% adapt CSTR sizing to batch volume:  
space_time_R1 = MgSO4_yield/(MgSO4_k*(1-MgSO4_yield));%X/(k*(1-X))
total_vol_r1   = total_vol_r1*space_time_R1; %V = vo*X/(k*(1-X)) in [m3/h]*[h] =

% Power needed [kW/a]
w_md_stirring_R1= electricity_stirring(viscos_slurry_R1,opt_hrs,velocity_gradient,total_vol_r1); %[kwh/a]
w_md_pump_R1 = electricity_pumping(total_vol_r1,space_time_R1,opt_hrs,g_earth,(factor_pump_head*p_r1),rho_reaction_R1*1000,pump_eff); %[kWh/a]

w_R1 = (w_md_stirring_R1+w_md_pump_R1)/1000; %sum up and transform into MWh/a


%% electricity demand-R2-PH adjustment [MWh/a]--------------------------%%%
% Calculate the total vol of reactor [m3]

s_l_ratio_R2 = (Mass_in_out(9,4))/sum(Mass_in_out(:,4));% calculate solid liquid ratio, as material pretisipates the exit point as seen as the misture present
rho_solution_R2 = density_AS(Mol_in_out(6,4)/Mass_in_out(5,4));  % Calcualate molarity for density : [kmol/a]/[t/a] = mol/kg = mol/l
[viscos_slurry_R2,rho_reaction_R2] = viscosity_density(rho_solution_R2,rho_Imp,s_l_ratio_R2,t_R2_in);
rho_reaction_R2 = rho_reaction_R2/1000; % transform density into t/m3

total_vol_R2 = sum(Mass_in_out(:,1))/rho_reaction_R2/opt_hrs*time_PH_adjustment; % mass[t/a]/rho_reaction[t/m3]/opt_hrs[h/a]*time_reaction[h]

% as there is no data available how long it may take to adjust the pH, it is a guess here:

% Power needed [kW/a]
w_md_stirring_R2= electricity_stirring(viscos_slurry_R2,opt_hrs,velocity_gradient,total_vol_R2); %[kwh/a]
w_md_pump_R2 = electricity_pumping(total_vol_R2,time_PH_adjustment,opt_hrs,g_earth,(factor_pump_head*p_r2),rho_reaction_R2*1000,pump_eff); %[kWh/a]

w_R2 = (w_md_stirring_R2+w_md_pump_R2)/1000; %sum up and transform into MWh/a

%% electricity demand-R3-Carbonation [MWh/a]----------------------------%%%
% Calculate the total vol of reactor [m3]

s_l_ratio_R3 = (Mass_in_out(10,6))/sum(Mass_in_out(:,6));% calculate solid liquid ratio, as material pretisipates the exit point as seen as the misture present
rho_solution_R3 = density_AS(Mol_in_out(6,6)/Mass_in_out(5,6));  % Calcualate molarity for density : [kmol/a]/[t/a] = mol/kg = mol/l
[viscos_slurry_R3,rho_reaction_R3] = viscosity_density(rho_solution_R3,rho_MgCO3,s_l_ratio_R3,t_R3_in);
rho_reaction_R3 = rho_reaction_R3/1000; % transform density into t/m3

total_vol_R3 = sum(Mass_in_out(:,1))/rho_reaction_R3/opt_hrs; % mass[t/a]/rho_reaction[t/m3]/opt_hrs[h/a]

% adapt CSTR sizing to batch volume: 
    
space_time_R3 = MgCO3_yield/(MgCO3_k*(1-MgCO3_yield));%X/(k*(1-X))
total_vol_R3   = total_vol_R3*space_time_R3; %V = vo*X/(k*(1-X)) in [m3/h]*[h] =

% Power needed [kW/a]
w_md_stirring_R3= electricity_stirring(viscos_slurry_R3,opt_hrs,velocity_gradient,total_vol_R3); %[kwh/a]
w_md_pump_R3 = electricity_pumping(total_vol_R3,space_time_R3,opt_hrs,g_earth,(factor_pump_head*p_r3),rho_reaction_R3*1000,pump_eff); %[kWh/a]

w_R3 = (w_md_stirring_R3+w_md_pump_R3)/1000; %sum up and transform into MWh/a

%% electricity demand separation [MWh/a] ------------------------------%%%

% Centrifuge 1 - Silica (1µm)S6
m_dewater_1 = ((Mass_in_out(5,2))-(Mass_in_out(4,2)+Mass_in_out(1,2))/(1-factor_moisture_product_1)*factor_moisture_product_1) ; % water going in - water staying in the product [t/a]
[d_dewater_1,l_dewater_1,numbr_dewater_1] = design_dewater_centrifuge(m_dewater_1/opt_hrs,3000);
solid_in_dewater_1 = ((Mass_in_out(1,2)+Mass_in_out(4,2))/numbr_dewater_1); %in [t/a]
liquid_in_dewater_1 = (Mass_in_out(5,2)/numbr_dewater_1); %in [t/a]
w_centrifuge_1 = electricity_solid_bowl_centrifuge_v3(d_dewater_1,l_dewater_1,thickness_centrifuge_wall,speed_centrifuge,solid_in_dewater_1/opt_hrs,liquid_in_dewater_1/opt_hrs);
w_centrifuge_1 = w_centrifuge_1*numbr_dewater_1*opt_hrs; %[kW]*h = kWh

% Magnetic separation (1µm)S10


% Centrifuge 3 - MgCO3 (5µm)S14
m_dewater_3 = (Mass_in_out(5,6))-(Mass_in_out(10,6))/(1-factor_moisture_product_3)*factor_moisture_product_3 ; % water going in - water staying in the product [t/a]
[d_dewater_3,l_dewater_3,numbr_dewater_3] = design_dewater_centrifuge(m_dewater_3/opt_hrs,3000);
solid_in_dewater_3 = (Mass_in_out(10,6)/numbr_dewater_3); %in [t/a]
liquid_in_dewater_3 = (Mass_in_out(5,6)/numbr_dewater_3); %in [t/a]
w_centrifuge_3 = electricity_solid_bowl_centrifuge_v3(d_dewater_3,l_dewater_3,thickness_centrifuge_wall,speed_centrifuge,solid_in_dewater_3/opt_hrs,liquid_in_dewater_3/opt_hrs);
w_centrifuge_3 = w_centrifuge_3*numbr_dewater_3*opt_hrs; %[kW]*h = kWh

w_separation = (w_centrifuge_1+w_centrifuge_3)/1000; %sum up and transform into MWh/a

%% Electricity demand Additive regeneration

w_evaporation = electricity_compression_steam(1.44,Mass_in_out(5,9)); % For heat recovery water vapour is compressed (Ostovari et al) to 1.44 bar
w_evaporation = w_evaporation/1000; %transform kWh into MWh

%% Total electricity & Heating needed [MWh/a]

w_total = w_crushing+w_grinding+w_co2capture+w_R1+w_R2+w_R3+w_separation+ w_evaporation ;
q_fu_total = (q_fu_1+q_fu_2+q_fu_3+q_fu_4+q_fu_5)*opt_hrs/1000;%[kW]*[h/a]/1000[KWh/MWh]= MWh

%% Tabulate results 
Equipment_label = {'Crushing[MWh/a]';'Grinding[MWh/a]';'CO2-Capture[MWh/a]';'Mineral Dissolution[MWh/a]';'pH-Adjustment[MWh/a]';'Carbonation[MWh/a]';'Separation in [MWh/a]'; 'Evaporation in [MWh/a]'};
Electricity_Demand = [w_crushing; w_grinding; w_co2capture; w_R1;w_R2;w_R3;w_separation; w_evaporation];
Electricity_Demand_fu = Electricity_Demand /fu_cement_replacement;
Result_electricity_demand = table(Equipment_label,Electricity_Demand,Electricity_Demand_fu);
Result_electricity_demand.Properties.VariableNames ={'Description'; 'Energy demand in [MWh/a]';'Energy demand in [MWh/t]'};

