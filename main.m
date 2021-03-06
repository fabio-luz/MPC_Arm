clear all; close all;
%% test of native matlab interface - acados
acados_env_variables_windows();
model_path = fullfile(pwd,'..','arm_model'); addpath(model_path);
check_acados_requirements();
%% OCP model and opts
T = 0.5; % Time of each OCP
N = 10; % Shooting nodes of each OPC
dt = T/N; % Time of each sample in each OCP
Tf = 10; % Final time
Nsim = round(Tf/dt); % Discretization of the simulation
%% Model and inputs
[model, A, B] = arm_model;
[x0, y_ref, simX_no, simXdot_no] = input_gen(Nsim, 4);

%% Simulation
[ocp_model, ocp_opts] = ocp_build(T, N, model, x0, y_ref(:,1));
ocp = acados_ocp(ocp_model, ocp_opts);
ocp.set('init_x', zeros(model.nx, N+1));
ocp.set('init_u', zeros(model.nu, N));
ocp.set('init_pi', zeros(model.nx, N));
simX = zeros(Nsim+1, model.nx); simU = zeros(Nsim+1, model.nu);
simXdot = zeros(Nsim+1, model.nx);
dist = zeros(Nsim+1,1);
t = zeros(1, Nsim+1);

for i = 1:(Nsim+1)
    tic
    % OCP - find best control option, u
    ocp.solve(); 
    curr_x = ocp.get('x', 0); curr_u = ocp.get('u', 0);
    simX(i,:) = curr_x';       simU(i,:) = curr_u';
    
    % Find new state/position, obtained by u
    simXdot(i,:) = (A*curr_x + B*curr_u); 
    x_pre = curr_x + dt*simXdot(i,:)'; 
    % Add noise
    [pos_x, pos_y, pos_z] = forward_kinematics(x_pre);
    pos = [pos_x; pos_y; pos_z];
    dist(i) = norm(y_ref(:,i) - pos);
    if dist(i) > 1
        x = noise(x_pre);
    else
        x = x_pre;
    end
    % update x0/y_ref with the new one
    ocp.set('constr_x0', x); 
    ocp.set('cost_y_ref', [y_ref(:,i); 0; 0; 0; 0; 0; 0]);
    ocp.set('cost_y_ref_e', y_ref(:,i)); 
    t(i) = toc;
end 
% figure; grid on; 
% plot(1:(Nsim+1),t, '-'); hold on; 
% dt_plot = dt + zeros(1,Nsim+1);
% plot(1:(Nsim+1), dt_plot);
% title('Computacional cost');
% xlabel('Iterations'); ylabel('Time [s]'); xlim([0 Nsim]);
% legend('OPC solve time','Sample Time');

%% Plots
mpc_plot(simX,simU,simXdot,simX_no,simXdot_no,Nsim,dt,Tf,y_ref);