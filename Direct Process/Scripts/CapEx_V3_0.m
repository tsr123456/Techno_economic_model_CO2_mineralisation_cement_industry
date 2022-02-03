%----------------------%% CAPEX calculation V 2 %%------------------------%
%The CapEx are calculated using calculating the bottom up the equipment
%costs and then using factorial method the CapEx are derived. For the
%capture process in detail assessments exist. They are used and scaled &
%location adapted. 


%% Import factors----------------------------------------------------------
co2_in =  Mass_in_out(4,3) ; % co2 used in reactor from mass balance
fgas_in = Mass_in_out(1,7); %Flue gas input to CO2 capture from mass balance
mineral_in = Mass_in_out(2,3); % Mineral input for carbonation reaction from mass balance
operating_hours = I1(6,1);%operating hours in hours / year
exchange_rate_USD_EUR = I1(7,1); %exchange rate in USD/EUR in the year 2019
heat_pretreatment_needed= I1(38,1); % if 1 is selected, a furnace for the heattreatment will be included in the calculations


interest = I1(3,1); % interest rate on capital
lifetime = I1(2,1); % expected lifetime of the plant
time_constr = I1(50,1); %years of construction
factor_learning_rate = I1(51,1);% Learning rate
numbr_plants_NOAK = I1(52,1); %construction time in years

tw_reactor_max = I1(34,1); %maximal wall thickness reactor
je_reactor = I1(17,1); %joint efficiency reactor
sf_reactor = I1(18,1); %security factor for used pressure in reactor
d_reactor = I1(21,1); %density of reactor material
mat_reactor = I1(20,1); %material reactor, 0=CS, 1=SS
maximum_reactor_size = I1(12,1); % maximum reactor size in m3
gasphase_reactor = I1(11,1); %gasphase in reactor as a factor (i.e. o.3)

k_he_1 = 500; % heat exchange coefficient in [W/m2K]
max_size_heat_exchanger = I3(16,8); % maximum size of heat exchanger in [m2]

%Post processing
efficiency_cyclone = 0.75;

factor_process_contingencies = I2(97,1);
factor_indirect_costs = I2(98,1);
factor_owners_costs = I2(99,1);
factor_project_contingencies = I2(100,1);

%% Calculate Total Direct Costs (TDC)--------------------------------------
% in the following lines the equipment costs are calculated for each
% process unit seperately. 

%% CONE CRUSHER------------------------------------------------------------
% Ec_crush, equipment cost in €

% calculate the equipment costs
tdc_crush = Direct_costs_cone_crusher_v3(m_mineral_in_carb/operating_hours);

%% BALL MILL---------------------------------------------------------------

tdc_mill = Direct_costs_ball_mill_v3(w_grinding/operating_hours); % calcualte the eqipment costs for grinding. 

%% Furnace for Heat treatment----------------------------------------------

if heat_pretreatment_needed == 1
flow_rate_furnace_2 = (m_mineral_in_carb/operating_hours)/d_mineral; % calculate flow rate for furnace [t/a]/[h/a]/[t/m3] = [m3/h]
tdc_furnace_2 = Direct_costs_furnace_v3(duty_he_3,flow_rate_furnace_2);
elseif heat_pretreatment_needed == 0
     tdc_furnace_2 = 0;
end

%% Carbonation reactor-----------------------------------------------------

%Reactor Vessel: 
%calculate liquid volumne for batch operation: 
v_reactor_mineral_in = ((Mass_in_out(2,3)* 1000 / operating_hours)*time_reaction / (d_mineral*1000)); %derive volume of mineraline
v_reactor_h2o = (((Mass_in_out(10,3))* 1000/operating_hours)*time_reaction / (I1(14,1)*1000)); %derive volume of H2O

%factor in liquid phase from batch reactor design
v_reactor = v_reactor_mineral_in + v_reactor_h2o;

%transform batch reactor into CSTR:
ratio_v_cstr_v_batch = 0.4082*exp(2.0764*yield_reaction_MgO);% calculate volume ratio derived from literature
v_reactor = v_reactor*ratio_v_cstr_v_batch;

%calculate the costs of the reactor as a pressure vessel:
[numbr_reactor, size_reactor,~,tw_reactor] =  Design_pressure_vessel(tw_reactor_max,maximum_reactor_size,v_reactor,p_reaction,sf_reactor,mat_reactor,je_reactor,d_reactor,t_reaction,I3);
tdc_reactor_vessel = Direct_costs_reactor_v3(p_reaction, size_reactor)* numbr_reactor;

%Reactor Agitator
duty_reactor_agitator = w_carb_stirring/operating_hours; % total amount of stirring power needed
tdc_reactor_agitator = Direct_costs_agitator_v3(duty_reactor_agitator /numbr_reactor)*numbr_reactor; %calculate the tdc for all agitators

% Sum up costs for the reactor:
tdc_reactor = tdc_reactor_vessel + tdc_reactor_agitator;

%% Heat exchangers and furnace of Carbonation------------------------------

% derive equipment costs for heat exchanger
[numbr_he_1,area_he_1_maxium_size] = design_heat_exchanger(t_carb_out,t_carb_out-t_delta_min,t_carb_in,delta_temp_he_1_cold+t_carb_in,q_he_1,k_he_1,max_size_heat_exchanger); %design heat exchanger
tdc_he_1 = Direct_costs_he_v3(area_he_1_maxium_size,p_reaction).*numbr_he_1; % calculate total direct costs in EUR

% Equipment costs of heat exchanger 2, the furnace / duty calculated in energy balance
flow_rate_he_2 = (((Mass_in_out(10,3))* 1000/operating_hours) / (I1(14,1)*1000))+((Mass_in_out(2,3)* 1000 / operating_hours)/ (d_mineral*1000)); % volumetric flow rate for the furnace = V_mineral + V_H20 in [m3/h]
tdc_he_2= Direct_costs_furnace_v3(duty_he_2*1000,flow_rate_he_2); %calculate total direct costs in EUR

%Add costs for heat exchangers
tdc_he = tdc_he_2 + tdc_he_1;

%% Compression & pumping---------------------------------------------------

%Co2 compression
tdc_compressor = Direct_costs_co2_compressor_v3(w_compression/operating_hours); %calculate tdc according to duty in kW.

%Slurry pumping for compression
flow_rate_pumping = flow_rate_he_2; % define flow rate for pumping in m3/h
tdc_pumping = Direct_costs_centr_pump_v3(flow_rate_pumping,p_reaction); %calculate tdc according to flow rate and pressure.

%Sum up all compression equipment:
tdc_compression = tdc_compressor+ tdc_pumping; 

%% Post-treatment / Separation--------------------------------------------------------------

% Hydrocyclones-----------------------------------------
m_solid_carb_out = m_Mg2SiO4_out_carb +m_FeO_out_carb + m_SiO2_out+ m_MgCO3_out_carb;
[numbr_cyclones, diameter_cyclones] = Design_cyclones_v3(efficiency_cyclone,m_solid_carb_out);

numbr_cyclones = round(numbr_cyclones,0);
numbr_cyclones_max = numbr_cyclones;

if numbr_cyclones_max > 100
    while numbr_cyclones_max >100
        numbr_cyclones_max = numbr_cyclones_max/2; %devide the number of cyclones by two until they are smaller than 100 pcs per manifold. 
     end
end

tdc_cyclone = Direct_costs_hydro_cyclone_v3(numbr_cyclones_max,diameter_cyclones).*numbr_cyclones; %tdc per pc* numbr of pcs.

% Dewatering I-------------------------------------------
%flow_dewater_1 = m_H2O_wet_dewater_1/operating_hours; %Sum of flow into the dewatering centrifuge in [t/h]
%[diameter_dewater_1,l_dewater_1,numbr_dewater_1] = Design_dewater_I(flow_dewater_1,speed_centrifuge);
tdc_dewater_1 =0; %numbr_dewater_1*Direct_costs_solid_bowl_centrifuge_v3(l_dewater_1 ,diameter_dewater_1);

% Classification centrifuge ---------------------------
flow_class_centrifuge = m_Mg2SiO4_in_class_centrifuge +m_FeO_in_class_centrifuge + m_SiO2_in_class_centrifuge + m_MgCO3_in_class_centrifuge + m_H2O_in_class_centrifuge;
diameter_class_centrifuge = Design_conv_centrifuge_v3(flow_class_centrifuge/operating_hours);
tdc_class_centrifuge = Direct_costs_conv_centrifuge_v3 (diameter_class_centrifuge);

%Dewatering II-----------------------------------------
%flow_dewater_2 = m_H2O_wet_dewater_2/operating_hours;
%[diameter_dewater_2,l_dewater_2,numbr_dewater_2] = Design_dewater_II(flow_dewater_2,speed_centrifuge); %design according to liquid flow in t/h
tdc_dewater_2 = numbr_dewater_2*Direct_costs_solid_bowl_centrifuge_v3(l_dewater_2 ,diameter_dewater_2);

%Sum up post-treatment:
tdc_post_treatment = tdc_cyclone + tdc_dewater_1 + tdc_class_centrifuge + tdc_dewater_2 ; 

%% CO2 capture-------------------------------------------------------------
tdc_capture = Direct_costs_capture_v3(m_CO2_in_carb); %calculation of tdc according to t/a CO2 captured.

%% Calculate Capex acccording to Rubin et al------------------------------

tdc_total = tdc_mill + tdc_crush + tdc_reactor+ tdc_compression + tdc_he+ tdc_furnace_2 + tdc_capture + tdc_post_treatment;% total equipment costs

epc_total = tdc_total*(1+factor_indirect_costs);%Eng. Proc. Construction costs
tpc_total = epc_total*(1+factor_process_contingencies)*(1+factor_project_contingencies); % Add process contingencies. ;%total plant costs 


% Adapt capital costs with learning rate.
factor_b_learning = -log(1-factor_learning_rate)/log(2);
tpc_total_NOAK = (tpc_total/fu_cement_replacement)*(numbr_plants_NOAK^-factor_b_learning);
tpc_total_NOAK = tpc_total_NOAK*fu_cement_replacement;

%Add interest during construction & owner's costs: Total Captial requirment
interest_during_constr = tpc_total_NOAK*interest*time_constr;
tcr_total = tpc_total_NOAK*(1+factor_owners_costs)+interest_during_constr;

capEx_total = tcr_total;

%Transform ec into capex, to compare in graph
capEx_crush = (tdc_crush/tdc_total)*capEx_total;
capEx_mill = (tdc_mill/tdc_total)*capEx_total;
capEx_reactor = (tdc_reactor/tdc_total)*capEx_total;
capEx_compression = (tdc_compression/tdc_total)*capEx_total;
capEx_heatexchanger = (tdc_he/tdc_total)*capEx_total;
capEx_furnace = (tdc_furnace_2/tdc_total)*capEx_total;
capEx_post_treatment = (tdc_post_treatment/tdc_total)*capEx_total;
capEx_capture = (tdc_capture/tdc_total)*capEx_total;

%% Derive Annualized CapEx-------------------------------------------------

annual_CapEx = (interest/(1-((1+interest)^-lifetime)))*capEx_total ;

%% Tabulate results ----------------------------------------------------%%%

Equipment_CapEx = {'Crusher';'Grinder';'Reactors';'Compression';'Heat exchangers';'Furnaces';'Post-treatment (cyclones, centrifuges)';'Capture';};
TDC_all = [ tdc_crush; tdc_mill; tdc_reactor; tdc_compression; tdc_he; tdc_furnace_2; tdc_post_treatment; tdc_capture];
TDC_all_fu = TDC_all./fu_cement_replacement;
TPC_FOAK = TDC_all.*(tpc_total/tdc_total);
TCR_FOAK = TPC_FOAK.*(1+factor_owners_costs)+TPC_FOAK.*(interest*time_constr);
TCR_NOAK = TDC_all.*(tcr_total/tdc_total);
Result_TDC = table(Equipment_CapEx,TDC_all,TDC_all_fu,TCR_FOAK,TCR_NOAK);
Result_TDC.Properties.VariableNames ={'Equipment'; 'Total direct costs in [€]';'Spec. Total direct costs in [€/t]';'Total capital requirement for first of a kind plant in [€]'; 'Total capital requirement for nth of a kind plant in [€]'};
