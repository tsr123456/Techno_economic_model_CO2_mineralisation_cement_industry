
%%%-----------------% Direct costs centr. pump%------------------------%%
% This cost curve was developed using centrifugal pumps and the Aspen Capital Cost Estimator
% x = the liquid flow rate in m3/h
% y = the pressure in bar (output, input is assumed to be 1 bar)
% direct costs are calcualted in € (2020).


%Limtis: x = 10-150L/s & y = 10-150bar

function direct_costs = Direct_costs_centr_pump_v3(x,y)

x = x./3.6; % transform in l/s


 a =  -5.534e+04;
 b =   3.169e+04; 
 c =       9.356;  
 d =       19.64;
 m =       2.306; 
 n =       0.409;

direct_costs = a+ b.*x.^n + c.*y.^m + d.*x.*y;

end



