%%------------------% Design Dewater I %-------------------------------%%
% This cost curve was developed using Aspen Simulation. The moisture
% content of the poduct stream was set to 10 wt%. 
% m_water_removed = water that is seperated from product in t/h.

%Outputs: diameter & length are given in m.

%limits: 0.7-170t/h
%particle size: 1-35µm

function [diameter,length,numbr] = Design_dewater_I(m_water_removed,rpm)

max_diameter = 0.5;

%1.250
max_length = 3.000;%max in m

m_water_removed = m_water_removed*1000; %transform t/h into kg/h

%calculate diameter: 
a_d =      0.1397;
d_d =       8.879;
m_d =      0.3862;
o_d =      -0.779;


diameter = a_d+d_d*rpm^o_d*m_water_removed^m_d;

%calculate Length: 

a_l =      0.7415;
b_l =     0.02666;
c_l =      0.9127;
d_l =  -3.572e-06;
m_l =     -0.3181;
n_l =      0.9479;
o_l =      -3.328;

L_D = a_l+c_l*rpm^o_l+d_l*m_water_removed+b_l*rpm^n_l*m_water_removed^m_l;% relation of L/D

length = L_D*diameter;

numbr = 1; % number of machines needed

if (diameter>max_diameter)
    while(diameter>max_diameter)
       
        numbr = numbr+1;
        m_water_removed = m_water_removed / numbr;
       
        %calculate diameter: 
      
        diameter = a_d+d_d*rpm^o_d*m_water_removed^m_d;

        %calc length
        
        L_D = a_l+c_l*rpm^o_l+d_l*m_water_removed+b_l*rpm^n_l*m_water_removed^m_l;% relation of L/D

        length = L_D*diameter;
        
    end
    
end

end
