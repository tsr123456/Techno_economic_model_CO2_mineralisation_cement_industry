
%%%%------------------------------------Direct Costs Evaporator---------------------------------%%%%%

%% This calculates the total direct costs in EUR for the basis 2020 and Rotterdam. 

%% Input values: 

% x = heat exchange area in m2

% x limits : 10-900m2



function TDC_evaporator = direct_cost_evaporator (x)
   
a = 42336;

b = 0;

n = 0.4895;


TDC_evaporator = a.*x.^n+b; 