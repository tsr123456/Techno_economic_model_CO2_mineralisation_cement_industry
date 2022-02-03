
%%%--------------------% Reactor%------------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% x = pressure in bar
% y = liquid volumne in m3
% direct costs are calcualted in € (2020), Rotterdam.

%Limitations: V = 50-200m3 P = 20-140bar

function direct_costs = Direct_costs_reactor_v3(x,y)

a =   3.153e+05;
b =      0.2124; 
c =       437.7; 
d =       90.18; 
m =       1.347;  
n =       2.698;  


direct_costs = a+ b.*x.^n + c.*y.^m + d.*x.*y;

end




