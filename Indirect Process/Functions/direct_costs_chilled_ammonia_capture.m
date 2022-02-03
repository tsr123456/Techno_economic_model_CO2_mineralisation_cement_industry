%%-------------------------% Direct Costs Chilled Ammonia%-----------------%%
%This function is based on Technoeconomic Assessment of an Advanced Aqueous Ammonia- Based Postcombustion Capture Process Integrated with a 650-MW Coal-Fired Power Station			
%by Kangkang Li,*,†,‡ Hai Yu,*,† Shuiping Yan,§ Paul Feron,† Leigh Wardhaugh,† and Moses Tade‡
%the calculation were originally based on a Coal power plant which has a
%slightly lower CO2 content
% Basis for the capacity was 560tCO2/h

% Input: CO2 captured per year [t/h]

function [tdc_capture] = direct_costs_chilled_ammonia_capture(capacity_new)

capacity_old = 560;%t/h
scaling_factor = 0.6;
CEPCI_2013 = 576.1;
CEPCI_2019 =  607.5;
USD_exchange_rate = 0.88;


tdc_capture = 31081961*(capacity_new/capacity_old)^scaling_factor; % in USD 

tdc_capture = tdc_capture*(CEPCI_2019/CEPCI_2013)*0.88;
 
end
