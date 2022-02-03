%-----------------------%% Energy balance V2 %%---------------------------%
% the energy balances are computed using the shomate equation and the heat
% of formation. Coefficionts for more compounds are available on webbock.NIST.gov
% the general function is Delta_H = Heat_of_formation + Integral(cp)dT
% The Shomate equation can be described as followed: 
%fun_shomate = @(t)a_sho+b_sho.*t+c_sho.*t^2+d_sho.*t.^3+e_sho.*t.^-2

%Define Enthalpy_in_out-matrix.
%It contains in first column the input streams and second column 
%the output streams of Enthalpy
    Enthalpy_in_out_carb = zeros(9,12);

%% Heat requirements:------------------------------------------------------

%%Heat exchangers----------------------------------------------------------
% The heat exchanger system is simply assumed, that in consists of a heat 
% exchanger to obtain the excess heat from the outgoing stream with heat
% exchanger 1, additional energy is provided using a natural gas powered
% furnace to obtain addtional heat. The heat obtained from the reaction is
% assumed to reused in th capture process. 

%import values for this calculation----------------------------------------
    t_carb_in = I4(1,7) ; %in [°C]
    t_carb_out = I4(1,8); %in[°C]
    t_standard = I1(26,1); %in [°C]
    t_delta_min = I1(36,1); %in [°C]
    t_reaction = t_carb_out; %in [°C]

    operating_hours = I1(6,1); %in [hours/a]

    time_reaction = I1(16,1); %in [h]
    operating_hours = I1(6,1); %in [h/a
    d_mineral = I1(13,1);
    d_H2O = I1(14,1);
    
    heat_requirement_pre_treatment = I4(3,6); %heat requirement in KWh /t mineral
    heat_pretreatment_needed= I1(38,1); % if 1 is selected, a furnace for the heattreatment will be included in the calculations
    
    factor_heat_transfer = I1(62,1); % import heat transfer coefficient in [W/m2K]
    speed_centrifuge = I1(63,1); % in RPM
    wall_thickness_centrifuge = I1(64,1); %in [m]
    p_drop_cyclone = I1(65,1); % pressure drop in cyclones in [bar]
    
    t_MEA_capture = I1(67,1); % Temparature of MEA stripper
    heat_cap_light_oil = I1(66,1);% heat capacity of lieght oil for heat transfer in kJ/kg*K
    
    %% for the energy balance / the heat integration-----------------------

    % heat exchanger 1:
    Enthalpy_in_out_he_1 = zeros(7,2);

    % select the shomate parameters for the different compounds in the stream.
    % They are safed in an matrix for each compound:
    Shomate_factors = zeros(7,5);
    Shomate_factors(1,:) = I3(18,1:5); % shomate equation factors CO2
    Shomate_factors(2,:) = I3(19,1:5); % shomate equation factors MgO
    Shomate_factors(3,:) = I3(20,1:5); % shomate equation factors SiO2 (bound)
    Shomate_factors(4,:) = I3(21,1:5); % shomate equation factors Fe2O3
    Shomate_factors(5,:) = I3(20,1:5); % shomate equation factors SiO2 (free) it equals to Sio2 bound
    Shomate_factors(6,:) = I3(22,1:5); % shomate equation factors MgCO3
    Shomate_factors(7,:) = I3(23,1:5); % shomate equation factors H2O

    % create an array with Enthalpy of formation: 
    Enthalpy_formation = zeros(7,1);
    Enthalpy_formation(1,:) = I3(18,6); % shomate equation factors CO2
    Enthalpy_formation(2,:) = I3(19,6); % shomate equation factors MgO
    Enthalpy_formation(3,:) = I3(20,6); % shomate equation factors SiO2 (bound)
    Enthalpy_formation(4,:) = I3(21,6); % shomate equation factors Fe2O3
    Enthalpy_formation(5,:) = I3(20,6); % shomate equation factors SiO2 (free)
    Enthalpy_formation(6,:) = I3(22,6); % shomate equation factors MgCO3
    Enthalpy_formation(7,:) = I3(23,6); % shomate equation factors H2O

    %calculate the needed energy for heating up the stream going into the
    %reactor (cold stream)

    t_in_he_1_warm = t_carb_out ; %Input temperature in [°C]
    t_out_he_1_warm = t_carb_in+t_delta_min; %Output temperature in [°C]

    Enthalpy_in_he_1 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_in_he_1_warm);
    Enthalpy_out_he_1 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_out_he_1_warm);
  
    %transform mass balance streams that are calculated as markup into
    %constant flowing streams: 
   
    % transfrom into kj/a:
    Enthalpy_in_he_1 = Enthalpy_in_he_1*1000.*Mol_in_out(4:10,4);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
    Enthalpy_out_he_1 = Enthalpy_out_he_1*1000.*Mol_in_out(4:10,4);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
  
    % calculate the heat transfer requirement for heat exchanger 1:
    q_he_1 = sum(Enthalpy_out_he_1)-sum(Enthalpy_in_he_1);
    
    %transfrom into kW:
    q_he_1 = (q_he_1 /(operating_hours*3600)); %(q_carb/(operating hours *3600s))
    
    %caluculate cp for the warm stream using shomate equation 
    %calculate cp using shomate equation
           
    Cp_he_min = heat_capacity_shomate(Shomate_factors,t_carb_in);
    Cp_he_max = heat_capacity_shomate(Shomate_factors,t_carb_out-t_delta_min);

    %calculate the average for each compound
    Cp_he_cold = [Cp_he_min,Cp_he_max];
    Cp_he_cold= mean (Cp_he_cold,2);
       
    
    % derive the output temperature for the cold stream
    delta_temp_he_1_cold = abs(q_he_1)/(sum(Mol_in_out(4:10,3).*Cp_he_cold ./((operating_hours*3600)))); %[kW]/(kmol/a*kj/kmol/(operatinghours*3600s))
    
    if t_reaction -(delta_temp_he_1_cold+t_standard)< t_delta_min
        delta_temp_he_1_cold = t_reaction - t_delta_min; % if the minimum temperature difference is undercut, it is set to that. 
    end
%% Heat exchanger 2 / Furnace----------------------------------------------

    Enthalpy_in_out_he_2 = zeros(7,2);

%calculate the needed energy for heating up the stream going into the
%reactor

%calculate the needed energy for heating up the stream going into the
    %reactor (cold stream)

    t_in_he_2 = t_standard+delta_temp_he_1_cold ; %Input temperature in [°C]
    t_out_he_2 = t_carb_in; %Output temperature in [°C]


    Enthalpy_in_he_2 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_in_he_2);
    Enthalpy_out_he_2 = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_reaction);
  
    % transfrom into kj/a:
    Enthalpy_in_he_2 = Enthalpy_in_he_2*1000.*Mol_in_out(4:10,3);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
    Enthalpy_out_he_2 = Enthalpy_out_he_2*1000.*Mol_in_out(4:10,3);% [kj/mol]*[1000 mol/kmol]*[kmol/a]
  
    % calculate the heat transfer requirement for heat exchanger 1:
    q_he_2 = sum(Enthalpy_out_he_2)-sum(Enthalpy_in_he_2);
    
    %transfrom into kW:
    q_he_2 = abs(q_he_2 /(operating_hours*3600)); %(q_carb/(operating hours *3600s))

    duty_he_2 = q_he_2/1000 ; %kW transformed into MW
    

%% Heat exchange 3 / Reaction----------------------------------------------

    Enthalpy_reaction = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t_reaction);
    q_reaction = abs(sum((Enthalpy_reaction.*Mol_in_out(4:10,4)-Enthalpy_reaction.*Mol_in_out(4:10,3))*1000)); % [kj/mol]*[1000 mol/kmol]*[kmol/a]
       
    m_cooling_oil_reactor = q_reaction/(heat_cap_light_oil*t_reaction-t_delta_min);%m = Q/(cp*dt)
    q_mea_capture = m_cooling_oil_reactor*heat_cap_light_oil*((t_reaction-t_delta_min)-(t_MEA_capture-t_delta_min));%Q = m*cp*dt
     
    %convert to GJ: 
    q_mea_capture = q_mea_capture/(1000*1000);

    
 %% Heating 4 / Heat Pre-Treatment, for serpentine, if necessary-----------
 
 if heat_pretreatment_needed == 1 %check if heattreatment ist used as pre-treatment     
    duty_he_3 = Mass_in_out(2,2)*(I4(3,6)/1000)/operating_hours ; %calculating the duty in MW (m_mineral [t/a]*electrictiy [kwh/t]/workinghours[h/a]/1000[kW/MW])
 else
     duty_he_3 = 0;
 end 
%% Electricty consumption

%import values for the calculation-----------------------------------------
    e_crushing = I4(3,3); %Electricity demand in kwh/t material
    e_grinding = I4(3,5); %Electricity demand in kwh/t material
    e_separation = I4(3,9); % Electricity demand in kwh/t CO2
    e_capture = I4(3,11);  %Electricity demand in kwh/t CO2 captured

    d_H2O = (I1(14,1)); %density water in t/m3
    t_slurry = t_carb_out; %temperature for slurry pumping is assumed to be the hot fluid.
    velocity_gradient=500;
    pump_head = I1(42,1)*I4(2,8); % Pressure of reaction in bar * hydralic head in m/bar, to convert it into a height.
    g_earth =  I1(43,1);
    pump_eta = I1(41,1);
    p_reaction = I4(2,8);
    k_reaction = I1(68,1);
    
    w_grinding37=70.31; %[kWh/ton solid] {Hangx2009}
    w_grinding10=150; %[kWh/ton solid] {O'Connor2005}
    bonds_constant=12.38 ; %[kWh/ton]	{Hangx2009}
    size_feed=200000; %[um] %Hesam assumption
    size_mineral = I1(69,1);

%%Calculation--------------------------------------------------------------

%%Crusher
    w_crushing = e_crushing * Mass_in_out(2,1);%w_chrushing = Energy demand (kWh/t)* olivine demand (t/a)

%%Grinding

e_grinding= +(bonds_constant*((10/((75)^0.5))-(10/((size_feed)^0.5)))); %[kwh/t]
if size_mineral==25
   e_grinding = e_grinding + 50;
elseif size_mineral<=37
   e_grinding = e_grinding + w_grinding37;
end





if size_mineral<=10
   e_grinding = e_grinding + w_grinding10;
end
    w_grinding = e_grinding *Mass_in_out(2,1);%w_grinding = Energy demand (kWh/t)* olivine demand (t/a)
       
%%Carbonation
    %Calculate energy requirements for pumping and mixing:
    
    space_time_reactor = yield_reaction_MgO/(k_reaction*(1-yield_reaction_MgO));%X/(k*(1-X))
    time_reaction = space_time_reactor;
         
    v_reactor_h2o = (((Mass_in_out(10,3))/operating_hours)*time_reaction / d_H2O);% derive volumne of liquid
    v_reactor_mineral_in = ((Mass_in_out(2,3)/ operating_hours)*time_reaction / (d_mineral)); %derive volume of mineraline
    slurry_vol = v_reactor_h2o + v_reactor_mineral_in;
   
    %adapt CSTR sizing to batch volume: 
    %ratio_v_cstr_v_batch = 0.4082*exp(2.0764*yield_reaction_MgO);% calculate volume ratio derived from literature
    %slurry_vol = slurry_vol*ratio_v_cstr_v_batch;
    
    %calculate viscosity & density of slurry in [10^-6 Pa*s] and [kg/m3]: 
    [viscos_slurry,d_reaction] = viscosity_and_density_slurry(d_H2O,d_mineral,s_l_ratio,t_reaction);

   %derive the energy need:  
   w_carb_stirring= electricity_slurry_stirring(viscos_slurry,operating_hours,velocity_gradient,slurry_vol); %[kwh/a]
   w_carb_pump = electricity_slurry_pumping(slurry_vol,time_reaction,operating_hours,g_earth,pump_head,d_reaction,pump_eta); %[kWh/a]
   
   w_compression = electricity_compression(p_reaction,Mass_in_out(4,3)); % caclulate energy requirement in [kwh/a]
    
%%Separation

%Hydro cyclone
s_l_ratio_cyclone = (m_mineral_in_cyclone+ m_SiO2_in_cyclone+m_MgCO3_in_cyclone) / (m_mineral_in_cyclone+ m_SiO2_in_cyclone+m_MgCO3_in_cyclone+m_H2O_cyclone);
v_slurry_cyclone = (m_mineral_in_cyclone+ m_SiO2_in_cyclone+m_MgCO3_in_cyclone)/d_mineral + m_H2O_cyclone/d_H2O; % transfer mass streams into volumne streams
[viscos_cyclone,d_cyclone] = viscosity_and_density_slurry(d_H2O,d_mineral,s_l_ratio_cyclone,t_standard);
w_cyclone = electricity_slurry_pumping(slurry_vol,time_reaction,operating_hours,g_earth,p_drop_cyclone*10,d_cyclone,pump_eta);%[kWh/a]

% Classification centrifuge ---------------------------
flow_class_centrifuge = m_Mg2SiO4_in_class_centrifuge +m_FeO_in_class_centrifuge + m_SiO2_in_class_centrifuge + m_MgCO3_in_class_centrifuge + m_H2O_in_class_centrifuge;
[numbr_class_centrifuge, diameter_class_centrifuge] = Design_conv_centrifuge_v3(flow_class_centrifuge/operating_hours);
duty_class_centrifuge = numbr_class_centrifuge*electricity_conv_centrifuge_v3(diameter_class_centrifuge);% duty in kW
w_class_centrifuge = duty_class_centrifuge*operating_hours; %transform into kWh/a

%Dewatering -----------------------------------------
flow_dewater_2 = m_H2O_wet_dewater_2/operating_hours; %Sum of flow into the dewatering centrifuge in [t/h]
flow_solid_dewater_2 = (m_MgCO3_in_dewater_2+ m_SiO2_in_dewater_2+m_FeO_in_dewater_2+m_Mg2SiO4_in_dewater_2)/operating_hours;%Sum of flow into the dewatering centrifuge in [t/h]
%flow_dewater_2 = flow_dewater_2/2;
[diameter_dewater_2,l_dewater_2,numbr_dewater_2] = Design_dewater_II(flow_dewater_2,speed_centrifuge);
duty_dewater_2 = numbr_dewater_2*electricity_solid_bowl_centrifuge_v3(diameter_dewater_2, l_dewater_2,wall_thickness_centrifuge,speed_centrifuge, flow_solid_dewater_2, flow_dewater_2); % duty in kW
w_dewater_2 = duty_dewater_2*operating_hours; %transform into kWh/a

w_separation = w_dewater_2 + w_class_centrifuge + w_cyclone;  

%%CO2 capture
w_capture = e_capture *Mass_in_out(4,3); % w_capture = Energy demand (kWh/t)*co2 demand (t/a) in [kWh/a]

%%Consolidate in one matrix
W_total = [w_crushing,w_grinding,w_carb_stirring,w_carb_pump,w_separation,w_capture,w_compression];% in kWh/a
W_total = W_total/1000; %transpose into MWh/a
    