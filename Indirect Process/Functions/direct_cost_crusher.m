%%%--------------------% Cone Crusher%------------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% x = capacity in t/h 
% direct costs are calcualted in € (2020), location: Rotterdam.


% This only works within the limits of x = 75-300 [t/h]

function direct_cost_crusher = direct_cost_crusher(x)

a =        5040;  
b =   3.818e+04; 
n =      0.7435; 

direct_cost_crusher = a.*x.^n+b;

end

