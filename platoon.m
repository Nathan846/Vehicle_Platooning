close all;
clear all;
clc;

vehicles = 4;
x_initial = [150 100 50 0];
v_initial_params = {[20 24 28 27];
             [28 32 32 28];
             [24,26,28,30]}

v_tar = 30;
t_h_tar = 1;
d_0 = 8;
Kv = 0.5;
Kd_err = 0.3010;
Kv_r = 0.9100;

Kd_err_pl = 0.401;
Kv_r_pl = 0.56;
Ka = 0.55;
% , 'Kd_err', 0.301, 'Kv_r_pl', 0.56, 'Kd_err_pl', 0.401)
% Parameter sets
parameter_sets = {
    struct('Kv', 0.8, 'Kd_r', 1.0, 'Kd_err', 0.3);
    struct('Kv', 0.8, 'Kd_r', 1.0, 'Kd_err', 0.3);
    struct('Kv', 0.8, 'Kd_r', 1, 'Kd_err', 0.3);
    struct('Kv', 0.8, 'Kd_r', 1.0, 'Kd_err', 0.3);
    struct('Kv', 0.8, 'Kd_r', 1.0, 'Kd_err', 0.31)
};

% Setup for plotting
colors = lines(length(parameter_sets));
figure;
hold on;

% Simulate and plot results
results = [];
for i = 1:length(v_initial_params)
    v_initial= v_initial_params{i}
    Kv = parameter_sets{i}.Kv
    Kv_r = parameter_sets{i}.Kd_r
    Kd_err = parameter_sets{i}.Kd_err;
%    Kd_err_p1 = parameter_sets{i}.Kd_err_pl
    H = tf([Kv_r Kd_err],[0.5 1 (Kv_r+Kd_err*t_h_tar) Kd_err]);
    H_plus = tf([Ka Kv_r_pl Kd_err_pl], [0.5 1 (Kv_r_pl + Kd_err_pl*t_h_tar) Kd_err_pl]);


    % Simulate
    simOut = sim('platoon_model.slx', 'SaveOutput', 'on');
    set_param('platoon_model', 'ZeroCrossControl', 'UseLocalSettings'); % Enable local settings
   
    % Store results - Make sure to use the correct structure and field names based on how data is logged
    tout = simOut.tout;
    data = simOut.logsout{1}.Values.Data;
    v1 = v_initial(1)
    v2 = v_initial(2)
    v3 = v_initial(3)
    v4 = v_initial(4)
    plot(tout, data, 'Color', colors(i, :), 'DisplayName', sprintf('v1=%.1f, v2=%.1f, v3=%.1f, v4=%.1f', v1,v2,v3,v4));
end

% Finalize plot
legend show;
xlabel('Time (s)');
ylabel('Output');
title('Comparison of Outputs for Different inital velocity values');
hold off;
