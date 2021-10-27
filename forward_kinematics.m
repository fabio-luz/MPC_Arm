function [pos_x, pos_y, pos_z] = forward_kinematics(x)
%% Model measures
L1 = 103;   L2 = 80;   L3 = 210;   L4 = 30;
L5 = 41.5;  L6 = 180;  L7 = 23.7;  L8 = 5.5;
%% Transformations
T0_1 = [cos(x(1)) -sin(x(1)) 0 0; sin(x(1)) cos(x(1)) 0 0; ...
    0 0 1 L1; 0 0 0 1];
T1_2 = [1 0 0 0; 0 cos(x(2)) -sin(x(2)) 0; ...
    0 sin(x(2)) cos(x(2)) L2; 0 0 0 1];
T2_3 = [1 0 0 0; 0 cos(x(3)) -sin(x(3)) 0; ...
    0 sin(x(3)) cos(x(3)) L3; 0 0 0 1];
T3_4 = [cos(x(4)) 0 sin(x(4)) 0; 0 1 0 -L5; ...
    -sin(x(4)) 0 cos(x(4)) L4; 0 0 0 1];
T4_5 = [1 0 0 0; 0 cos(x(5)) -sin(x(5)) -L6; ...
    0 sin(x(5)) cos(x(5)) 0; 0 0 0 1];
T5_6 = [cos(x(6)) 0 sin(x(6)) 0; 0 1 0 -L7; ...
    -sin(x(6)) 0 cos(x(6)) -L8; 0 0 0 1];
T0_6 = T0_1*T1_2*T2_3*T3_4*T4_5*T5_6;
%% Position
pos_x = T0_6(1,4);
pos_y = T0_6(2,4);
pos_z = T0_6(3,4);
end