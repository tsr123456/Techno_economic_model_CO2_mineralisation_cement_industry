%%%-------------------------% Compressor%------------------------------%%
% This cost curve was developed using the scaling approach and data from
% Van der Spek et al. 
% x = compression duty in kW
% direct costs are calcualted in € (2017).


function direct_costs = direct_costs_co2_compressor(x)

a = 41035000;
b = 21252;
n = 0.77; 
     
direct_costs = a.*((x/b).^n) ;

end