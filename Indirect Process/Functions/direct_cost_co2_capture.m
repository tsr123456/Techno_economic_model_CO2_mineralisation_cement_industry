%%%-------------------------% MEA Caputure%------------------------------%%
% This cost curve was developed using the scaling approach and data from
%ChemCAP project
% x = captured CO2 in t/a
% direct costs are calcualted in € (2017).


function direct_costs = direct_cost_co2_capture(x)

a = 47600000;
b = 765000;
n = 0.6; 
     
direct_costs = a.*((x/b).^n) ;

end
