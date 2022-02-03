%%%-------------------------% Compressor%------------------------------%%
% This cost curve was developed using the scaling approach and data from
% Van der Spek et al. 
% x = compression duty in kW
% direct costs are calcualted in € (2014).


function direct_costs = Direct_costs_co2_compressor_v3(x)

a = 41035000;
b = 21252;
n = 0.77; 
     
direct_costs = a.*((x/b).^n) ;

end