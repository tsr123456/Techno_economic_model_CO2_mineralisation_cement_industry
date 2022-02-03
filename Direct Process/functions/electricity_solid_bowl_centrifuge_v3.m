%%%--------------% Energy demand Solid Bowl centirfuge%------------------%%
% This function calculates the necessary power needed for solid bowl
% centrifuge
%m_solid in t/h
%P_total = P_solid+P_liquid+P_empty_centrifuge

function power = electricity_solid_bowl_centrifuge_v3(diameter, length,thickness, n_bowl, m_solid, m_water)
%Assumptions: 
m_solid = m_solid*1000/3600; %turn mass inputs into kg/s
m_water = m_water*1000/3600;
density_steel = 8000; %kg/m3
factor_bearing_drag = 0.05;

%% P_solid: 
d_solid = 0.5*diameter; % solid discharge is set at half of the diameter 
n_bowl = n_bowl /60; %transform rpm in rps
w = 2*pi*n_bowl ;
u_solid = w* d_solid/2; % Circumferential speed at discharge point
p_solid = m_solid*u_solid^2; % mass flow * Circumferential speed^2

%% P_liquid: 
d_water = diameter; % solid discharge is set as the diameter 
u_water = w* d_water/2; % Circumferential speed at discharge point
p_water = m_water*u_water^2; % mass flow * Circumferential speed^2

%% P_empty_centrifuge
%Calculate shell mass:
shell_mass = pi*length*((diameter/2)^2-((diameter/2)-thickness)^2)*density_steel;
u_empty = w* diameter/2; % Circumferential speed at discharge point
p_empty = factor_bearing_drag*9.81*shell_mass*u_empty;

%% Sum up
power = p_solid + p_water + p_empty;% calculate in W
power = power /1000;% transform into kW

end

