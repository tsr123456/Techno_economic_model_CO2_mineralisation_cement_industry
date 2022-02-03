%------------------%% Electricity Slurry stirring %%-----------------------%
% This function calculates the electricity needed for compression in
% [kwh/a]


%The inputs for this function is the following:
%viscos_slurry; Viscosity of the slurry in [10^-6 Pa*s]
%operating_hours; in [h/a]
%velocity_gradient; Stirring speed in [1/s]
%slurry_vol; Volumne of slurry in [m3]

%% Calculation-------------------------------------------------------------
function w_slurry_stirring = electricity_stirring(viscos_slurry,operating_hours,velocity_gradient,slurry_vol)

    %derive the energy need:  
    w_slurry_stirring =(slurry_vol*(velocity_gradient^2)*operating_hours*viscos_slurry)/1000; %[kWh/a]

end