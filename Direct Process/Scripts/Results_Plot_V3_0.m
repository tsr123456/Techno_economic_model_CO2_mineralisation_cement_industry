%%%-----------------------% Plot Results %-----------------------------%%%
% This script plots the results into different figures. It can be
% deactivated or activated in the main TEA model script.


%% Display results:
width_line = 6;
size_font = 12;

%% Costs and revenue
figure
nexttile
result_plot_cost = plot(Fu_cement_replacement,Result_C_total_fu);
title('Revenue and Costs')

hold on
result_plot_rev = plot(Fu_cement_replacement,Result_Rev_total_fu);
hold off

% create call out:
callout_i = 1;
max_call_out_x = Fu_cement_replacement(1);
max_call_out_y = Result_Rev_total_fu(1);
if round(Result_Rev_total_fu (length(Result_Rev_total_fu)-1),2) ~= round(Result_Rev_total_fu(length(Result_Rev_total_fu)),2)
while round(Result_Rev_total_fu (callout_i),2) == round(Result_Rev_total_fu(callout_i+1),2)
callout_i= callout_i +1;
max_call_out_x = Fu_cement_replacement(callout_i);
max_call_out_y = Result_Rev_total_fu(callout_i);
end
end

%figure_call_out = datatip(result_plot_rev,max_call_out_x,max_call_out_y ,'FontSize',size_font);% create data tip callouts
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
result_plot_profit = plot(Fu_cement_replacement,Result_Profit_total);
title('Profit')

% create call out:
[~,callout_i] = max(Result_Profit_total);

max_call_out_x = Fu_cement_replacement(callout_i);
max_call_out_y = Result_Profit_total(callout_i); 

%figure_call_out = datatip(result_plot_profit,max_call_out_x,max_call_out_y, 'FontSize',14);% create data tip callouts
result_plot_profit.DataTipTemplate.DataTipRows(1).Label = 'Max economic size in[t/a]:';
result_plot_profit.DataTipTemplate.DataTipRows(2).Label = 'Max economic profit in [€/a]:';
set(gca,'FontSize',16)

legend({'Profit'},'Location','southwest')
legend('boxoff')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',size_font)
ylabel('Profit [€/t_{cement replacment}]','FontSize',size_font)
set(gca,'FontSize',size_font)

% line width of plot:
set(result_plot_profit,'LineWidth',width_line)

%% CapEx composition
figure

nexttile
result_plot_CapEx = bar(Fu_cement_replacement, Result_CapEx,'stacked','FaceAlpha',0.5,'LineStyle','none');
figure_legends_capex = {'Crushing', 'Grinding', 'Heat-treatment', 'Reactor', 'Heat Exchangers & furnace','Compression','Capture','Post-treatment'};
legend(figure_legends_capex,'Location','northwest')
legend('boxoff')
title('CapEx')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',9)
ylabel('Capital Costs in [€/tonnes of cement replacement]','FontSize',9)

%% Total production costs
nexttile

for i_TEA_Model = 1:5
C_total_fu = C_total(:,i_TEA_Model)./Fu_cement_replacement;
end
pie (C_total./fu_cement_replacement);
labels = {'Utilities','Feedstock','Transport','Annual CapEx','Opex fixed'};
legend(labels,'Location','southoutside','Orientation','horizontal')
title (strcat('Levelised cost of product: ',num2str(Result_C_total_fu(numbr_of_model_runs)),'€/tonne'));

%% Energy demand 
figure
nexttile

pie (W_total/sum(W_total));
labels = {'Crushing','Grinding','Carb-stirring','Carb-pumping','Separation','Capture','Compression'};
legend(labels,'Location','southoutside','Orientation','horizontal')
title(strcat('Total electricity demand: ',num2str(sum(W_total)/Fu_cement_replacement(numbr_of_model_runs)*1000),'kWh/tonne'));

nexttile
pie (Ng_total/sum(Ng_total));
labels = {'Capture','Heating'};
legend(labels,'Location','southoutside','Orientation','horizontal')
title(strcat('Total natural gas demand: ',num2str(sum(Ng_total)/Fu_cement_replacement(numbr_of_model_runs)*1000),'kWh/tonne'));

nexttile
result_plot_CapEx = bar(Fu_cement_replacement, Result_share_replaced (:,1:2),'stacked','FaceAlpha',0.5,'LineStyle','none');
figure_legends_capex = {'SiO_2 in product', 'SiO_2 stored'};
legend(figure_legends_capex,'Location','northwest')
legend('boxoff')
title('SiO_2 usage')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',9)
ylabel('Share of SiO2 usage','FontSize',9)



nexttile
result_plot_CapEx = bar(Fu_cement_replacement, Result_share_replaced (:,3:4),'stacked','FaceAlpha',0.5,'LineStyle','none');
figure_legends_capex = {'inert in product', 'inert stored'};
legend(figure_legends_capex,'Location','northwest')
legend('boxoff')
title('inert usage')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',9)
ylabel('Share of inert usage','FontSize',9)

%% Equipment used

% Number of Equipment used:
figure
nexttile
plot(Fu_cement_replacement,NUMBR_Equipment)
figure_legends_equipment = {'Number of Reactors', 'Number of Heat Exchangers', 'Number of Cyclones (1/100)pcs', 'Number of classification centrifuges', 'Number of dewater centrifuge'};
legend(figure_legends_equipment,'Location','northwest')
title('Number of Equipment Units designed')


%{
figure
plot(Sensi_max_diameter,Result_C_total_fu)
plot(Sensi_max_diameter,Result_W_separation)
%}


%% find cement cost at maximum
index_max_cement_price = find (max_call_out_x == Fu_cement_replacement);
Delta_cement_price = Result_Profit_total(index_max_cement_price)/size_cement_plant % in €/tcement
Delta_cement_price_percent = (Delta_cement_price+pc_cement)/pc_cement-1


%{
%%%-----------------------% Plot Results %-----------------------------%%%
% This script plots the results into different figures. It can be
% deactivated or activated in the main TEA model script.


%% Display results:
width_line = 6;
size_font = 25;

%% Costs and revenue
figure
nexttile
result_plot_cost = plot(Fu_cement_replacement,Result_C_total_fu);
title('Revenue and Costs')

hold on
result_plot_rev = plot(Fu_cement_replacement,Result_Rev_total_fu);
hold off

% create call out:
callout_i = 1;
max_call_out_x = Fu_cement_replacement(1);
max_call_out_y = Result_Rev_total_fu(1);
if round(Result_Rev_total_fu (length(Result_Rev_total_fu)-1),2) ~= round(Result_Rev_total_fu(length(Result_Rev_total_fu)),2)
while round(Result_Rev_total_fu (callout_i),2) == round(Result_Rev_total_fu(callout_i+1),2)
callout_i= callout_i +1;
max_call_out_x = Fu_cement_replacement(callout_i);
max_call_out_y = Result_Rev_total_fu(callout_i);
end
end

%figure_call_out = datatip(result_plot_rev,max_call_out_x,max_call_out_y ,'FontSize',size_font);% create data tip callouts
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

% line width of plot:
set([result_plot_cost result_plot_rev],'LineWidth',width_line)

%% Profit
nexttile
result_plot_profit = plot(Fu_cement_replacement,Result_Profit_total);
title('Profit')

% create call out:
[~,callout_i] = max(Result_Profit_total);

max_call_out_x = Fu_cement_replacement(callout_i);
max_call_out_y = Result_Profit_total(callout_i); 

%figure_call_out = datatip(result_plot_profit,max_call_out_x,max_call_out_y, 'FontSize',14);% create data tip callouts
result_plot_profit.DataTipTemplate.DataTipRows(1).Label = 'Max economic size in[t/a]:';
result_plot_profit.DataTipTemplate.DataTipRows(2).Label = 'Max economic profit in [€/a]:';
set(gca,'FontSize',16)

legend({'Profit'},'Location','southwest')
legend('boxoff')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',size_font)
ylabel('Profit [€/t_{cement replacment}]','FontSize',size_font)
set(gca,'FontSize',size_font)

% line width of plot:
set(result_plot_profit,'LineWidth',width_line)

%% CapEx composition
figure

nexttile
result_plot_CapEx = bar(Fu_cement_replacement, Result_CapEx,'stacked','FaceAlpha',0.5,'LineStyle','none');
figure_legends_capex = {'Crushing', 'Grinding', 'Heat-treatment', 'Reactor', 'Heat Exchangers & furnace','Compression','Capture','Post-treatment'};
legend(figure_legends_capex,'Location','northwest')
legend('boxoff')
title('CapEx')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',9)
ylabel('Capital Costs in [€/tonnes of cement replacement]','FontSize',9)

%% Total production costs
nexttile

for i_TEA_Model = 1:5
C_total_fu = C_total(:,i_TEA_Model)./Fu_cement_replacement;
end
pie (C_total./fu_cement_replacement);
labels = {'Utilities','Feedstock','Transport','Annual CapEx','Opex fixed'};
legend(labels,'Location','southoutside','Orientation','horizontal')
title (strcat('Levelised cost of product: ',num2str(Result_C_total_fu(numbr_of_model_runs)),'€/tonne'));

%% Energy demand 
figure
nexttile

pie (Electricity_Demand/sum(Electricity_Demand));
labels = {'Crushing','Grinding','Carb-stirring','Carb-pumping','Separation','Capture','Compression'};
legend(labels,'Location','southoutside','Orientation','horizontal')
title(strcat('Total electricity demand: ',num2str(sum(Electricity_Demand)/Fu_cement_replacement(numbr_of_model_runs)*1000),'kWh/tonne'));

nexttile

pie (Ng_total/sum(Ng_total));
labels = {'Capture','Heating'};
legend(labels,'Location','southoutside','Orientation','horizontal')
title(strcat('Total natural gas demand: ',num2str(sum(Ng_total)/Fu_cement_replacement(numbr_of_model_runs)*1000),'kWh/tonne'));

nexttile
result_plot_CapEx = bar(Fu_cement_replacement, Result_share_replaced (:,1:2),'stacked','FaceAlpha',0.5,'LineStyle','none');
figure_legends_capex = {'SiO_2 in product', 'SiO_2 stored'};
legend(figure_legends_capex,'Location','northwest')
legend('boxoff')
title('SiO_2 usage')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',9)
ylabel('Share of SiO2 usage','FontSize',9)



nexttile
result_plot_CapEx = bar(Fu_cement_replacement, Result_share_replaced (:,3:4),'stacked','FaceAlpha',0.5,'LineStyle','none');
figure_legends_capex = {'inert in product', 'inert stored'};
legend(figure_legends_capex,'Location','northwest')
legend('boxoff')
title('inert usage')
xlabel('Plant capacity in [t_{cement replacment}/a]','FontSize',9)
ylabel('Share of inert usage','FontSize',9)

%% Equipment used

% Number of Equipment used:
figure
nexttile
plot(Fu_cement_replacement,NUMBR_Equipment)
figure_legends_equipment = {'Number of Reactors', 'Number of Heat Exchangers', 'Number of Cyclones (1/100)pcs', 'Number of dewater centrifuge (stage I)', 'Number of dewater centrifuge (stage II)'};
legend(figure_legends_equipment,'Location','northwest')
title('Number of Equipment Units designed')


%{
figure
plot(Sensi_max_diameter,Result_C_total_fu)
plot(Sensi_max_diameter,Result_W_separation)
%}


%% find cement cost at maximum
index_max_cement_price = find (max_call_out_x == Fu_cement_replacement);
Delta_cement_price = Result_Profit_total(index_max_cement_price)/size_cement_plant % in €/tcement
Delta_cement_price_percent = (Delta_cement_price+pc_cement)/pc_cement-1

%}
