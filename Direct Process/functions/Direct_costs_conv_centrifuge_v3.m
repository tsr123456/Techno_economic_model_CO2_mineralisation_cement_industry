
%%%--------------------% Disc Centrifuge%------------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% x = diameter in m
% direct costs are calcualted in € (2020, location: Rotterdam.

%Limits: d = 0.25m -0.5m

function direct_costs = Direct_costs_conv_centrifuge_v3(x)


       a =   1.848e+05; 
       b =   4.784e+05; 
       
       direct_costs = a+b*x;

end

