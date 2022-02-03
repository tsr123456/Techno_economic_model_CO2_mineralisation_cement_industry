%%-----------------% Direct Costs Heat exchanger%------------------------%%
% This cost curve was developed using U-TUbe Heat exchangers and the Aspen Capital Cost Estimator
% x = heat-transfer area in m3
% y = Pressure in bar
% direct costs are calcualted in € (2020).

%limits: x = 25-1200m2
%        y = 10-150bar

function direct_costs = Direct_costs_he_v3(x,y)
%% Setting the parameters
%%100-200m2
if (x<=200)
    if (y<=100)
    a =   1.257e+05;
    b =       4.525;
    c =     0.02784; 
    d =    1.000;  
    m =       3.284;  
    n =       1.705;  

    elseif (y>100)
    a =   2.474e+05;
    b =       14.09;
    c =       31.46;
    d =       4.678;
    m =      -19.47;
    n =      -5.865;
    end
end
       
%%225-500m2
if (200<x)&&(x<=550)
    if (y<=100)
    a =   1.441e+05 ;
    b =       44.82 ;
    c =       16.96 ;
    d =      1.000;
    m =       1.999;  
    n =       1.242; 
    elseif (y>100)
     a =   2.417e+05;     
    b =       999.2;       
    c =       5.187;
    d =       2.141;  
    m =     2.000 ;
    n =      0.8516;
    end   
end
       
%%550-900m2
if (550<x)&&(x<=900)
   if (y<=100)
    a =   1.915e+05;
    b =        14.7 ; 
    c =       23.76 ;
    d =       1.000;
    m =      2.000;
    n =       1.318;
    elseif (y>100)
    a =  -1.478e+05;
    b =        1081;
    c =   1.899e+05;  
    d =       2.302;
    m =      0.2334; 
    n =      0.7631;
    end 
    
end

%%900-1200m2      
if (900<x)&&(x<=1200)     
    if (y<=100)
    a =   9.173e+07; 
    b =  -9.052e+07; 
    c =  -2.057e+05; 
    d =       6.274;  
    m =      0.1789;  
    n =   0.0009788;
    elseif (y>100)
    a =   4.067e+05;
    b =       308.1;
    c =   3.595e+04;
    d =       2.465;
    m =      0.3395;
    n =      0.9353;
    end 
end


%% calculation of direct costs: 
 direct_costs = a+ b.*x.^n+c.*y.^m+d.*x.*y;
       
end