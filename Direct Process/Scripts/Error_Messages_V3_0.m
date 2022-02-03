--------------------------%% Error messages V2 %%--------------------------

% Use this script, if needed. Deactivate for Sensitivity runs. 

%% CapEx Crusher-----------------------------------------------------------
% check if demand is within limits
if (x_crusher>I3(1,7) && x_crusher<I3(1,8))
    else
   disp(strcat('Caution: Demand for cone crusher not within boundaries, for x=', num2str(fu_cement_replacement),' and a demand of ', num2str(x_crusher),'[t/h].'))
end

%% CapEx Ballmill-----------------------------------------------------------
% check if demand is within limits
if (x_grind>I3(3,7) && x_grind<I3(3,8))
    else
    disp(strcat('Caution: Demand for ball mill not within boundaries, for x=', num2str(fu_cement_replacement),' and a demand of ', num2str(x_grind),'[t/d].'))
end

%% CapEx Heat treatment----------------------------------------------------
% check if demand is within limits
if (duty_he_3>I3(17,7) && duty_he_3<I3(17,8))
    else
    disp(strcat('Caution: Demand for furnace not within boundaries, for x=', num2str(fu_cement_replacement),' and a duty of ', num2str(duty_he_3),'[MW].'))
end

%% CapEx reactor-----------------------------------------------------------
% check if demand is within limits
if (sm_reactor>I3(9,7) && sm_reactor<I3(9,8))
    else
   disp(strcat('Caution: Size of reactor not within boundaries, for x=', num2str(fu_cement_replacement),' and a shell mass of ', num2str(sm_reactor),'[kg].'))
end

%% CapEx Heat Exchangers--------------------------------------------------- 
% check if demand is within limits
if (abs(area_he_1_maxium_size)>I3(16,7) && abs(area_he_1_maxium_size)<I3(16,8))
    else
    disp(strcat('Caution: Size of heat exchanger for x=', num2str(fu_cement_replacement),' and an area of', num2str(area_he_1_maxium_size),'[m2].'))
end

% check if demand is within limits
if (duty_he_2>I3(17,7) && duty_he_2<I3(17,8))
    else
    disp(strcat('Caution: Demand for he2 not within boundaries, for x=', num2str(fu_cement_replacement),' and a duty of ', num2str(duty_he_2),'[MW].'))
end
%% OpEx Working hours------------------------------------------------------
%Check if Working hour estimate is within boundaries

if ((I3(a+14,1)*(b)^I3(a+14,2))>I3(14+a,7) && (I3(a+14,1)*(b)^I3(a+14,2))<I3(14+a,8))
else
    workinghours = (I3(a+14,1)*(b)^I3(a+14,2));   % working hours in manhours/d
    disp(strcat('Caution: Working hours not within boundaries, for x=', num2str(fu_cement_replacement),' and a demand of ', num2str(workinghours),'[manhours/d].'))
end



