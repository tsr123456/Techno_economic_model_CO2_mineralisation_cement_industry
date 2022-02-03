%%%-------------------------% MEA Caputure%------------------------------%%
% This cost curve was developed using the scaling approach and data from
% Van der Spek et al. ChemCAP project
% x = compressed CO2 in t/a
% direct costs are calcualted in € (2017).


function direct_costs = Direct_costs_capture_v3(x)

a = 47600000;
b = 765000;
n = 0.6; 
     
direct_costs = a.*((x/b).^n) ;

end

