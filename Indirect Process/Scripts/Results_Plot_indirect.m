%%%-----------------------% Plot Results %-----------------------------%%%
% This script plots the results into different figures. It can be
% deactivated or activated in the main TEA model script.


%% Display results:
width_line = 6;
size_font = 15;
%% Tabulate results- cost & rev

figure
nexttile
result_plot_cost = plot(Fu_cement_replacement,Result_total_cost_fu);
title('Revenue and Costs')

hold on
result_plot_rev = plot(Fu_cement_replacement,Result_total_rev_fu);
hold off

% create call out:
callout_i = 1;
max_call_out_x = Fu_cement_replacement(1);
max_call_out_y = Result_total_rev_fu(1);
if round(Result_total_rev_fu (length(Result_total_rev_fu)-1),2) ~= round(Result_total_rev_fu(length(Result_total_rev_fu)),2)
while round(Result_total_rev_fu (callout_i),2) == round(Result_total_rev_fu(callout_i+1),2)
callout_i= callout_i +1;
max_call_out_x = Fu_cement_replacement(callout_i);
max_call_out_y = Result_total_rev_fu(callout_i);
end
end

figure_call_out = datatip(result_plot_rev,max_call_out_x,max_call_out_y);% create data tip callouts
result_plot_rev.DataTipTemplate.DataTipRows(1).Label = 'Max economic size in[t/a]:';
result_plot_rev.DataTipTemplate.DataTipRows(2).Label = 'Max economic revenue in [€/t]:'; 

% create label: 
legend({'Total Costs of production', 'Revenue'},'Location','southwest')
legend('boxoff')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',size_font)
ylabel('Costs / Revenue in [€/t_{cement replacment}]','FontSize',size_font)
xticks([100000 300000 500000])
yticks([100 200 300])
set(gca,'FontSize',size_font)
ylim([80 240])

% line width of plot:
set([result_plot_cost result_plot_rev],'LineWidth',width_line)


%% Profit
nexttile
result_plot_profit = plot(Fu_cement_replacement,Result_total_profit);
title('Profit')

legend({'Profit'},'Location','southwest')
legend('boxoff')
xlabel('Plant capacity in [tonnes of product /a]','FontSize',size_font)
ylabel('Profit [€/tonnes of cement replacement]','FontSize',size_font)
set(gca,'FontSize',size_font)

% line width of plot:
set(result_plot_profit,'LineWidth',width_line)
% create label: 
legend({'Total Profit'},'Location','southwest')
legend('boxoff')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',size_font)
ylabel('Profit in [€/a]','FontSize',size_font)
xticks([100000 300000 500000])
yticks([100 200 300])
set(gca,'FontSize',size_font)



%% CapEx composition
figure

nexttile
result_plot_CapEx = bar(Fu_cement_replacement, Result_Capex,'stacked','FaceAlpha',0.5,'LineStyle','none');
legend(Equipment_CapEx,'Location','northwest')
legend('boxoff')
title('CapEx')
xlabel('Plant capacity in [tonnes of produce/a]','FontSize',size_font)
ylabel('Capital Costs in [€/tonnes product]','FontSize',size_font)
             
%% Total production costs
figure
nexttile

TP = pie (results_opex_table);

labels = {'Energy';'Chemicals';'Mineral';'Transport';'Annualized CapEx'; 'Maintenance'; 'Labour'; 'Insurance & tax'};
legend(labels,'Location','southoutside','Orientation','horizontal')
title (strcat('Total cost of production: ',num2str( Result_total_cost_fu(numbr_of_model_runs)),'€/tonne'));
set(gca,'FontSize',size_font)

%% Material flows:
figure
nexttile
Electricity_Demand = Electricity_Demand*fu_cement_replacement/m_CO2_stored

pie (Electricity_Demand/sum(Electricity_Demand));
legend(Equipment_label,'Location','southoutside','Orientation','horizontal')
title(strcat('Total electricity demand: ',num2str(sum(Electricity_Demand)/Fu_cement_replacement(numbr_of_model_runs)*1000),'kWh/tonne CO2'));
set(gca,'FontSize',size_font)

figure
nexttile
Ng_total = [q_fu_1;q_fu_2;q_fu_3;q_fu_4;q_fu_5];% in KW
Ng_total = Ng_total*opt_hrs/1000; % in MWh
Ng_total = Ng_total*fu_cement_replacement/m_CO2_stored;

pie (Ng_total/sum(Ng_total));
labels = {'Furnace 1','Furnace 2','Furnace 3','Furnace 4','Furnace 5'};
legend(labels,'Location','southoutside','Orientation','horizontal')
title(strcat('Total natural gas demand: ',num2str(sum(Ng_total)/Fu_cement_replacement(numbr_of_model_runs)*1000),'kWh/tonne CO2'));
set(gca,'FontSize',size_font)

figure
nexttile
result_plot_CapEx = bar(Fu_cement_replacement, Result_share_replaced (:,1:2),'stacked','FaceAlpha',0.5,'LineStyle','none');
figure_legends_capex = {'SiO_2 in product', 'SiO_2 stored'};
legend(figure_legends_capex,'Location','northwest')
legend('boxoff')
title('SiO_2 usage')
xlabel('Plant capacity in [tonnes of cement replacement /a]','FontSize',size_font)
ylabel('Share of SiO2 usage','FontSize',size_font)
set(gca,'FontSize',size_font)

nexttile
result_plot_CapEx = bar(Fu_cement_replacement, Result_share_replaced (:,3:4),'stacked','FaceAlpha',0.5,'LineStyle','none');
figure_legends_capex = {'inert in product', 'inert stored'};
legend(figure_legends_capex,'Location','northwest')
legend('boxoff')
title('inert usage')
xlabel('Plant capacity in [tonnes of cement replacement /a]','FontSize',size_font)
ylabel('Share of inert usage','FontSize',size_font)
set(gca,'FontSize',size_font)

%% Equipment used

% Number of Equipment used:
figure
nexttile
plot(Fu_cement_replacement,Result_Numbr_eq)
figure_legends_equipment = Equipment_CapEx;
legend(figure_legends_equipment,'Location','northwest')
title('Number of Equipment Units designed')
set(gca,'FontSize',size_font)
