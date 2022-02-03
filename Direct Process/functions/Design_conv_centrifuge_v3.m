%%%---------------------------%Disc centrifuge%-------------------------%%
% This curve was derived using Aspen Plus and is suitable for seperations
% with a liquid content of around 83%. The waste stream will have 10%
% moisture, the residual moisture will go with the product. The design will
% cut of  at 1 µm with a separation efficiency of >80% and a product purity
% of >99%

% x = Total input flow in t/h

% the diameter is calculated in m. 
function [numbr,diameter] = Design_conv_centrifuge_v3(x)

%Transform into kg/h:
x = x*1000;
a =     0.08861;
b =   3.868e-06;
       
%Calculate diameter:  
radius = a*exp(b*x);
diameter = radius*2;

max_diameter = 0.5;
numbr = 1;

if (diameter>max_diameter)
    while(diameter>max_diameter) %|| (length>max_length)
        numbr = numbr + 1;
        x = x/numbr;
        
        %calc diameter: 
       diameter = a.*exp(b.*x);       
    end

end

