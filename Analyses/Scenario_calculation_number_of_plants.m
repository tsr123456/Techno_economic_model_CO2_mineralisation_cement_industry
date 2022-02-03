%clearvars -except Result_total_cost_fu
clear all
tic

%% select path for data %%
warning('off')
%remove path if indirect process is selected: 
rmpath('Indirect Process')
rmpath(genpath('Indirect Process'))

%add folder to directory
folder = what('Direct Process');
addpath(genpath(folder.path)) 

warning('on')

%% Scenaruio Analysis

%Import sensitvity analysis restrictions
[SENSI_NUM,SENSI_TXT,~] = xlsread('Scenarios.xlsx','Matlab_input','B1:K10');

[SENSI_CAP,~,~] = xlsread('Scenarios.xlsx','Matlab_input','C12:E12');

%% import for script
%% Import all other factors from Excel sheet:
% All factors are imported using an excel sheet and 4 different matrices.
% The different matrixes are imported here, once. For multiple runs of the
% alter factors directly and do not reimport the factors each step (time
% issues).

numbr_of_model_runs = 20;
numbr_scenarios = 3;

numbr_plant_sensi = linspace(1,20,numbr_of_model_runs);

%% ------------------------------Direct Process------------------------- %%

global max_diameter 
max_diameter = 0.5;

I1_initial = zeros(130,3);
I2_initial = zeros(130,3);
I3_initial = zeros(130,10);
I4_initial = zeros(130*12);

I1_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','C3:E132','basic');
I2_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','H3:J132','basic');
I3_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','M3:V132','basic');
I4_initial = xlsread('Control_Sheet_V3_0_1.xlsx','Matlab_input','Y3:AJ132','basic');


%% set all resutls matrices

Result_C_total_fu_direct = zeros(numbr_of_model_runs,numbr_scenarios);
Result_Rev_total_fu_direct = zeros(numbr_of_model_runs,numbr_scenarios);
Result_Profit_total_direct = zeros(numbr_of_model_runs,numbr_scenarios);
GHG_reduction_direct = zeros(numbr_of_model_runs,numbr_scenarios);

for v = 1: numbr_scenarios % if only one variable should be changed, alter this in the excel script
    
% set import matrices into initial state: 
I1 = I1_initial;
I2 = I2_initial;
I3 = I3_initial;
I4 = I4_initial; 

    
%% Run Scenarios
[length_sensi, ~] = size(SENSI_NUM);

for w=1:length_sensi
    
 % replace sensitive variable from input matrix:
  if SENSI_NUM(w,4) == 1 % check for right input array to alter sensitive variables
    I1(SENSI_NUM(w,5),SENSI_NUM(w,6)) = SENSI_NUM(w,v);
 elseif SENSI_NUM(w,4) == 4 % check for right input array to alter sensitive variables
    I4(SENSI_NUM(w,5),SENSI_NUM(w,6)) = SENSI_NUM(w,v);
 else
     disp('No variable in Matrix found that can be altered. This calculation wont have any results. Change input input matrix in Excel sheet !!!!!!!!!')
 end
end

fu_cement_replacement = SENSI_CAP(v);

for i_TEA=1 : numbr_of_model_runs
    
%% adapat transport

I1(52,1) =  numbr_plant_sensi(i_TEA);

    
run Mass_Balance_V3_0.m
run Energy_Balance_V3_0.m
run CapEx_V3_0.m
run OpEx_V3_0.m
run Revenue_Model_V3_0.m

% Calculate total costs & relative costs to produced Carbonate
Result_C_total_fu_direct(i_TEA,v) = c_total/fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_Rev_total_fu_direct(i_TEA,v) = rev_total /fu_cement_replacement; % in [EUR/tonne cement replacement]
Result_Profit_total_direct(i_TEA,v) = rev_total - c_total; % in[EUR/a]
GHG_reduction_direct(i_TEA,v) = 1-(size_cement_plant*ghg_cement+ghg_total)/(size_cement_plant*ghg_cement); % in[EUR/a]
CO2_captured_direct(i_TEA,v) = m_CO2_in_carb/(size_cement_plant*ghg_cement/1000);
end
end

disp ('Calculations direct complete.')

%% -------------------Indirect Process--------------------------------- %%
clearvars -except Result_C_total_fu_direct Result_Rev_total_fu_direct Result_Profit_total_direct numbr_of_model_runs numbr_plant_sensi SENSI_NUM SENSI_TXT numbr_scenarios GHG_reduction_direct CO2_captured_direct numbr_plant_sensi SENSI_CAP numbr_plant_sensi
%Remove and Add paths

warning('off')
%remove path if indirect process is selected: 
rmpath('Direct Process')
rmpath(genpath('Direct Process'))

%add folder to directory
folder = what('Indirect Process');
addpath(genpath(folder.path)) 
warning('on')

%% Create results matrices

Result_total_cost_fu_indirect = zeros(numbr_of_model_runs,numbr_scenarios);
Result_total_rev_fu_indirect = zeros(numbr_of_model_runs,numbr_scenarios);
Result_total_profit_indirect = zeros(numbr_of_model_runs,numbr_scenarios);


%% Import variables
M1_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','C4:C51','basic');
M2_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','I4:K211','basic');
M3_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','O4:O16','basic');
M4_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','S4:X22','basic');
M5_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','AA4:AA100','basic');
M6_initial = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','AF5:AK6','basic');

[~,Mass_i_o_TXT,~] = xlsread('TEA_Control_Sheet_v2.xlsx','Matlab_Input_max','N19:N48','basic');


 
for v = 1: numbr_scenarios % if only one variable should be changed, alter this in the excel script
    
% set import matrices into initial state: 
M1 = M1_initial;
M2 = M2_initial;
M3 = M3_initial;
M4 = M4_initial; 
M5 = M5_initial;
M6 = M6_initial; 

    
%% Run Scenarios
[length_sensi, ~] = size(SENSI_NUM);

for w=1:length_sensi
    
 % replace sensitive variable from input matrix:
  if SENSI_NUM(w,7) == 5 % check for right input array to alter sensitive variables
    M5(SENSI_NUM(w,8),SENSI_NUM(w,9)) = SENSI_NUM(w,v);
 else
     disp('No variable in Matrix found that can be altered. This calculation wont have any results. Change input input matrix in Excel sheet !!!!!!!!!')
 end
end

fu_cement_replacement = SENSI_CAP(v);

[Result_total_cost_fu_indirect(:,v), Result_total_rev_fu_indirect(:,v), Result_total_profit_indirect(:,v), GHG_reduction_indirect(:,v), CO2_captured_indirect(:,v)] = TEA_indirect_standalone(M1,M2,M3,M4,M5,M6,Mass_i_o_TXT, numbr_of_model_runs,fu_cement_replacement,0,0,0,0,numbr_plant_sensi);


end
disp ('Calculations indirect complete.')

%% -------------------------------- Plot Results------------------------ %%

%%% Costs
figure
%plotstyle={'-','-', '-','--','--','--',':', ':',':','-.','-.','-.','-','-', '-','--','--','--',':', ':',':','-.','-.','-.'}; % no marker
%plotstyle={'-s','-+', '-o','--s','--+','--o',':s', ':+',':o','-.s','-.+','-.o','-^','-d', '-h','--^','--d','--h',':^', ':d',':h','-.^','-.d','-.h'}; % no marker

clf;
graph_tiles = tiledlayout(2,3); % Requires R2019b or later

color2=[0.1986, 0.7214,0.6310];
color1=[0.9856,0.7372, 0.2537];
color_area_neg =[0.9856,0.7372, 0.2537]; %[0.886, 0.250, 0.313];
color_area_pos = [0.1986 0.7214 0.6310];
area_trans = 0.2;
size_font = 14;



%%%------------------------------Direct Process-------------------------%%%

for i_plot=1:numbr_scenarios  % a loop, plot y1 against each column of X %plotstyle{i_plot+1}, 'LineWidth',3, 'MarkerSize',3
     %create Tile:      
     tile(i_plot)= nexttile;
    
    %Area plots:
    %creat negative lines:
    
    positive = zeros(numbr_of_model_runs,2);
    negative = zeros(numbr_of_model_runs,2);
    
    %{  
    for i_area = 1: length(numbr_plant_sensi)
        if Result_C_total_fu_direct(i_area,i_plot) > Result_Rev_total_fu_direct(i_area,i_plot)
            negative(i_area,1) = Result_C_total_fu_direct(i_area,i_plot);%upper line
            negative(i_area,2) = Result_Rev_total_fu_direct(i_area,i_plot);%lower line
        else
           positive(i_area,2) = Result_C_total_fu_direct(i_area,i_plot);%lower line
           positive(i_area,1) = Result_Rev_total_fu_direct(i_area,i_plot); %upper line
        end
    end
   
   
    % plot postive plot
    q=area(numbr_plant_sensi,positive(:,1),'FaceColor',color_area_pos);
    q.FaceAlpha = area_trans;
    q.EdgeColor = 'none';
    hold on
    q_2 = area(numbr_plant_sensi,positive(:,2),'FaceColor', [1 1 1]);
    q_2.EdgeColor = 'none';
    
    hold on
   
    
    
    %plot negative plot
    q=area(numbr_plant_sensi,negative(:,1),'FaceColor',color_area_neg);
    q.FaceAlpha = area_trans;
    q.EdgeColor = 'none';
    hold on
    q_2 = area(numbr_plant_sensi,negative(:,2),'FaceColor', [1 1 1]);
    q_2.EdgeColor = 'none';
    hold on
     %} 
    
    %Plot lines
    p_1(i_plot,1) = bar(tile(i_plot),numbr_plant_sensi,Result_C_total_fu_direct(:,i_plot), 'FaceColor',color1, 'EdgeColor','none');%'-', 'color',color1, 'LineWidth',2);
    p_1(i_plot,1).FaceAlpha = 0.6;  
    hold on
    p_1(i_plot,2) = plot(tile(i_plot),numbr_plant_sensi,Result_Rev_total_fu_direct(:,i_plot),'--', 'color',color2, 'LineWidth',2);
   
   uistack(p_1(i_plot,1),'top')
    uistack(p_1(i_plot,2),'top')
    ylim([50 300])
       xlim([1 20])
  
    
                 
    title(append('Direct, ',SENSI_TXT(1,1+i_plot)))
    
 

    % put lines on top & remove box
    
    box off
 end
 %}
 %%%----------------------------Indirect Process------------------------%%%
 
   for i_plot=1:numbr_scenarios  % a loop, plot y1 against each column of X %plotstyle{i_plot+1}, 'LineWidth',3, 'MarkerSize',3
      tile(i_plot+numbr_scenarios)= nexttile;
      
      %Area plots:
    %creat negative lines:
    
    positive = zeros(numbr_of_model_runs,2);
    negative = zeros(numbr_of_model_runs,2);
    
    %{  
    for i_area = 1: length(numbr_plant_sensi)
        if Result_total_cost_fu_indirect(i_area,i_plot) > Result_total_rev_fu_indirect(i_area,i_plot)
            negative(i_area,1) = Result_total_cost_fu_indirect(i_area,i_plot);%upper line
            negative(i_area,2) = Result_total_rev_fu_indirect(i_area,i_plot);%lower line
        else
           positive(i_area,2) = Result_total_cost_fu_indirect(i_area,i_plot);%lower line
           positive(i_area,1) = Result_total_rev_fu_indirect(i_area,i_plot); %upper line
        end
    end
   
   % plot postive plot
    q=area(numbr_plant_sensi,positive(:,1),'FaceColor',color_area_pos);
    q.FaceAlpha = area_trans;
    q.EdgeColor = 'none';
    hold on
    q_2 = area(numbr_plant_sensi,positive(:,2),'FaceColor', [1 1 1]);
    q_2.EdgeColor = 'none';
    hold on
    
    
    %plot negative plot
    q=area(numbr_plant_sensi,negative(:,1),'FaceColor',color_area_neg);
    q.FaceAlpha = area_trans;
    q.EdgeColor = 'none';
    hold on
    q_2 = area(numbr_plant_sensi,negative(:,2),'FaceColor', [1 1 1]);
    q_2.EdgeColor = 'none';
    hold on
      %}   
            b1 = bar(tile(i_plot+numbr_scenarios),numbr_plant_sensi,Result_total_cost_fu_indirect(:,i_plot), 'FaceColor',color1, 'EdgeColor','none'); %'-','color',color1, 'LineWidth',2);
    b1.FaceAlpha = 0.6;
     hold on
            plot( tile(i_plot+numbr_scenarios),numbr_plant_sensi,Result_total_rev_fu_indirect(:,i_plot), '--', 'color',color2, 'LineWidth',2);
   
     ylim([50 300])
    
     xlim([0 20])
    
    
            title(append('Indirect, ',SENSI_TXT(1,1+i_plot)))
   
    box off
   end
 

% Add shared title and axis labels
%title(graph_tiles,'Levelised cost of production in [€/t_{cement replacment}]','FontSize',24)
xlabel(graph_tiles,'Number of plants built', 'FontSize',size_font)
ylabel(graph_tiles,'Cost & revenue [€ t_{SCM}^{-1}]', 'FontSize',size_font)

legend_overall = legend([p_1(2,1) p_1(2,2)],'Levelised cost of production','Revenue','Location','NorthOutside','Orientation','Horizontal');
legend_overall.FontSize = size_font-2;
set(legend_overall,'Box','off')

%Texto=text(1.2, 1.5, 'Some Title String', 'Units', 'normalized', 'VerticalAlignment','Bottom', 'FontWeight','bold')
%set(Texto,'Rotation',90)
%lh.Layout.Tile = 'North'; % <----- relative to tiledlayout

% Move plots closer together
%xticklabels(ph_indirect_rec(1),{})
graph_tiles.TileSpacing = 'compact';


hold off;

toc

%% --------------------------------- Plot LCA 2 data -----------------------%%

figure
%plotstyle={'-','-', '-','--','--','--',':', ':',':','-.','-.','-.','-','-', '-','--','--','--',':', ':',':','-.','-.','-.'}; % no marker
%plotstyle={'-s','-+', '-o','--s','--+','--o',':s', ':+',':o','-.s','-.+','-.o','-^','-d', '-h','--^','--d','--h',':^', ':d',':h','-.^','-.d','-.h'}; % no marker

clf;
graph_tiles = tiledlayout(2,3); % Requires R2019b or later



%%%------------------------------Direct Process-------------------------%%%
 for i_plot=1:numbr_scenarios  % a loop, plot y1 against each column of X %plotstyle{i_plot+1}, 'LineWidth',3, 'MarkerSize',3
     %create Tile:      
     tile(i_plot)= nexttile;
        
  p_LCA_1(i_plot)= plot (tile(i_plot), numbr_plant_sensi, GHG_reduction_direct(:,i_plot).*100,':', 'color',color2, 'LineWidth',2);
    ytickformat('percentage'); 
    hold on 
    title(append('Direct, ',SENSI_TXT(1,1+i_plot)))
    
     
    box off
 end
 %%%----------------------------Indirect Process------------------------%%%
 
   for i_plot=1:numbr_scenarios  % a loop, plot y1 against each column of X %plotstyle{i_plot+1}, 'LineWidth',3, 'MarkerSize',3
      tile(i_plot+numbr_scenarios)= nexttile;
      
          
     p_LCA_2 = plot (tile(i_plot+numbr_scenarios), numbr_plant_sensi, GHG_reduction_indirect(:,i_plot).*100,':', 'color',color2, 'LineWidth',2);
        hold on
               
        title(append('Indirect, ',SENSI_TXT(1,1+i_plot)))
                 ytickformat('percentage');
              
    box off
   end
  

% Add shared title and axis labels

xlabel(graph_tiles,'Capacity in [t_{SCM} a^{-1}]', 'FontSize',size_font)
ylabel(graph_tiles,'Carbon footprint reduction in %', 'FontSize',size_font)

legend_overall = legend([p_LCA_1(2)],'GWP reduction to conventional cement','Location','NorthOutside','Orientation','Horizontal', 'Fontsize',size_font-4);
set(legend_overall,'Box','off')

%Texto=text(1.2, 1.5, 'Some Title String', 'Units', 'normalized', 'VerticalAlignment','Bottom', 'FontWeight','bold')
%set(Texto,'Rotation',90)
%lh.Layout.Tile = 'North'; % <----- relative to tiledlayout

% Move plots closer together
%xticklabels(ph_indirect_rec(1),{})
graph_tiles.TileSpacing = 'compact';
linkaxes([tile(1) tile(2) tile(3) tile(4) tile(5) tile(6)],'xy')
%xlim([0 1500]);
ylim([0 40])


hold off;


%% --------------------------------- Plot LCA data -----------------------%%


rmpath(genpath('C:\Users\TSR\Desktop\matlab_March_2020\updated Model\TEA_Model V3_0_01\Indirect Process'))