%% ----------------- Scenario comparison GHG intensity ------------------%%
clear all

%chose type of analyis: (only one can be 1)
carbon_intensity_plot =0;
capacity_plot = 1; 

%% Define GHG intensity
GHG_intensity_electricity = [0; 90; 220; 411; 520]; %check with Hesam
for i_NG = 1: length(GHG_intensity_electricity)
GHG_intensity_NG (i_NG,1) = 241;
if GHG_intensity_electricity (i_NG,1) < 1
    GHG_intensity_NG (i_NG,1) = GHG_intensity_electricity (i_NG,1);% if emissions of grid are smaller than NG, change to electric heating
end
end
number_of_model_runs = length (GHG_intensity_electricity);

if capacity_plot ==1
    Index = [1; 5]; % add index for the scenarios
    for i_cap = 1:2
        GHG_intensity_NG_cap(i_cap,1) =  GHG_intensity_NG (Index(i_cap),1);
        GHG_intensity_electricity_cap(i_cap,1) =  GHG_intensity_electricity(Index(i_cap),1);
    end
end


%% Import Scenarios

%Import sensitvity analysis restrictions
[SENSI_NUM,SENSI_TXT,~] = xlsread('Scenarios.xlsx','Matlab_input','B1:K10');
[SENSI_CAP,~,~] = xlsread('Scenarios.xlsx','Matlab_input','C12:E12');

numbr_scenarios = 3;
Silica_Content = SENSI_NUM(1,1:numbr_scenarios);
Inert_Content = SENSI_NUM(2,1:numbr_scenarios);
Price_ETS = SENSI_NUM(3,1:numbr_scenarios);
Price_Cement = SENSI_NUM(4,1:numbr_scenarios);
Capacity = SENSI_CAP;

%% run model: 
if carbon_intensity_plot == 1
for i_scenario= 1:numbr_scenarios
[LCOP_direct(:,i_scenario),Revenue_direct(:,i_scenario),Profit_direct(:,i_scenario),Carbon_footprint_reduction_direct(:,i_scenario), GHG_total_direct] = Economic_analysis_direct_mineralisation(number_of_model_runs,Capacity(i_scenario),Price_ETS(i_scenario),Price_Cement(i_scenario),Silica_Content(i_scenario),Inert_Content(i_scenario),[],GHG_intensity_electricity, GHG_intensity_NG);
[LCOP_indirect(:,i_scenario),Revenue_indirect(:,i_scenario),Profit_indirect(:,i_scenario),Carbon_footprint_reduction_indirect(:,i_scenario), GHG_total_indirect] = Economic_analysis_indirect_mineralisation(number_of_model_runs,Capacity(i_scenario),Price_ETS(i_scenario),Price_Cement(i_scenario),Silica_Content(i_scenario),Inert_Content(i_scenario),[],GHG_intensity_electricity, GHG_intensity_NG);
end
end

if capacity_plot ==1
    number_of_model_runs = 100; 
    Capacity = linspace(10000,500000,number_of_model_runs);
for i_scenario= 1:numbr_scenarios
        
[LCOP_direct_1(:,i_scenario),Revenue_direct_1(:,i_scenario),Profit_direct_1(:,i_scenario),Carbon_footprint_reduction_direct_1(:,i_scenario), GHG_total_direct_1] = Economic_analysis_direct_mineralisation(number_of_model_runs,Capacity,Price_ETS(i_scenario),Price_Cement(i_scenario),Silica_Content(i_scenario),Inert_Content(i_scenario),[],GHG_intensity_electricity(1), GHG_intensity_NG(1));
[LCOP_indirect_1(:,i_scenario),Revenue_indirect_1(:,i_scenario),Profit_indirect_1(:,i_scenario),Carbon_footprint_reduction_indirect_1(:,i_scenario), GHG_total_indirect_1] = Economic_analysis_indirect_mineralisation(number_of_model_runs,Capacity,Price_ETS(i_scenario),Price_Cement(i_scenario),Silica_Content(i_scenario),Inert_Content(i_scenario),[],GHG_intensity_electricity(1), GHG_intensity_NG(1));

[LCOP_direct_2(:,i_scenario),Revenue_direct_2(:,i_scenario),Profit_direct_2(:,i_scenario),Carbon_footprint_reduction_direct_2(:,i_scenario), GHG_total_direct_2] = Economic_analysis_direct_mineralisation(number_of_model_runs,Capacity,Price_ETS(i_scenario),Price_Cement(i_scenario),Silica_Content(i_scenario),Inert_Content(i_scenario),[],GHG_intensity_electricity (2), GHG_intensity_NG (2));
[LCOP_indirect_2(:,i_scenario),Revenue_indirect_2(:,i_scenario),Profit_indirect_2(:,i_scenario),Carbon_footprint_reduction_indirect_2(:,i_scenario), GHG_total_indirect_2] = Economic_analysis_indirect_mineralisation(number_of_model_runs,Capacity,Price_ETS(i_scenario),Price_Cement(i_scenario),Silica_Content(i_scenario),Inert_Content(i_scenario),[],GHG_intensity_electricity (2), GHG_intensity_NG (2));

[LCOP_direct_3(:,i_scenario),Revenue_direct_3(:,i_scenario),Profit_direct_3(:,i_scenario),Carbon_footprint_reduction_direct_3(:,i_scenario), GHG_total_direct_3] = Economic_analysis_direct_mineralisation(number_of_model_runs,Capacity,Price_ETS(i_scenario),Price_Cement(i_scenario),Silica_Content(i_scenario),Inert_Content(i_scenario),[],GHG_intensity_electricity(3), GHG_intensity_NG(3));
[LCOP_indirect_3(:,i_scenario),Revenue_indirect_3(:,i_scenario),Profit_indirect_3(:,i_scenario),Carbon_footprint_reduction_indirect_3(:,i_scenario), GHG_total_indirect_3] = Economic_analysis_indirect_mineralisation(number_of_model_runs,Capacity,Price_ETS(i_scenario),Price_Cement(i_scenario),Silica_Content(i_scenario),Inert_Content(i_scenario),[],GHG_intensity_electricity(3), GHG_intensity_NG(3));

end
    
end    

%% plot: 
%color scheme:
color2=[0.1986, 0.7214,0.6310];
color1=[0.9856,0.7372, 0.2537];
color_area_neg =[0.9856,0.7372, 0.2537]; %[0.886, 0.250, 0.313];
color_area_pos = [0.1986 0.7214 0.6310];
area_trans = 0.2;
size_font = 14;

if carbon_intensity_plot ==1

figure
clf
plot(GHG_intensity_electricity,Profit_direct,'r')
hold on
plot(GHG_intensity_electricity,Profit_indirect,'g')
hold off

plotstyle= {':';'-';'--'};
figure
for i_plot = 1:3
plot(GHG_intensity_electricity,Carbon_footprint_reduction_direct(:,i_plot),'LineStyle',plotstyle{i_plot},'color', color1,'LineWidth', 2)
hold on
plot(GHG_intensity_electricity,Carbon_footprint_reduction_indirect(:,i_plot),'LineStyle',plotstyle{i_plot},'color', color2,'LineWidth', 2)
end
xlabel('Carbon footprint reduction', 'FontSize',size_font)
ylabel('Carbon footprint reduction', 'FontSize',size_font)

legend('direct pess','indirect pess', 'direct mid','indirect mid', 'direct opt',   'indirect opt','Location','NorthOutside','Orientation','Horizontal', 'Fontsize',12, 'NumColumns', 3)
legend boxoff

box off 

hold off


figure
plot(GHG_intensity_electricity,LCOP_direct)
hold on
plot(GHG_intensity_electricity,Revenue_direct)

end
%% -------------------------------- Plot LCA data -----------------------%%
if capacity_plot ==1

%combine results: first three indirect, then direct:
   Result_carbon_footprint_reduction(:,:,1) = Carbon_footprint_reduction_direct_1;
   Result_carbon_footprint_reduction(:,:,2) = Carbon_footprint_reduction_direct_2;
   Result_carbon_footprint_reduction(:,:,3) = Carbon_footprint_reduction_direct_3;
   Result_carbon_footprint_reduction(:,:,4) = Carbon_footprint_reduction_indirect_1;
   Result_carbon_footprint_reduction(:,:,5) = Carbon_footprint_reduction_indirect_2;
   Result_carbon_footprint_reduction(:,:,6) = Carbon_footprint_reduction_indirect_3;

for ii_plot = 1:1
figure
%plotstyle={'-','-', '-','--','--','--',':', ':',':','-.','-.','-.','-','-', '-','--','--','--',':', ':',':','-.','-.','-.'}; % no marker
%plotstyle={'-s','-+', '-o','--s','--+','--o',':s', ':+',':o','-.s','-.+','-.o','-^','-d', '-h','--^','--d','--h',':^', ':d',':h','-.^','-.d','-.h'}; % no marker

clf;
graph_tiles = tiledlayout(2,3); 

%color scheme:
color2=[0.1986, 0.7214,0.6310];
color1=[0.9856,0.7372, 0.2537];
color_area_neg =[0.9856,0.7372, 0.2537]; %[0.886, 0.250, 0.313];
color_area_pos = [0.1986 0.7214 0.6310];
area_trans = 0.2;
size_font = 14;

%color:
green = ['#33B8A1'; '#138A93']; 
blues = ['#0098C8'; '#4967C0'];
yellow = ['#FBBC41'];
red = ['#FE8A7F'; '#C1554E'];
hex = [green; blues;yellow;red;yellow];

colors = sscanf(hex','#%2x%2x%2x',[3,size(hex,1)]).' / 255;% create color map
plotstyle_mark={'-s','-+', '-o','--s','--+','--o',':s', ':+',':o','-.s','-.+','-.o','-^','-d', '-h','--^','--d','--h',':^', ':d',':h','-.^','-.d','-.h'}; % no marker
plotstyle={'-','-', '-','--','--','--',':', ':',':','-.','-.','-.','-','-', '-','--','--','--',':', ':',':','-.','-.','-.'};


%%%------------------------------Direct Process-------------------------%%%
 for i_plot=1:3  % a loop, plot y1 against each column of X %plotstyle{i_plot+1}, 'LineWidth',3, 'MarkerSize',3
     %create Tile:      
     tile(i_plot)= nexttile;
        
    p_LCA(1,i_plot)= plot (tile(i_plot), Capacity , Result_carbon_footprint_reduction(:,i_plot,1).*100,':', 'color',color2, 'LineWidth',2);
    hold on 
    p_LCA(2,i_plot)= plot (tile(i_plot), Capacity , Result_carbon_footprint_reduction(:,i_plot,2).*100,'--', 'color',colors(3,:), 'LineWidth',2);
      %p_LCA(3,i_plot)= plot (tile(i_plot), Capacity , Result_carbon_footprint_reduction(:,i_plot,3).*100,':', 'color',color1, 'LineWidth',2);
    ytickformat('percentage'); 

    if i_plot == 2
    %%add label: 
        h = [p_LCA(1,2); p_LCA(2,2)];
        legend_overall = legend( h,'Electricity and heating decarbonised', 'Electricity and heating mix in Europe(2016)', 'Location','NorthOutside','Orientation','Horizontal', 'Fontsize',size_font-2, 'NumColumns', 3);
        legend boxoff  
    end
    
    title(append('Direct, ',SENSI_TXT(1,1+i_plot)))
         
    box off
 end
 %%%----------------------------Indirect Process------------------------%%%
 
   for i_plot=4:6  % 
      tile(i_plot)= nexttile;
      
          
     p_LCA_indirect(1,i_plot) = plot (tile(i_plot), Capacity , Result_carbon_footprint_reduction(:,i_plot-3,4).*100,':', 'color',color2, 'LineWidth',2);
        hold on
     p_LCA_indirect(2,i_plot) = plot (tile(i_plot), Capacity , Result_carbon_footprint_reduction(:,i_plot-3,5).*100,'--', 'color',colors(3,:), 'LineWidth',2);
     %p_LCA_indirect(3,i_plot) = plot (tile(i_plot), Capacity , Result_carbon_footprint_reduction(:,i_plot-3,6).*100,':', 'color',color1, 'LineWidth',2);
               
        title(append('Indirect, ',SENSI_TXT(1,1+i_plot-3)))
        ytickformat('percentage');
              
    box off
   end
 
% Add shared title and axis labels

xlabel(graph_tiles,'Capacity in [t_{SCM}/a]', 'FontSize',size_font)
ylabel(graph_tiles,'CO_{2e} emission reduction in %', 'FontSize',size_font)

% Move plots closer together
graph_tiles.TileSpacing = 'compact';
linkaxes([tile(1) tile(2) tile(3) tile(4) tile(5) tile(6)],'xy')
xlim([0 500000]);
ylim([0 50])


hold off;


end

end
