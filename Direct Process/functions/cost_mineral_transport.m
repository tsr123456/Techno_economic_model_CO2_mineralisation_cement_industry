%% ------------------ Mineral transport costs -------------------------------%%
%this formular is derived via linear regression from Ref: Zero Emission Platform. The Costs of CO2 Transport - Post-demonstration CCS in the EU Retrieved from  https://www.globalccsinstitute.com/archive/hub/publications/119811/costs-co2-transport-post-demonstration-ccs-eu.pdf
% Input: distance for transport (km) & Exlude types: 'truck' 'train'
% 'ship' and prices [truck, train, ship] in €/tkm
% Output: cost of transport in [€/tmineral]

function [cost_mineral_transport] = cost_mineral_transport (distance_mineral, excluding, prices)

price_truck = 0.04 ;%€/tkm defaults taken from Brown et al 
price_train = 0.032 ;%€/tkm
price_ship = 0.0032 ;%€/tkm

if exist('prices','var') %replace, if new prices are set
price_truck = prices(1) ;%€/tkm
price_train = prices(1);%€/tkm
price_ship = prices(1) ;%€/tkm
end

if exist('excluding','var') %replace, if prices if a transportation way is excluded
    if isequal(excluding,'truck')
        price_truck = price_train;
    elseif isequal(excluding,'train')
        price_train = price_ship;
    elseif  isequal(excluding,'ship')
        price_ship = price_train;
    elseif isequal(excluding,'train and ship') 
        price_ship = price_truck;
        price_train = price_truck;
    end
end

%calculate distance
if distance_mineral <= 60
    distance_truck = distance_mineral;
    distance_train = 0;
    distance_ship = 0;
elseif distance_mineral > 60 && distance_mineral <= 260
    distance_truck = 60;
    distance_train = distance_mineral- distance_truck;
    distance_ship = 0;
elseif distance_mineral >260
    distance_truck = 60;
    distance_train = 200;
    distance_ship = distance_mineral - distance_train - distance_truck;
end

%calculate costs

cost_mineral_transport = distance_ship*price_ship + distance_train*price_train + distance_truck*price_truck; 

end