
%%%--------------------% Hydrocyclones%------------------------------%%
% This cost curve was developed using Aspen Capital Cost Estimator
% y = diameter in mm
% x = number of cyclones
% direct costs are calcualted in € (2020), Location: Rotterdam

%Limits: y = 100-500mm, x = 10-100pcs

function direct_costs = Direct_costs_hydro_cyclone_v3(x,y)

%% Setting parameters:
% 0-290mm:
if (0<=y)&&(y<=290)
%disp '200'
a =     -0.4077;
b =       27.36; 
c =   0.0003486; 
m =       1.616;  
n =     -0.3809;  

     
end

%300-375mm:
if (290<y)&&(y<=370) 
      
a =       6.825;
b =        2750;
       c =   0.0001594;
       m =       1.741;
       n =      -2.594;


   
end

% 375-500mm:
if(370<y)&&(y<=500)
    %disp '500'
a =      -47.25;  
b =       77.37;
c =    0.001123; 
m =       1.443;  
n =    -0.06914;

end

%% Calculation:

direct_costs = a+b.*x.^n+c.*y.^m; % calculated in [1/1000*€/pcs]
direct_costs = direct_costs.*1000; %transform into €/pcs


end




