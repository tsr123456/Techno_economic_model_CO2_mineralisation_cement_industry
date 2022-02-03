%-------------------------%% Mass Balance V2 %%---------------------------%

% The mass balance is calculated according to carbonation reaction and
% saved in two arrays: Mass_in_out & Mol_in_out. 
% Reaction Mg2SiO4 + 2CO2 --> 2MgCO3 +1SiO2

%create I/O vector for mass balance
Mass_in_out= zeros (17,8);

%% Input:

%fu_cement_replacement = ; %[t/a].The functional unit used, will be the amount of cement replacement/ clinker replacement produced. It consist of Silica (50%) and (50%)inert material. As the stoichiometry shows us, that more Silica is produced in the reaction. The calculations focus on this production. 

%% Inputs------------------------------------------------------------------

%get yield of reaction & molecular weights:
ratio_cement_CEMI_max = [I1(59,1),I1(60,1)];% mixing ratio. The ratio that should be hold for all cement replacements [SiO2; inert material]

factor_moisture_head_cyclone = 0.8;% moisture content dry output
factor_moisture_dry_dewater_1 = 0.3;% moisture content dry output
factor_moisture_dewater_2 = 0.1;% moisture content dry output
factor_moisture_classification_dry = 0.1; % moisture content of not-classified output
factor_classification_efficiency = 1.0; % classification efficiency for separation of SiO2

yield_reaction_MgO = I1(27,1);
yield_reaction_CO2 = I1(39,1); 
recovery_factor_unreacted_mineral= I1(28,1);
density_H2O = I1(14,1);

mW_CO2 = I3(29,1);%in [kg/kmol]
mW_MgO = I3(30,1); %in [kg/kmol]
mW_SiO2 = I3(31,1); % in [kg/kmol]
mW_Fe2O3 = I3(32,1);%in [kg/kmol]
mW_MgCO3 = I3(33,1);%in [kg/kmol]
mW_H2O = I3(34,1);%in [kg/kmol] 
mW_NaHCO3 = I3(35,1);%in [kg/kmol]
mW_NaCl = I3(36,1);%in [kg/kmol]
mW_Mg2SiO4 = I3(37,1);%in [kg/kmol]
mW_Oxalic_ac = I3(38,1);%in [kg/kmol]
mW_Ascorbic_ac = I3(39,1);%in [kg/kmol]
mW_MEA = I3(40,1); %in [kg/kmol]


stoe_coe_Mg2SiO4 = 1;
stoe_coe_SiO2 = 1;
stoe_coe_CO2 = 2;
stoe_coe_MgCO3 = 2;
mineral_purity = 0.85;
s_l_ratio = I1(15,1);
recycling_factor_H2O = I1(35,1);
concentration_NaHCO3 = I4(6,7);
concentration_NaCl = I4(7,7);
concentration_Oxalic_ac = I4(8,7); 
concentration_Ascorbic_ac = I4(9,7);

efficiency_capture = I1(25,1);
content_CO2_fluegas = I1(4,1);
makeup_MEA = I4(10,11); %in [tMea/tCO2captured
efficiency_classification = I1(53,1);


% determine the desired output (in terms of the FU):
m_SiO2_in = 0;
m_SiO2_out = fu_cement_replacement*(ratio_cement_CEMI_max(1)/sum(ratio_cement_CEMI_max));

%% Carbonation:------------------------------------------------------------ 

%Calcualte following the desired output the necessary input of material [all in t/a]
m_Mg2SiO4_in_carb = (m_SiO2_out / mW_SiO2)*(stoe_coe_Mg2SiO4 / stoe_coe_SiO2)*mW_Mg2SiO4; %%calculate the stoichimetric amount of mg2SiO4 need for the reaction
m_Mg2SiO4_in_carb = m_Mg2SiO4_in_carb * (1/yield_reaction_MgO) - m_Mg2SiO4_in_carb * ((1/yield_reaction_MgO)*(1-yield_reaction_MgO)*recovery_factor_unreacted_mineral);  % factor in recovery of unreacted mg2SiO4 and reaction rate
m_mineral_in_carb = m_Mg2SiO4_in_carb/mineral_purity; % in [tonne/a] mineral_in = mg2SiO4_in/mineral_purity;
m_MgO_in_carb = m_Mg2SiO4_in_carb * (2*mW_MgO/mW_Mg2SiO4); %m_MgO_in = mg2sio4_in*(2*Molcular weight MgO/molecular weight Mg2SiO4)
m_SiO2_bound_in_carb = m_Mg2SiO4_in_carb*(mW_SiO2/mW_Mg2SiO4); % the SiO2 that is bound in the mineral is calculated here, as it will be used in the enthalpy calc later. 
m_FeO_in_carb = m_mineral_in_carb *(max(0,1-mineral_purity)); %All impurities of the minerals are seen in the model as iron oxides. 
m_MgCO3_in_carb = 0;
m_CO2_in_carb =((m_SiO2_out/mW_SiO2)*(stoe_coe_CO2/stoe_coe_SiO2)*mW_CO2)*(1/yield_reaction_CO2); % The needed amount of CO2, that needs to react is set in accordance to the the FU

%calculate input of water & additive Markup:
m_H2O_in_carb = ((m_mineral_in_carb / s_l_ratio)-m_mineral_in_carb); %H2O_in = (mineral_in/X_water-mineral_in)*(1-Recycling factor)
m_NaHCO3_in_carb = (m_H2O_in_carb /density_H2O)*(concentration_NaHCO3*1000)*(mW_NaHCO3/(1000*1000));% m = (c*M*V)=c*M*(m_h2o*1000*density_h2O) in [t/a]=> Units used: [t/a]*[1000*g/1000*l]*[1000*mol/l]*[g/(mol*1000*1000)]
m_NaCl_in_carb = (m_H2O_in_carb /density_H2O)*(concentration_NaCl*1000)*(mW_NaCl/(1000*1000));% m = (c*M*V)=c*M*(m_h2o*1000*density_h2O) in [t/a]=> Units used: [t/a]*[1000*g/1000*l]*[1000*mol/l]*[g/(mol*1000*1000)]
m_Oxalic_ac_in_carb = (m_H2O_in_carb /density_H2O)*(concentration_Oxalic_ac*1000)*(mW_Oxalic_ac/(1000*1000)); % m = (c*M*V)=c*M*(m_h2o*1000*density_h2O) in [t/a]=> Units used: [t/a]*[1000*g/1000*l]*[1000*mol/l]*[g/(mol*1000*1000)]
m_Ascorbic_ac_in_carb =(m_H2O_in_carb /density_H2O)*(concentration_Ascorbic_ac*1000)*(mW_Ascorbic_ac/(1000*1000)); % m = (c*M*V)=c*M*(m_h2o*1000*density_h2O) in [t/a]=> Units used: [t/a]*[1000*g/1000*l]*[1000*mol/l]*[g/(mol*1000*1000)]

%calculate the outputs:
m_Mg2SiO4_out_carb = m_Mg2SiO4_in_carb *(1-yield_reaction_MgO-(1-yield_reaction_MgO)*recovery_factor_unreacted_mineral);
m_mineral_out_carb =m_mineral_in_carb*(1-mineral_purity) + m_Mg2SiO4_out_carb; %unreacted mineral consists of the mineral impurity added with the unreacted active componend (Magnesium Silicate) in [t/a]
m_MgO_out_carb = m_Mg2SiO4_out_carb* (2*mW_MgO/mW_Mg2SiO4); %m_MgO_in = mineral_in*purity*(Molcular weight MgO/molecular weight Mg2SiO4)
m_SiO2_bound_out_carb = m_Mg2SiO4_out_carb*(mW_SiO2/mW_Mg2SiO4); % the SiO2 that is bound in the mineral is calculated here, as it will be used in the enthalpy calc later. 
m_FeO_out_carb = m_mineral_in_carb *(max(0,1-mineral_purity)); %All impurities of the minerals are seen in the model as iron oxides. They are assumed to be inert to the reaction.
m_MgCO3_out_carb = m_MgO_in_carb *((yield_reaction_MgO)+ (1-yield_reaction_MgO)*recovery_factor_unreacted_mineral)*(mW_MgCO3/mW_MgO); %mgco3_out= mgo_in*yield_reaction*(yield+(1-yield)*recovery)*Mmgco3/Mmgo 
m_CO2_out_carb = 0;

%calculate output of water & additives: 
% It assumed, that none of the water or additives gets lost during the
% reaction, thus the values remain the same: 

m_H2O_out_carb = m_H2O_in_carb; % in [t/a]
m_NaHCO3_out_carb = m_NaHCO3_in_carb; % in [t/a]
m_NaCl_out_carb =  m_NaCl_in_carb; % in [t/a]
m_Oxalic_ac_out_carb = m_Oxalic_ac_in_carb; % in [t/a]
m_Ascorbic_ac_out_carb = m_Ascorbic_ac_in_carb; % in [t/a]

%% Capture-----------------------------------------------------------------

%Input values
m_CO2_in_capture = m_CO2_in_carb /efficiency_capture; %CO2_in_capture = cO2_in/efficiency of capture in [t/a]
m_Flue_in_capture = m_CO2_in_capture/(content_CO2_fluegas/100);%fgas_in = cO2_in/CO2 content in flue gas in [t/a]
m_Mea_in_capture = m_CO2_in_carb*makeup_MEA; %MEA needed = CO2 captured*mea makeup in[t/a]

%Output values
m_Flue_out_capture = m_Flue_in_capture*(1-((content_CO2_fluegas/100)*(efficiency_capture))); % in [t/a]
m_CO2_out_capture = m_CO2_in_capture*(1-efficiency_capture); %the output of the capture is here defined as leaving the system, not going to the carbonation reactors.
m_Mea_out_capture = m_Mea_in_capture; %The presented number here is the MEA markup. 

%% Separation--------------------------------------------------------------

% Cylones-----------------------------------------

%Input values
m_Mg2SiO4_in_cyclone =  m_Mg2SiO4_out_carb;
m_mineral_in_cyclone = m_mineral_out_carb;
m_MgO_in_cyclone = m_MgO_out_carb;
m_SiO2_in_cyclone = m_SiO2_out;
m_FeO_in_cyclone = m_FeO_out_carb;
m_MgCO3_in_cyclone = m_MgCO3_out_carb;
m_CO2_out_carb = 0;
m_H2O_cyclone = m_H2O_out_carb;

%bottom product
m_Mg2SiO4_bottom_cyclone = m_Mg2SiO4_in_cyclone*recovery_factor_unreacted_mineral;
m_FeO_bottom_cyclone = m_FeO_in_cyclone*recovery_factor_unreacted_mineral;

%head product
m_Mg2SiO4_head_cyclone = m_Mg2SiO4_in_cyclone*(1-recovery_factor_unreacted_mineral);
m_FeO_head_cyclone = m_FeO_in_cyclone*(1-recovery_factor_unreacted_mineral);
m_SiO2_head_cyclone = m_SiO2_out;
m_MgCO3_head_cyclone = m_MgCO3_in_cyclone;
m_H2O_head_cyclone = ((m_Mg2SiO4_head_cyclone+m_FeO_head_cyclone+m_SiO2_head_cyclone+m_MgCO3_head_cyclone)/(1-factor_moisture_head_cyclone))*factor_moisture_head_cyclone; %the water content is specified through the simulation mad in Aspen. It is adapted here. 

% Classification centrifuge--------------------------------

% define share of stream going to classification
factor_SiO2_in_product = ratio_cement_CEMI_max(1)/(sum(ratio_cement_CEMI_max));% Derive desired SiO2 content in product: Content_SiO2_Cement / (Content_SiO2_Cement+Content_inert_Cement)
factor_SiO2_carb = m_SiO2_head_cyclone/(m_Mg2SiO4_head_cyclone+m_FeO_head_cyclone+m_SiO2_head_cyclone+m_MgCO3_head_cyclone);% Derive desired SiO2 content after carbonation & cyclones: m_SiO2 / m_inert;
share_class = (1-((1-factor_SiO2_in_product)/factor_SiO2_in_product)*(factor_SiO2_carb/(1-factor_SiO2_carb))+((1-factor_SiO2_carb)/factor_SiO2_carb)-((1-factor_SiO2_in_product)/factor_SiO2_in_product))/(1+((1-factor_SiO2_carb)/factor_SiO2_carb)); % derive share of material that needs to be classified: share = (1-((1-x)/x)*(y/(1-y))+((1-y)/y)-((1-x)/x))/(1+((1-y)/y))
share_class = share_class*(1+(1-efficiency_classification));

%Input: 
m_Mg2SiO4_in_class_centrifuge = m_Mg2SiO4_head_cyclone*share_class;
m_FeO_in_class_centrifuge = m_FeO_head_cyclone*share_class;
m_SiO2_in_class_centrifuge = m_SiO2_head_cyclone*share_class;
m_MgCO3_in_class_centrifuge = m_MgCO3_head_cyclone*share_class;
m_H2O_in_class_centrifuge = m_H2O_head_cyclone*share_class;

%Output Dry (inert material):

m_Mg2SiO4_dry_class_centrifuge = m_Mg2SiO4_in_class_centrifuge;
m_FeO_dry_class_centrifuge = m_FeO_in_class_centrifuge;
m_SiO2_dry_class_centrifuge = m_SiO2_in_class_centrifuge*(1-factor_classification_efficiency); %Only the non-separated SiO2 is going to the dry stream
m_MgCO3_dry_class_centrifuge = m_MgCO3_in_class_centrifuge;
m_H2O_dry_class_centrifuge = ((m_Mg2SiO4_dry_class_centrifuge+m_FeO_dry_class_centrifuge+m_SiO2_dry_class_centrifuge+m_MgCO3_dry_class_centrifuge)/(1-factor_moisture_classification_dry))*factor_moisture_classification_dry; %the water content is specified through the simulation mad in Aspen. It is adapted here. 

% Test: m_H2O_dry_class_centrifuge/m_H2O_dry_class_centrifuge/(m_Mg2SiO4_dry_class_centrifuge+m_FeO_dry_class_centrifuge+m_SiO2_dry_class_centrifuge+m_MgCO3_dry_class_centrifuge+m_H2O_dry_class_centrifuge)


%Output Wet (Silica): 

m_SiO2_wet_class_centrifuge = m_SiO2_in_class_centrifuge*(factor_classification_efficiency); %Only the non-separated SiO2 is going to the dry stream
m_H2O_wet_class_centrifuge = m_H2O_in_class_centrifuge-m_H2O_dry_class_centrifuge;

%Test:
%m_H2O_wet_class_centrifuge/(m_H2O_wet_class_centrifuge+m_SiO2_wet_class_centrifuge)

% Dewatering centrifuge_2----------------------------------
% Input:
%from hydro cyclone:
% all the material the did not go the classification (1-share), will be added here.
m_Mg2SiO4_in_dewater_2 = m_Mg2SiO4_head_cyclone* (1-share_class);  
m_FeO_in_dewater_2 = m_FeO_head_cyclone*(1-share_class);
m_SiO2_in_dewater_2 = m_SiO2_head_cyclone*(1-share_class);
m_MgCO3_in_dewater_2 = m_MgCO3_head_cyclone*(1-share_class);
m_H2O_in_dewater_2 = m_H2O_head_cyclone*(1-share_class);

%add amount from classification: 
m_SiO2_in_dewater_2 = m_SiO2_in_dewater_2 + m_SiO2_wet_class_centrifuge;
m_H2O_in_dewater_2 = m_H2O_in_dewater_2 + m_H2O_wet_class_centrifuge;

% Output Dry:
m_Mg2SiO4_dry_dewater_2 = m_Mg2SiO4_in_dewater_2;
m_FeO_dry_dewater_2 = m_FeO_in_dewater_2;
m_SiO2_dry_dewater_2 = m_SiO2_in_dewater_2;
m_MgCO3_dry_dewater_2 = m_MgCO3_in_dewater_2;
m_H2O_dry_dewater_2 = ((m_Mg2SiO4_in_dewater_2+m_FeO_in_dewater_2+m_SiO2_in_dewater_2+m_MgCO3_in_dewater_2)/(1-factor_moisture_dewater_2))*factor_moisture_dewater_2; 

%Test: 
%{
Xinert_Test = (m_Mg2SiO4_dry_dewater_2+m_FeO_dry_dewater_2+m_MgCO3_dry_dewater_2)/(m_Mg2SiO4_dry_dewater_2+m_FeO_dry_dewater_2+m_SiO2_dry_dewater_2+m_MgCO3_dry_dewater_2)
XSIO2_Test = m_SiO2_dry_dewater_2/(m_Mg2SiO4_dry_dewater_2+m_FeO_dry_dewater_2+m_SiO2_dry_dewater_2+m_MgCO3_dry_dewater_2)
Xh2O_Test = m_H2O_dry_dewater_2 / (m_H2O_dry_dewater_2+m_Mg2SiO4_dry_dewater_2+m_FeO_dry_dewater_2+m_SiO2_dry_dewater_2+m_MgCO3_dry_dewater_2)
%}

% Output Wet:
m_H2O_wet_dewater_2 = m_H2O_in_dewater_2 - m_H2O_dry_dewater_2;

%% Create Mass balance Arrays

%Mass balance in [t/a]
%Carbonation
Mass_in_out (:,3) = [0; m_mineral_in_carb; m_Mg2SiO4_in_carb; m_CO2_in_carb;m_MgO_in_carb;m_SiO2_bound_in_carb; m_FeO_in_carb;m_SiO2_in ;m_MgCO3_in_carb; m_H2O_in_carb;m_NaHCO3_in_carb;m_NaCl_in_carb;m_Oxalic_ac_in_carb;m_Ascorbic_ac_in_carb;0;0;0] ; % Mass i Carbonation in [t/a] 
Mass_in_out (:,4) = [0; m_mineral_out_carb; m_Mg2SiO4_out_carb; m_CO2_out_carb;m_MgO_out_carb;m_SiO2_bound_out_carb; m_FeO_out_carb;m_SiO2_out ;m_MgCO3_out_carb; m_H2O_out_carb;m_NaHCO3_out_carb;m_NaCl_out_carb;m_Oxalic_ac_out_carb;m_Ascorbic_ac_out_carb;0;0;0] ; % Mass  Carbonation in [t/a] 
%Pre-treatment
Mass_in_out (:,1) = Mass_in_out(:,3); % for the pre-treatment it is assumed, that no mass is lost, so it for now equals to the mass balance from the carbonation step
Mass_in_out (:,2) = Mass_in_out (:,3);
%Post-treatment
Mass_in_out (:,5) = Mass_in_out(:,4); % for the post-treatment it is assumed, that no mass is lost, so it for now equals to the mass balance from the carbonation step
Mass_in_out (:,6) = Mass_in_out (:,4);
%Capture
Mass_in_out (:,7) = [m_Flue_in_capture;0;0; m_CO2_in_capture; 0;0;0;0;0;0;0;0;0;0; m_Mea_in_capture; 0;0];
Mass_in_out (:,8) = [m_Flue_out_capture;0;0; m_CO2_out_capture; 0;0;0;0;0;0;0;0;0;0; m_Mea_out_capture; 0;0];

%transform also into molar flows
Mol_in_out = zeros(16,8); %in [kmol/a]

for i = 1:8
Mol_in_out (3:15,i) = Mass_in_out(3:15,i).*1000 ./[mW_Mg2SiO4;mW_CO2; mW_MgO;mW_SiO2;mW_Fe2O3; mW_SiO2;mW_MgCO3;mW_H2O;mW_NaHCO3;mW_NaCl;mW_Oxalic_ac;mW_Ascorbic_ac;mW_MEA]; % [t/a]*[kg/t]*[kg/kmol]in and outflow in kmol/a
end

%% Export results: 
%Mass_in_out = Mass_in_out./m_CO2_in_carb
results_Mass_balance_label = {'Flue gas in [t/a]','Mineral in [t/a]', 'Mg2SiO4 in [t/a]','CO2 in [t/a]','MgO in [t/a]','SiO2 (bound)in [t/a]', 'FeO in [t/a]','SiO2 (free) in [t/a]','MgCO3 in [t/a]','H2O in [t/a]', 'NaHCO3 in [t/a]', 'NaCl in [t/a]','Oxalic Acid in [t/a]', 'Ascorbic Acid in [t/a]', 'MEA in [t/a]', '...','...'};
results_Mass_balance_label = reshape(results_Mass_balance_label,[17,1]);
results_Mass_balance = table(results_Mass_balance_label ,Mass_in_out(:,1),Mass_in_out(:,2),Mass_in_out(:,3),Mass_in_out(:,4),Mass_in_out(:,5),Mass_in_out(:,6),Mass_in_out(:,7),Mass_in_out(:,8));
results_Mass_balance.Properties.VariableNames = {'Description' ' 1- Pre-treatment in' '2-Pre-treatment out' '3-Carbonation in' '4-Carbonation out' '5-Post_treatment in' '6-Post_treatment out' '7-Capture in' '8-Capture out'};

