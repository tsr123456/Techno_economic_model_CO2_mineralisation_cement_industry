 %%%--------------------% Crystalizer%------------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% direct costs are calcualted in € (2020), for a mech crystalizer and SS as
% material
% Input: Length in [m]


% Only applicable within these limits, length = 6-300m

function [numbr_cry, direct_cost_cry] = direct_cost_crystalizer(length)

max_length = 300;
numbr_cry = 1;

if (length>max_length)
    
    while(length>max_length) %|| (length>max_length)
        numbr_cry = numbr_cry + 1;
        length = length/numbr_cry;
    end
   
end

%Coefficients (with 95% confidence bounds):
       a =        2238  ;
       b =        9615  ;
       n =      0.8106  ;

direct_cost_cry = a+ b.*length.^n;

end