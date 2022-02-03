%%%--------------% Energy demand disc centrifuge%------------------%%
% This function calculates the necessary power needed for solid bowl
% centrifuge at maximmum speed. Here, the power of the motor that a
% centrifuge is equiped, is taken as the energy input. 

%diameter in m
% power is calculated in kW

function power = electricity_conv_centrifuge_v3(diameter)

% transform diameter into mm:
diameter = diameter*1000;


power = 1.9339*exp(0.0039*diameter);

end

