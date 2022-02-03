%% ------------------ CO2 transport costs -------------------------------%%
%this formular is derived via linear regression from Ref: Zero Emission Platform. The Costs of CO2 Transport - Post-demonstration CCS in the EU Retrieved from  https://www.globalccsinstitute.com/archive/hub/publications/119811/costs-co2-transport-post-demonstration-ccs-eu.pdf
% Input: distance for transport (km) & type: 'onshore' 'offshore' 'ship'
% Output: cost of transport in [€/tco2]

function [cost_CO2_transport] = cost_CO2_transport (distance, type)
if isequal(type,'onshore')
    cost_CO2_transport = 0.0066.*distance+1.3108;
elseif isequal(type,'offshore')
    cost_CO2_transport = 0.0099.*distance+1.2185;
elseif isequal(type,'ship')
    cost_CO2_transport = 0.0038.*distance+10.386;
else
    disp 'type of transport not found'
end

end

