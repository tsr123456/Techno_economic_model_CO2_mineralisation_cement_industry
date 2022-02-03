%------------------%% Electricity CO2 compression %%-----------------------%
%This function calculates the electricity needed for compression in
% output w in [kwh/a], t in [°C]

%The inputs for this function is the following:
%compression_factors; taken from Aspen regression function.
%p_out; pressure in [bar].
%m_H2O; mass stream of CO2 needed for compression in [t/a]


%% Calculation-------------------------------------------------------------
function [w_compression,t_out_compression] = electricity_compression_steam(p_out,m_h2O)

w_compression = (52.897.*p_out - 52.668)*m_h2O;

t_out_compression = (89.293*p_out + 11.149);

end

