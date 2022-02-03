%-----------------------Heat Capacity, Cp--------------------------------%

% Cp = a+bT^2+cT^3+d^4 [kJ/kgK]

function heat_capacity_factor = heat_capacity_factor (Cp_factor,t)

heat_capacity_factor = zeros(length(Cp_factor),1);

t= (t+273.15)/1000; %[K]

for q=1:length(Cp_factor)
    
% The function involves 2 parameters, Cp_factor and t which are defined
% as follow. 
% The function is able to loop through each row (q), meaning for all
% components to find it's Cp.  
  
    a_value = Cp_factor(q,1);
    b_value = Cp_factor(q,2);
    c_value = Cp_factor(q,3);
    d_value = Cp_factor(q,4);
     
     
    heat_capacity_factor(q,1) = a_value + b_value*(t) + c_value*(t).^2 + d_value*(t).^3;% [kJ/kmolK]

end



end

