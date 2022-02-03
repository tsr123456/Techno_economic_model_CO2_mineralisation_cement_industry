%------------------%% Electricity CO2 compression %%-----------------------%
% This function calculates the electricity needed for compression in
% [kwh/a]

%The inputs for this function is the following:
%compression_factors; taken from Hesams Regression function.
%p_reaction; pressure in [bar].
%m_CO2; mass stream of CO2 needed for compression in [t/a]

%% Calculation-------------------------------------------------------------
function w_compression = electricity_compression(p_reaction,m_CO2)

compression_factors =[17.5010, 12.8760];

%According to Aspen Simulation from Hesam: a*ln(p)+b  
w_compression = compression_factors(1,1)*log(p_reaction)+compression_factors(1,2); % deriving compression work in [kWh/tonneCo2] 

%Adapt to amount of CO2 that needs to be compressed:
w_compression = w_compression*m_CO2;

end