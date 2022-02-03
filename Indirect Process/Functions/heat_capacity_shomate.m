%------------------------%% Cp_Shomate_equation %%------------------------%
% This function calculates the heatcapacity using the shomate equation the
% results are calculated in [kj/mol]

%The inputs for this function is the following:
%Shomate_factors; Matrix of factors of the shomate equation for the different
%compounds, needed for the calculation. 
%Enthalpy_formation; Matrix of the enthalpy of formation for the different
%compunds, needed for the calculation.

%% Calculation-------------------------------------------------------------


function heat_capacity_shomate = heat_capacity_shomate (Shomate_factors,t)

heat_capacity_shomate = zeros(length(Shomate_factors),1);

t = (t+273.15)/1000;%Input temperature in [K/1000]

    for q=1:length(Shomate_factors)
    % define the shomate parameters for the differnt compounds used in the
    % reaction
    a_sho = Shomate_factors(q,1);
    b_sho = Shomate_factors(q,2);
    c_sho = Shomate_factors(q,3);
    d_sho = Shomate_factors(q,4);
    e_sho = Shomate_factors(q,5);      


    %calcuclate average cp value over temperature, hich will be used to derive
    %output temperature for cold stream of heat exchanger

        
    heat_capacity_shomate(q,1) = a_sho + b_sho*(t) + c_sho*(t).^2 + d_sho*(t).^3 + e_sho./((t).^2); % in kJ/kmol*K
    
     end


end