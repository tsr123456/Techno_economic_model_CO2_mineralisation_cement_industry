%------------------------%% Shomate_equation %%---------------------------%
% This function calculates an enthalpy stream in the following form: 
% dH = dH_formation + Integral (cp) in [kj/mol]

%The inputs for this function is the following:
%Shomate_factors; Matrix of factors of the shomate equation for the different
%compounds, needed for the calculation. 
%Enthalpy_formation; Matrix of the enthalpy of formation for the different
%compunds, needed for the calculation.


%% Calculation-------------------------------------------------------------
function enthalpy_calculation_shomate = enthalpy_calculation_shomate(Shomate_factors,Enthalpy_formation,t)

  enthalpy_calculation_shomate = zeros(length(Shomate_factors),1);
  t = (t +273.15)/1000; %Input temperature in [K/1000]
  t_0 = (25 +273.15)/1000; %Standard temp in [K/1000]
   
  [rows, ~] = size(Shomate_factors);
  
    for q=1:rows
    % define the shomate parameters for the differnt compounds used in the
    % reaction, as well as enthalpy of formation
    a_sho = Shomate_factors(q,1);
    b_sho = Shomate_factors(q,2);
    c_sho = Shomate_factors(q,3);
    d_sho = Shomate_factors(q,4);
    e_sho = Shomate_factors(q,5);      

    enth_formation = Enthalpy_formation(q); %Enthalpy of formation in [kj/mol]

    % calculate specific enthalpy inflow in kj/mol:
    % calculate the integral for different temperature than in the table, if
    % the temp equals to the standard temp it has to be set to zero in [kJ/mol]
    if t == t_0
        int_cp_in = 0;
    else
    int_cp_in = a_sho*(t-t_0)+b_sho*(t^2-t_0^2)/2+c_sho*(t^3-t_0^3)/3+d_sho*(t^4-t_0^4)/4-e_sho*(((t)^-1)-((t_0)^-1));
    end

    if t < t_0
    int_cp_in = -int_cp_in;
    end

enthalpy_calculation_shomate(q,1)= enth_formation + int_cp_in;

end
