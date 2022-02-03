%--------------Enthalpy Calculation--------------------------%

% Enthalpy of reaction, dH = Heat_of_formation(dF) + Integral(I_Cp)dT
% Specific heat capacity, Cp = a+bT+cT^2+dT^3
% Integral(Cp)dT = a(T-Tref)+b/2((T^2)-(Tref^2))+c/3*((T^3)-(Tref^3))+d/4*((T^4)-(Tref^4))

%% Function to calc enthalpy, dH [kJ/mol]

function enthalpy_dH = enthalpy_dH(Cp_factor,En_formation,t)

t = (t+273.15)/1000;%[K]
t_ref = (25+273.15)/1000;%[K]

for q=1:length(Cp_factor)
    
    a_value = Cp_factor(q,1);
    b_value = Cp_factor(q,1);   
    c_value = Cp_factor(q,1);
    d_value = Cp_factor(q,1);
    
    dF = En_formation(q); %Enthalpy of formation in [kj/mol]
    
    if t == t_ref
        I_Cp = 0;
    else
    I_Cp = a_value*(t-t_ref)+b_value*(t^2-t_ref^2)/2+c_value*(t^3-t_ref^3)/3+d_value*(t^4-t_ref^4)/4;
    end

    if t < t_ref
    I_Cp = -I_Cp;
    end

enthalpy_dH(q,1) = dF + I_Cp;


end

