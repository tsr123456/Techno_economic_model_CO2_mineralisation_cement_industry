%----------------------%% Viscosity & density calculator %%-------------------------%
% The inputs for this function is the following:
% density_H2O; density of H2O in [kg/m3]
%density_solid; density of mineral in [kg/m3]
%s_l_ratio_mass; solid liquid ratio by mass between 0 and 1, 1 meaning 100%
%solid (in theory)
%t; Temperature in [°C]
%viscosity_factors; viscosity factors derived from Wärmeatlas.


% the eauations are taken from Wärmeatlas (viscosity) and chapter 10, Slurry
%& Sludge Systems Piping, "Piping Calculations Manual" by E. Shashi Menon.
%This function calculates the viscosity in [10^-6 Pa*s] and the density in
%[kg/m3]

%% Calculation-------------------------------------------------------------

function [viscosity_slurry,density_slurry] = viscosity_and_density_slurry(density_H2O,density_solid,s_l_ratio_mass,t)
viscosity_factors = [0.00000000004000000000, -0.00000004910000000000, 0.00002318516000000000, -0.00551743063000000000, 0.70621623014000000000, -48.79206498234000000000, 1763.78404795984000000000];
% transform the solid liquid rati from abosolute numbers into "%"
s_l_ratio_mass = s_l_ratio_mass*100; 

%calculate the density of the mixture
density_slurry = 100/((s_l_ratio_mass/(density_solid*1000))+((100-s_l_ratio_mass)/(density_H2O*1000))); %calculate the density of the slurry

%calculate the concentration by volumne
s_l_ratio_volumne = s_l_ratio_mass*(density_H2O/density_solid);

%derive the volumne fraction
volumne_fraction = s_l_ratio_volumne/100;

%calculate the visicosity of water
viscosity_h2o = viscosity_factors(1)*(t^6)+viscosity_factors(2)*(t^5)+viscosity_factors(3)*(t^4)+viscosity_factors(4)*(t^3)+viscosity_factors(5)*(t^2)+viscosity_factors(6)*(t^1)+viscosity_factors(7); % viscosity in kg/(m*s)

%calculate the viscoisty of the mixture in [Pa*s] 
if volumne_fraction >= 1
    viscosity_slurry = viscosity_h2o*(1+2.5*volumne_fraction);
else
     viscosity_slurry = viscosity_h2o*(1+2.5*volumne_fraction+10.06*(volumne_fraction^2)*0.00273*exp(16.6*volumne_fraction));
end

%Adaot the unit to 10^-6 Pa*s:
viscosity_slurry = viscosity_slurry*10^-6;
end