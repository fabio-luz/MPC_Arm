function [model, A, B] = arm_model()
import casadi.*
%% system dimensions
model.nx = 6; model.nu = 6;
%% system parameters
a1 = -0.83; a2 = -0.83; a3 = -0.83; a4 = -0.83; a5 = -0.83; a6 = -0.83; 
b1 = 0.83; b2 = 0.83; b3 = 0.83; b4 = 0.83; b5 = 0.83; b6 = 0.83;
A = a1*eye(6); B = b1*eye(6);
%% named symbolic variables
% state - angle of joints [rad]
theta1 = SX.sym('theta1'); theta2 = SX.sym('theta2'); 
theta3 = SX.sym('theta3'); theta4 = SX.sym('theta4');
theta5 = SX.sym('theta5'); theta6 = SX.sym('theta6'); 
% control - desired angle of joint [rad]
theta_des1 = SX.sym('theta_des1'); theta_des2 = SX.sym('theta_des2'); 
theta_des3 = SX.sym('theta_des3'); theta_des4 = SX.sym('theta_des4');
theta_des5 = SX.sym('theta_des5'); theta_des6 = SX.sym('theta_des6'); 

%% (unnamed) symbolic variables
model.sym_x = vertcat(theta1, theta2, theta3, theta4, theta5, theta6);
model.sym_xdot = SX.sym('xdot', model.nx, 1);
model.sym_u = vertcat(theta_des1, theta_des2, theta_des3, ... 
    theta_des4, theta_des5, theta_des6);

%% dynamics
model.expr_f_expl = vertcat(a1*theta1+b1*theta_des1, ...
    a2*theta2+b2*theta_des2, a3*theta3+b3*theta_des3, ...
    a4*theta4+b4*theta_des4, a5*theta5+b5*theta_des5, ...
    a6*theta6+b6*theta_des6);
%% constraints
model.expr_h = model.sym_u;
model.constr_l = [-3.054; -1.5707; -1.4101; -2.61799; -2.26893; -2.57];
model.constr_u = [3.054; 0.628319;0.994838; 2.61799;  2.26893; 2.57];

%% cost
[pos_x, pos_y, pos_z] = forward_kinematics(model.sym_x);
model.sym_pos = vertcat(pos_x,pos_y,pos_z);
sym_vel = [a1*model.sym_x(1)+b1*model.sym_u(1); ...
    a2*model.sym_x(2)+b2*model.sym_u(2); ...
    a3*model.sym_x(3)+b3*model.sym_u(3); ...
    a4*model.sym_x(4)+b4*model.sym_u(4); ...
    a5*model.sym_x(5)+b5*model.sym_u(5); ...
    a6*model.sym_x(6)+b6*model.sym_u(6)];
model.cost_expr_y = vertcat(model.sym_pos, sym_vel);
% model.cost_expr_y = vertcat(model.sym_pos, sym_vel, model.sym_u);
model.cost_expr_y_e = vertcat(model.sym_pos);
model.ny = size(model.cost_expr_y, 1);      
model.ny_e = size(model.cost_expr_y_e, 1);
model.W = 10.0*eye(model.ny); 
% model.W = diag([10 10 10 10 10 10 10 10 10 0.1 0.1 0.1 0.1 0.1 0.1]);
model.W_e = 10.0*eye(model.ny_e); 
end