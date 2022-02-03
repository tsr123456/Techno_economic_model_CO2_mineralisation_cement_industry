%%------------------% Design Dewater II %-------------------------------%%
% This cost curve was developed using Aspen Simulation. The moisture
% content of the poduct stream was set to 10 wt%. 
% m_water_removed = water that is seperated from product in t/h.

%Outputs: diameter & length are given in m.

%limits: 2.6-80t/h

function [diameter,length,numbr] = Design_dewater_II(m_water_removed,rpm)

max_diameter = 0.5;%max in m
max_length = 3.000;%max in m

m_water_removed = m_water_removed*1000; %transform t/h into kg/h

%calculate diameter: 
    a_d =     0.08205;
    d_d =       7.329;
    m_d =      0.3491;
    o_d =      -0.694 ;

diameter = a_d+d_d*rpm^o_d*m_water_removed^m_d;

%calculate Length: 

  a_l =      0.2382;
   b_l =     -0.6224;
   c_l =      0.6522;
   d_l =           0;
   m_l =     0.01173;
   n_l =      0.4288;
   o_l =      0.4406;

 
  L_D = a_l+c_l*rpm^o_l+d_l*m_water_removed+b_l*rpm^n_l*m_water_removed^m_l;% relation of L/D

length = L_D*diameter;

numbr = 1;


if (diameter>max_diameter)
    while(diameter>max_diameter) %|| (length>max_length)
        numbr = numbr + 1;
        m_water_removed = m_water_removed/numbr;
        
        %calc diameter: 
       diameter = a_d+d_d*rpm^o_d*m_water_removed^m_d;
        
        %calc length
        L_D = a_l+c_l*rpm^o_l+d_l*m_water_removed+b_l*rpm^n_l*m_water_removed^m_l;% relation of L/D
        length = L_D*diameter;
    end
   
end


end
