%%%--------------------% Numbr Cyclones%--------------------------%%
% This curve was derived using Aspen Plus. 
% x = efficiency of separation
% y = mass flow in t/a

%Limits: ??
function [numbr_cyclones, diameter] = Design_cyclones_v3(x,y)

% number of cyclones
a =       24.43 ;
b =       6.228 ;
m =      0.8045 ;
n =       21.49 ;

numbr_cyclones = a+b.*x.^n.*y.^m;

% diameter of cyclones
c =        1294 ;
d =       -1314 ;
o =     -0.3457 ;

diameter = c.*x.^o+d;
end    