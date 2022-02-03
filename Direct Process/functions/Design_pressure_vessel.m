%--------------%% Equipment Costs Pressure Vessel %%----------------------%
% The inputs for this function is the following: 

%tw_vessel_max; the maxium wall thickness assumed that could be used for
%the reactor/ the vessel.
%maximum_vessel_size; the maxium possible size of reactor / vessel that
%could be build.
%v_vessel; the volume of the vessel. 
%p_vessel; pressure of the vessel need to withstand. 
%sf_vessel; security factor for being added to the pressure. 
%mat_vessel; material of the vessel (Choose (0 for CS and 1 for SS)
%je_vessel; joint efficiency for welded joints of the vessel.
%d_vessel; density of vessel material
%t_vessel; temperature of filling of the vessel in [°C]
%I3; to check with AMSE table and minimal structural requirements, these
%tables need to be read. They are provided in Input Matrix 3/ I3 . They can
%be replaced by other inputs, if necessary. 


%% Calculations------------------------------------------------------------
function [numbr_reactor, size_reactor,count_reactor, tw_reactor] = Design_pressure_vessel(tw_vessel_max,maximum_vessel_size,v_vessel,p_vessel,sf_vessel,mat_vessel,je_vessel,d_vessel,t_vessel,I3)

tw_reactor = tw_vessel_max+1;
count_reactor = 0;


%calculate numbr of reactors and size them according to boundary conditions
while tw_reactor > tw_vessel_max
    
numbr_reactors_max_size = ceil(v_vessel/maximum_vessel_size)+count_reactor; %devide needed reactor volumne by maximum reactor size and round to nex highest number;
v_reactor_max_size = v_vessel/numbr_reactors_max_size;
    

%calculate diameter in [m]
r_reactor = (v_reactor_max_size /(2*pi))^(1/3); %height and diameter are set to the minimum surface area ratio h=2r, with Vmin= 2*\pi*r?   
di_reactor = 2*r_reactor;
h_reactor = 2*r_reactor;

%calculate wall thickness:

% transform pressure into pascal:
p_reactor = p_vessel*10^5; %pressure of reaction (importet in bar and adjusted to Pa)

    % find value from ASME table minimum stress table:
    [~, closestIndex] = min(abs(I3(4,:)-t_vessel));
    ms_reactor =  I3(5+mat_vessel,closestIndex)*10^6;

tw_reactor = (p_reactor*(1+sf_vessel)*di_reactor)/(2*ms_reactor*je_vessel-1.2*p_reactor*(1+sf_vessel)); % calculate wall thickness in [mm]

% compare wall thickness to minimum structural requirements

[~, closestIndex] = min(abs(I3(7,:)-di_reactor)); % find closest index to chosen diameter of reactor
tw_reactor = max ((I3(8,closestIndex)/1000),tw_reactor); % compare calculated pressure dependent min wall thickness to constructing dependend min wall thickness

% calculate shell mass for reactor

%sm_reactor = pi*di_reactor*h_reactor*tw_reactor*d_vessel; %Sm; Shell mass of the reactor in [kg]

%if wall thickness is too large, increase reactor count until it fits.
if tw_reactor > tw_vessel_max
count_reactor = count_reactor + 1;
end
end
%Export the results: 
numbr_reactor = numbr_reactors_max_size;
size_reactor = v_vessel/numbr_reactors_max_size;
end