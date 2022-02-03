%------------------%% Electricity slurry pumping %%-----------------------%
% This function calculates the electricity needed for slurry pumping in
% [kwh/a]


%The inputs for this function is the following:
%slurry_vol; Volume in [m3]
%time_reaction;time of reaction in [h]
%operating_hours; in [h/a]
%g_earth; Gravity of the earth in [m/s2]
%pump_head; Hight of pumping in [m]
%density_slurry; density of slurry in [kg/m3]
%pump_eta; Efficiency of pump.

%If a certain pressure wants to be reached, the pump head is calculated as
%follows: % Pressure of reaction in bar * hydralic head in m/bar, to convert it into a height

%% Calculation-------------------------------------------------------------
function w_slurry_pumping = electricity_pumping(slurry_vol,time_reaction,operating_hours,g_earth,pump_head,density_slurry,pump_eta)

    %derive the energy need:  
    w_slurry_pumping = ((((slurry_vol/(time_reaction*3600)))*g_earth*pump_head*(density_slurry)/pump_eta)/1000)*operating_hours;

end