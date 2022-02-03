%------------------- ---Mass Balance_V2----------------------------------%

% All calculations are done on Excel, base on 5 main reactions 
% All values are scaled w.r.t capacity of cement plant (variable)
% R1- Mineral Dissolution (Extraction of Mg)
% R2- PH Adjustment + Removal of Impurities 
% R3- Carbonation of MgCO3
% R4- Additives Regeneration 
% R5- CO2 Capture 

mw_S     = M1(18,1); %Molar weight of Serpentine [g/mol]
mw_ABS   = M1(19,1);%Molar weight of NH4HSO4 [g/mol]
mw_MgSO4 = M1(20,1);%Molar weight of MgSO4 [g/mol]
mw_SiO2  = M1(21,1);%Molar weight of SiO2 [g/mol]
mw_H2O   = M1(22,1);%Molar weight of Water [g/mol]
mw_AS    = M1(23,1);%Molar weight of (NH4)2SO4 [g/mol]
mw_Imp_1 = M1(24,1);%Molar weight of Fe2(SO4)3 [g/mol]
mw_NH4OH = M1(25,1);%Molar weight of NH4OH [g/mol]
mw_Imp_2 = M1(26,1);%Molar weight of Fe(OH)3 [g/mol]
mw_MgCO3 = M1(27,1);%Molar weight of MgCO3 [g/mol]
mw_ABC   = M1(28,1);%Molar weight of NH4HCO3 [g/mol]
mw_CO2   = M1(29,1);%Molar weight of CO2 [g/mol]
mw_NH3   = M1(30,1);%Molar weight of NH3 [g/mol]

MW_all = [mw_S; mw_ABS; mw_MgSO4; mw_SiO2; mw_H2O; mw_AS; mw_Imp_1; mw_NH4OH; mw_Imp_2; mw_MgCO3; mw_ABC; mw_CO2; mw_NH3];

opt_hrs = M5(8,1);
ratio_s_l = M1(48,1);

%% Create Mass balance Matrix-------------------------------------------%%%
Mass_in_out = reshape(M2(:,2),13,16); % import mass balance from excel sheet in kg/h
Mass_in_out = Mass_in_out.*(opt_hrs/1000); %change to t/a

%% scale Mass balance---------------------------------------------------%%%

% Derive scaling factor for mass balance scaling 
ratio_cement_CEMI_max = [M5(39,1); M5(40,1)];
blending_ratio_SiO2 = ratio_cement_CEMI_max(1)/(ratio_cement_CEMI_max(1)+ratio_cement_CEMI_max(2)); % Amount of silica in final product
capacity_SiO2_ref = Mass_in_out(4,2);
capacity_SiO2_new = fu_cement_replacement*blending_ratio_SiO2; 
factor_scaling = capacity_SiO2_new/capacity_SiO2_ref;

% Scale mass balance
Mass_in_out = Mass_in_out*factor_scaling;

%% adapt S/L ratio, if needed:
ratio_s_l_in_data = ((Mass_in_out(1,1)+Mass_in_out(7,1))/(Mass_in_out(5,1)));
if  ratio_s_l_in_data ~= ratio_s_l
    m_solid = (Mass_in_out(1,1)+Mass_in_out(7,1));
    m_total = m_solid /(ratio_s_l);
     Mass_in_out(5,1) = m_total*(1-ratio_s_l);
    
end
%% Create Mass i/o matrix for moles and tonnes--------------------------%%%

%kmol/a
Mol_in_out = zeros(13,16); %[kmol/a]

for i = 1:16
    Mol_in_out (1:13,i) = Mass_in_out(1:13,i).*1000 ./MW_all; % [t/a]*[kg/t]*[kg/kmol]in and outflow in kmol/a
end


%% Export results-------------------------------------------------------%%%

Result_Mass_balance_label = Mass_i_o_TXT(18:end);
Result_Mass_balance = table(Result_Mass_balance_label,Mass_in_out(:,1),Mass_in_out(:,2),Mass_in_out(:,3),Mass_in_out(:,4),Mass_in_out(:,5),Mass_in_out(:,6),Mass_in_out(:,7),Mass_in_out(:,8),Mass_in_out(:,9),Mass_in_out(:,10),Mass_in_out(:,11),Mass_in_out(:,12),Mass_in_out(:,13),Mass_in_out(:,14),Mass_in_out(:,15),Mass_in_out(:,16));
Result_Mass_balance.Properties.VariableNames = Mass_i_o_TXT(1:17);

