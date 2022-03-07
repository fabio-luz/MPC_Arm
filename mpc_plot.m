function mpc_plot(simX, simU,simXdot, simX_no, simXdot_no, Nsim, dt,Tf, yref)
ts = linspace(0, Nsim*dt, Nsim+1);
%% Figure 1: State of each joint
figure; 
Joints = {'\theta_1', '\theta_2', '\theta_3', '\theta_4', '\theta_5', '\theta_6'};
for i=1:(length(Joints)/2)
    subplot(length(Joints)/2, 1, i);
    p = plot(ts, simX(:,i), '-', 'LineWidth', 1); grid on; hold on;
    xlabel('t [s]'); ylabel(Joints{i}, 'FontSize',15);
    datatip(p, 0, simX(1,i)); datatip(p, Tf, simX(Tf,i));
    plot(ts, simX_no(:,i), '--', 'LineWidth', 1);
    legend('Added noise', 'No noise');
end
sgtitle('State - Angle of joints [rad]');
figure;
for i=(length(Joints)/2)+1:length(Joints)
    subplot(length(Joints)/2, 1, i-3);
    p = plot(ts, simX(:,i), '-', 'LineWidth', 1); grid on; hold on;
    xlabel('t [s]'); ylabel(Joints{i}, 'FontSize',15);
    datatip(p, 0, simX(1,i)); datatip(p, Tf, simX(Tf,i));
    plot(ts, simX_no(:,i), '--', 'LineWidth', 1);
    legend('Added noise', 'No noise');
end
sgtitle('State - Angle of joints [rad]');
%% Figure 2 & 3 - Position of the robot
for i=1:length(simX(:,1))
    [pos_x(i), pos_y(i), pos_z(i)] = forward_kinematics(simX(i,:));
    [pos_x_no(i),pos_y_no(i),pos_z_no(i)]=forward_kinematics(simX_no(i,:));
end
pos = [pos_x; pos_y; pos_z]; pos_no = [pos_x_no; pos_y_no; pos_z_no];
figure; coord = {'x', 'y', 'z'};
for i=1:length(coord)
    subplot(length(coord), 1, i);
    p = plot(ts, pos(i,:),'-', 'LineWidth', 1); grid on; hold on; 
    datatip(p, 0, pos(i,1)); datatip(p, Tf, pos(i,Tf));
    plot(ts, pos_no(i,:), '--', 'LineWidth', 1); hold on;
    plot(ts, yref(i,:), 'k:','LineWidth', 1.25);
    xlabel('t [s]'); ylabel(coord{i},'FontSize',15);
    legend('y - Trajectory (noise)', ...
        'y - Trajectory (no noise)', 'y_{ref} - Reference');
end
sgtitle('Position of the end-effector');

% myVideo = VideoWriter('example3'); %open video file
% myVideo.FrameRate = 4;  %can adjust this, 5 - 10 works well for me
% myVideo.Quality = 100;
% open(myVideo)
figure; view(3); grid on; hold on
axis equal; title('Position of the end-effector');
p = plot3(pos_x(1), pos_y(1), pos_z(1), '.', 'Color', 'r','MarkerSize', 40);
datatip(p, pos_x(1), pos_y(1), pos_z(1));
plot3(yref(1,:),yref(2,:),yref(3,:),'-.', 'Color', 'k', 'MarkerSize', 20, 'LineWidth', 2);
plot3(pos_x(end), pos_y(end), pos_z(end), '.', 'Color', 'b', 'MarkerSize', 40);
% datatip(p, pos_x(end), pos_y(end), pos_z(end)); drawnow;
for i=1:length(pos_x)
    plot3(pos_x(i),pos_y(i),pos_z(i), '-o', 'Color', [0 0.4470 0.7410]);
    plot3(pos_x_no(i), pos_y_no(i), pos_z_no(i), '--*','Color', [0.8500 0.3250 0.0980]);
    % drawnow;
    % pause(dt*5);
%     frame = getframe(gcf); %get frame
%     writeVideo(myVideo, frame);
end

legend('Initial Position', 'Reference', 'End Position', ...
        'Trajectory (noise)', 'Trajectory (no noise)', 'AutoUpdate', 'off');
plot3(pos_x,pos_y,pos_z, '-o', 'Color', [0 0.4470 0.7410]);
plot3(pos_x_no, pos_y_no, pos_z_no, '--*','Color', [0.8500 0.3250 0.0980]);
drawnow;
% frame = getframe(gcf); %get frame
% writeVideo(myVideo, frame);
% writeVideo(myVideo, frame);
% writeVideo(myVideo, frame);
% writeVideo(myVideo, frame);
% writeVideo(myVideo, frame);
% writeVideo(myVideo, frame);
% writeVideo(myVideo, frame);
% writeVideo(myVideo, frame);
% writeVideo(myVideo, frame);
% writeVideo(myVideo, frame);
% close(myVideo)

%% Figure 3 - Control signal
figure; 
h = stairs(ts(1:end), simU); grid on;
h(1).LineStyle = '-'; h(2).LineStyle = '--'; 
h(3).LineStyle = ':'; h(3).Color = 'k'; h(3).LineWidth = 1.2;
h(4).LineStyle = '-.'; h(5).LineStyle = '--'; h(6).Color = 'r';
title('Control - Desired angle (Trajectory with noise)');
xlabel('t [s]'); ylabel('Angle of joints [rad]');
legend('\theta_1', '\theta_2','\theta_3','\theta_4','\theta_5','\theta_6');

%% Figure 4 - Velocity
figure;
Joints = {'$\dot{\theta_1}$','$\dot{\theta_2}$','$\dot{\theta_3}$',...
    '$\dot{\theta_4}$','$\dot{\theta_5}$','$\dot{\theta_6}$'};   
for i=1:(length(Joints)/2)
    subplot(length(Joints)/2, 1, i);
    p = plot(ts, simXdot(:,i),'-', 'LineWidth', 1); grid on; hold on;
    xlabel('t [s]'); ylabel(Joints{i}, 'FontSize',15,'interpreter', 'latex');
    datatip(p, 0, simXdot(1,i)); datatip(p, Tf, simXdot(Tf,i));
    plot(ts, simXdot_no(:,i), '--', 'LineWidth', 1);
    legend('Added noise', 'No noise');
end
sgtitle('Velocity of joints [rad/s]');
figure;  
for i=(length(Joints)/2)+1:length(Joints)
    subplot(length(Joints)/2, 1, i-3);
    p = plot(ts, simXdot(:,i),'-', 'LineWidth', 1); grid on; hold on;
    xlabel('t [s]'); ylabel(Joints{i}, 'FontSize',15,'interpreter', 'latex');
    datatip(p, 0, simXdot(1,i)); datatip(p, Tf, simXdot(Tf,i));
    plot(ts, simXdot_no(:,i), '--', 'LineWidth', 1);
    legend('Added noise', 'No noise');
end
sgtitle('Velocity of joints [rad/s]');
end