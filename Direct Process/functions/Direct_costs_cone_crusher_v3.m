
%%%--------------------% Cone Crusher%------------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% x = capacity in t/h 
% direct costs are calcualted in € (2020), location: Rotterdam.


%limits: x = 75-300t/h
function direct_costs = Direct_costs_cone_crusher_v3(x)

a =        5040;  
b =   3.818e+04; 
n =      0.7435; 

direct_costs = a.*x.^n+b;

end

