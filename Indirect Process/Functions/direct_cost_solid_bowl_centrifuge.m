%%%--------------------% Solid Bowl centrifuge%--------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% x = Length in m
% y = Diameter in m
% direct costs are calcualted in € (2020), Location: Rotterdam.


%Limits: d = 0.450-1.250m L= 0.750-3.000m
function direct_costs = direct_cost_solid_bowl_centrifuge(x,y)

%transofrm m in mm: 
x = x*1000;
y=y*1000;

a =   4.192e+04; 
b =      0.1509; 
c =       13.29;
m =       1.384;  

direct_costs = a+ b.*x.*y + c.*y.^m;

end
