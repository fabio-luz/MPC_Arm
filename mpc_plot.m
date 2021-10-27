function mpc_plot(simX, simU, simXdot, Nsim, dt,Tf, yref)
ts = linspace(0, Nsim*dt, Nsim+1);
%% Figure 1: State of each joint
figure; 
Joints = {'theta1', 'theta2', 'theta3', 'theta4', 'theta5', 'theta6'};
for i=1:(length(Joints)/2)
    subplot(length(Joints)/2, 1, i);
    p = plot(ts, simX(:,i)); grid on;
    xlabel('t [s]'); ylabel(Joints{i});
    datatip(p, 0, simX(1,i)); datatip(p, Tf, simX(Tf,i));
end
sgtitle('State - Angle of joints [rad]');
figure;
for i=(length(Joints)/2)+1:length(Joints)
    subplot(length(Joints)/2, 1, i-3);
    p = plot(ts, simX(:,i)); grid on;
    xlabel('t [s]'); ylabel(Joints{i});
    datatip(p, 0, simX(1,i)); datatip(p, Tf, simX(Tf,i));
end
sgtitle('State - Angle of joints [rad]');
%% Figure 2 & 3 - Position of the robot
for i=1:length(simX(:,1))
    [pos_x(i), pos_y(i), pos_z(i)] = forward_kinematics(simX(i,:));
end
pos = [pos_x; pos_y; pos_z]; coord = {'x', 'y', 'z'};
figure; 
for i=1:length(coord)
    subplot(length(coord), 1, i);
    p = plot(ts, pos(i,:)); grid on; hold on; 
    datatip(p, 0, pos(i,1)); datatip(p, Tf, pos(i,Tf));
    plot(ts, yref(i,:));
    xlabel('t [s]'); ylabel(coord{i});
    legend('y - Trajectory', 'y_{ref} - Reference');
end
sgtitle('Position of the end-effector');

figure; view(3); grid on; hold on
axis equal;
p = plot3(pos_x,pos_y,pos_z, '-o');
plot3(pos_x(1), pos_y(1), pos_z(1), '.', 'MarkerSize', 40);
plot3(pos_x(end), pos_y(end), pos_z(end), '.', 'Color', 'b', 'MarkerSize', 40);
plot3(yref(1,:),yref(2,:),yref(3,:),'x', 'Color', 'r', 'MarkerSize', 20, 'LineWidth', 2);
title('Position of the end-effector');
datatip(p, pos_x(1), pos_y(1), pos_z(1));
datatip(p, pos_x(end), pos_y(end), pos_z(end));
legend('Trajectory', 'Initial Position', 'End Position', 'Reference');

%% Figure 3 - Control signal
figure; 
stairs(ts(1:end), simU); grid on;
title('Control - Desired angle');
xlabel('t [s]'); ylabel('Angle of joints [rad]');
legend('theta1', 'theta2','theta3','theta4','theta5','theta6');

%% Figure 4 - Velocity
figure;
Joints = {'dtheta1','dtheta2','dtheta3','dtheta4','dtheta5','dtheta6'};   
for i=1:(length(Joints)/2)
    subplot(length(Joints)/2, 1, i);
    p = plot(ts, simXdot(:,i)); grid on;
    xlabel('t [s]'); ylabel(Joints{i});
    datatip(p, 0, simXdot(1,i)); datatip(p, Tf, simXdot(Tf,i));
end
sgtitle('Velocity of joints [rad/s]');
figure;  
for i=(length(Joints)/2)+1:length(Joints)
    subplot(length(Joints)/2, 1, i-3);
    p = plot(ts, simXdot(:,i)); grid on;
    xlabel('t [s]'); ylabel(Joints{i});
    datatip(p, 0, simXdot(1,i)); datatip(p, Tf, simXdot(Tf,i));
end
sgtitle('Velocity of joints [rad/s]');
end